 //
//  LocationsCollectionViewController.Swift
//  PublicArt
//
//  Created by Michael Kinney on 6/5/15.
//  Copyright (c) 2015 makinney. All rights reserved.
//

import UIKit
import CoreData

class LocationsCollectionViewController: UICollectionViewController, UINavigationControllerDelegate, UICollectionViewDelegateFlowLayout {

	// MARK: Properties
	private var collapseDetailViewController = true
	private var initialHorizontalSizeClass: UIUserInterfaceSizeClass?
	private var maxPhotoWidth: CGFloat = 0.0
	
	private var error:NSError?
	private let moc: NSManagedObjectContext?

	
	private var userInterfaceIdion: UIUserInterfaceIdiom = .Phone
	
	override init(collectionViewLayout: UICollectionViewLayout) {
		moc = CoreDataStack.sharedInstance.managedObjectContext
		super.init(collectionViewLayout: collectionViewLayout)
	}
	
	required init(coder aDecoder: NSCoder) {
		moc = CoreDataStack.sharedInstance.managedObjectContext
		super.init(coder:aDecoder)
	}
	
	deinit {
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = "Locations" // TITLE
		
		var nibName = UINib(nibName: CellIdentifier.LocationCollectionViewCell.rawValue, bundle: nil) // TODO:
		self.collectionView?.registerNib(nibName, forCellWithReuseIdentifier: CellIdentifier.LocationCollectionViewCell.rawValue)
		setupLocationPhotosFlowLayout()
		
		NSNotificationCenter.defaultCenter().addObserver(self,
			selector:"newArtCityDatabase:",
			name: ArtAppNotifications.NewArtCityDatabase.rawValue,
			object: nil)
		
		fetchResultsController.delegate = self
		fetchResultsController.performFetch(&error)
		
		collectionView?.reloadData()
		
		userInterfaceIdion = traitCollection.userInterfaceIdiom
		if userInterfaceIdion == .Pad {
			displayDefaultArt()
		}
		
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
	}
	
//	override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
//		if initialHorizontalSizeClass == .Compact {
//			displayDefaultArt()
//		}
//	}
	
	override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
		setupLocationPhotosFlowLayout()
		collectionView?.reloadData()
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        println("\(__FILE__) \(__FUNCTION__)")
    }

	// MARK: Fetch Results Controller
	//
	lazy var fetchResultsController:NSFetchedResultsController = {
		let fetchRequest = NSFetchRequest(entityName:ModelEntity.location)
		let sortDescriptor = [NSSortDescriptor(key:ModelAttributes.locationName, ascending:true, selector: "localizedStandardCompare:")]
		fetchRequest.sortDescriptors = sortDescriptor
		let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.moc!, sectionNameKeyPath: nil, cacheName: nil)
		return frc
		}()
	
	func displayDefaultArt() {
		if fetchResultsController.fetchedObjects?.count > 0 {
			var indexPath = NSIndexPath(forItem: 0, inSection: 0)
			if let art = fetchResultsController.objectAtIndexPath(indexPath) as? Art {
				//				if let singleArtViewController = artNavController.viewControllers.last as? SingleArtViewController {
				//						artPhotoImages.getImage(art.thumbFile, completion: { [weak self] (image) -> () in
				//						if let image = image {
				//							singleArtViewController.updateArt(art, artBackgroundColor: nil)
				//						}
				//					})
				//					showDetailViewController(artNavController, sender: self)
				//				}
			}
		}
	}


    // MARK: - Navigation
	
	func setupLocationPhotosFlowLayout() {
		if let collectionViewFlowLayout: UICollectionViewFlowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
			collectionViewFlowLayout.scrollDirection = .Vertical
			var masterViewsWidth = splitViewController?.primaryColumnWidth ?? 100
			collectionViewFlowLayout.headerReferenceSize = CGSize(width: 0, height: 0)
			
			collectionViewFlowLayout.minimumLineSpacing = 5
			var minimumPhotosPerLine = 2 // ultimately up to flow layout
			
			userInterfaceIdion = traitCollection.userInterfaceIdiom
			if userInterfaceIdion == .Phone || userInterfaceIdion == .Unspecified {
				let sectionInset: CGFloat = 5.0
				collectionViewFlowLayout.sectionInset.left = sectionInset
				collectionViewFlowLayout.sectionInset.right = sectionInset
				let itemSpacing: CGFloat = sectionInset / 2.0
				collectionViewFlowLayout.minimumInteritemSpacing = itemSpacing
				
				
				minimumPhotosPerLine = 3
				maxPhotoWidth = photoWidthAvailable(masterViewsWidth, photosPerLine: minimumPhotosPerLine, itemSpacing: itemSpacing, flowLayout: collectionViewFlowLayout)
				collectionViewFlowLayout.itemSize = CGSize(width: maxPhotoWidth, height: maxPhotoWidth) // TODO: hard constant hack for aspect ratio
			} else {
				let sectionInset: CGFloat = 5.0
				collectionViewFlowLayout.sectionInset.left = sectionInset
				collectionViewFlowLayout.sectionInset.right = sectionInset
				let itemSpacing: CGFloat = sectionInset / 2.0
				collectionViewFlowLayout.minimumInteritemSpacing = itemSpacing
				minimumPhotosPerLine = 3
				maxPhotoWidth = photoWidthAvailable(masterViewsWidth, photosPerLine: minimumPhotosPerLine, itemSpacing: itemSpacing, flowLayout: collectionViewFlowLayout)
				collectionViewFlowLayout.itemSize = CGSize(width: maxPhotoWidth, height: maxPhotoWidth)
			}
		}
	}
	
	func photoWidthAvailable(screenWidth: CGFloat, photosPerLine: Int, itemSpacing: CGFloat, flowLayout:UICollectionViewFlowLayout ) -> CGFloat {
		let numPhotos: CGFloat = CGFloat(photosPerLine)
		var totalInterItemSpacing: CGFloat = 0.0
		var totalInsetSpacing: CGFloat = 0.0
		var totalSpacing: CGFloat = 0.0
		var spaceLeftForPhotos: CGFloat = 0.0
		var photoWidth: CGFloat = 0.0
		
		totalInterItemSpacing = numPhotos * itemSpacing
		totalInsetSpacing = flowLayout.sectionInset.left + flowLayout.sectionInset.right
		totalSpacing = totalInterItemSpacing + totalInsetSpacing
		spaceLeftForPhotos = screenWidth - totalSpacing
		photoWidth = spaceLeftForPhotos / numPhotos
		return photoWidth
	}
	
	
	
    // MARK: UICollectionViewDataSource
	
	override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CellIdentifier.LocationCollectionViewCell.rawValue, forIndexPath: indexPath) as! LocationCollectionViewCell
		let location = fetchResultsController.objectAtIndexPath(indexPath) as! Location
	
		cell.title.text = location.name

		if location.artwork.count > 0 {
			cell.title.textColor = UIColor.blackColor()
			cell.backgroundColor = UIColor.whiteColor()
		} else if location.name != "All" { 
			cell.title.textColor =  UIColor.grayColor()
			cell.backgroundColor = UIColor.lightGrayColor()
		}
		
		return cell
	}
	
	override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return fetchResultsController.sections?.count ?? 0
	}
	
	override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		let sectionInfo = fetchResultsController.sections![section] as! NSFetchedResultsSectionInfo
		return sectionInfo.numberOfObjects
	}
	
    // MARK: UICollectionViewDelegate
	
	override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		if let location = fetchResultsController.objectAtIndexPath(indexPath) as? Location {
			var navigationController:UINavigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ArtPiecesNavControllerID") as! UINavigationController
			var vc: ArtPiecesCollectionViewController = navigationController.viewControllers.last as! ArtPiecesCollectionViewController
			vc.location = location
			showDetailViewController(navigationController, sender: self)
		}
	}
	

	// Uncomment this method to specify if the specified item should be selected
	override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
		let location = fetchResultsController.objectAtIndexPath(indexPath) as! Location
		if location.artwork.count > 0 {
			return true
		}
		return false
	}


    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
		let location = fetchResultsController.objectAtIndexPath(indexPath) as! Location
		if location.artwork.count > 0 {
			return true
		}
		return false
    }
	
	override func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
		var indexPathsVisible = collectionView.indexPathsForVisibleItems()
		for path in indexPathsVisible { // hack fix for bug where delected cells still look selected, sometimes
			if let visiblePath = path as? NSIndexPath {
				let location = fetchResultsController.objectAtIndexPath(visiblePath) as! Location
				if location.artwork.count > 0 {
					var cell = collectionView.cellForItemAtIndexPath(visiblePath) as? LocationCollectionViewCell
					cell?.backgroundColor = UIColor.whiteColor()
					cell?.title.textColor = UIColor.blackColor()
				}
			}
		}
	
		var cell = collectionView.cellForItemAtIndexPath(indexPath) as? LocationCollectionViewCell
		cell?.backgroundColor = UIColor.blueColor()
		cell?.title.textColor = UIColor.whiteColor()
	}
	
}

extension LocationsCollectionViewController : NSFetchedResultsControllerDelegate {
	
	func controllerDidChangeContent(controller: NSFetchedResultsController) {
		collectionView?.reloadData()
	}
}


