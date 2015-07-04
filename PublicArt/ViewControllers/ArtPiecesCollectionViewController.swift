//
//  ArtPiecesCollectionViewController.swift
//  ArtCity
//
//  Created by Michael Kinney on 5/2/15.
//  Copyright (c) 2015 mkinney. All rights reserved.
//

import UIKit
import CoreData


class ArtPiecesCollectionViewController: UICollectionViewController, UINavigationControllerDelegate, UICollectionViewDelegateFlowLayout {
	private var collapseDetailViewController = true
	private var initialHorizontalSizeClass: UIUserInterfaceSizeClass?
	private var maxPhotoWidth: CGFloat = 0.0

	private var error:NSError?
	private let moc: NSManagedObjectContext?
	
	var location: Location?
	
//	private lazy var artNavController:UINavigationController = {
//		var navigationController:UINavigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(ViewControllerIdentifier.ArtNavigationController.rawValue) as! UINavigationController
//		var vc = navigationController.viewControllers.last as! UIViewController!
//		vc.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
//		vc.navigationItem.leftItemsSupplementBackButton = true
//		return navigationController
//		}()

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
		navigationController?.interactivePopGestureRecognizer?.enabled = false
		navigationController?.delegate = self
		
		if let location = self.location {
			title = location.name // TITLE
		} else {
			title = "Titles"  // TITLE TODO: constant
		}
		
		
		var nibName = UINib(nibName: "ArtworkCollectionViewCell", bundle: nil) // TODO:
		self.collectionView?.registerNib(nibName, forCellWithReuseIdentifier: "ArtworkCollectionViewCell")
//		var subNibName = UINib(nibName: "ArtCitySupplementaryView", bundle: nil) // TODO:
//		self.collectionView?.registerNib(subNibName, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "ArtCitySupplementaryView")
		
		setupArtCityPhotosFlowLayout()
		
		NSNotificationCenter.defaultCenter().addObserver(self,
			selector:"newArtCityDatabase:",
			name: ArtAppNotifications.NewArtCityDatabase.rawValue,
			object: nil)
		
		
		NSNotificationCenter.defaultCenter().addObserver(self,
			selector: "contentSizeCategoryDidChange",
			name: UIContentSizeCategoryDidChangeNotification,
			object: nil)
		
		fetchResultsController.delegate = self
		fetchResultsController.performFetch(&error)
		
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
//		collectionView?.reloadData()
	}
	
	// TODO: fix rotations - note may have to pass transition to size to setupArtCityViewController
	override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
//		if self.view.frame.size.width != size.width ||
//			self.view.frame.size.height != size.height {
//				setupArtCityPhotosFlowLayout()
//				collectionView?.reloadData()
//		
//		}
//		if initialHorizontalSizeClass == .Compact {
//			displayDefaultArt()
//		}
	}
	// TODO: fix for rotation
	override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
		if let previousTraitCollection = previousTraitCollection {
			userInterfaceIdion = traitCollection.userInterfaceIdiom
			if userInterfaceIdion == .Pad {
				setupArtCityPhotosFlowLayout()
				collectionView?.reloadData()
			} else if traitCollection.horizontalSizeClass != previousTraitCollection.horizontalSizeClass ||
				traitCollection.verticalSizeClass != previousTraitCollection.verticalSizeClass {
				setupArtCityPhotosFlowLayout()
				collectionView?.reloadData()
			}
		}
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning() // TODO: FIXME this happens when rotating and trying different images
		println("\(__FILE__) did receive memory warning")

	}

	// MARK: Fetch Results Controller
	//
	lazy var fetchResultsController:NSFetchedResultsController = {
		let fetchRequest = NSFetchRequest(entityName:ModelEntity.art)
		
		if let location = self.location {
			fetchRequest.predicate = NSPredicate(format:"%K == %@", "idLocation", location.idLocation) // TODO: define
		}

		let sortDescriptor = [NSSortDescriptor(key:ModelAttributes.artworkTitle, ascending:true, selector: "localizedStandardCompare:")]
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
	
	func setupArtCityPhotosFlowLayout() {
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

				
				minimumPhotosPerLine = 2
				maxPhotoWidth = photoWidthAvailable(masterViewsWidth, photosPerLine: minimumPhotosPerLine, itemSpacing: itemSpacing, flowLayout: collectionViewFlowLayout)
				collectionViewFlowLayout.itemSize = CGSize(width: maxPhotoWidth, height: maxPhotoWidth) // TODO: hard constant hack for aspect ratio
			} else {
				let sectionInset: CGFloat = 5.0
				collectionViewFlowLayout.sectionInset.left = sectionInset
				collectionViewFlowLayout.sectionInset.right = sectionInset
				let itemSpacing: CGFloat = sectionInset / 2.0
				collectionViewFlowLayout.minimumInteritemSpacing = itemSpacing
				minimumPhotosPerLine = 2
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
	
		
	override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CellIdentifier.ArtworkCollectionViewCell.rawValue, forIndexPath: indexPath) as! ArtworkCollectionViewCell
		let art = fetchResultsController.objectAtIndexPath(indexPath) as! Art
		cell.title.text = art.title
		cell.imageView.image = nil
		// TODO add activity indicators
		if let thumb = art.thumb {
			cell.imageFileName = thumb.imageFileName
			ImageDownload.downloadThumb(art, complete: { (data, imageFileName) -> () in
				if let data = data
				   where cell.imageFileName == imageFileName {
					cell.imageView.image = UIImage(data: data) ?? UIImage()
				}
			})
		}
		
		return cell
	}
		
	
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
		
		// default square
		var height: CGFloat = maxPhotoWidth
		var width: CGFloat = maxPhotoWidth
	
		if let art = fetchResultsController.objectAtIndexPath(indexPath) as? Art {
			if let thumb = art.thumb {
				var aspectRatio = thumb.imageAspectRatio
				if aspectRatio > 0 && aspectRatio <= 1 {
					height = width / CGFloat(aspectRatio.doubleValue) + 21.0 // FIXME: hack based on label height
				} else if aspectRatio > 1 {
					width = width * 2.0  // FIXME fine tune
					height = width / CGFloat(aspectRatio.doubleValue) + 21.0 // FIXME: hack based on label height
				}
			}
			
		}
		
		return CGSize(width: width, height: height)
	}
	
	
	override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return fetchResultsController.sections?.count ?? 0
	}
	
	override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		let sectionInfo = fetchResultsController.sections![section] as! NSFetchedResultsSectionInfo
		return sectionInfo.numberOfObjects
	}
	
	// MARK: ArtPhotos Navigation
	
	override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		if let art = fetchResultsController.objectAtIndexPath(indexPath) as? Art {
		
			var singleArtViewController: SingleArtViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(ViewControllerIdentifier.SingleArtViewController.rawValue) as! SingleArtViewController
			singleArtViewController.updateArt(art, artBackgroundColor: nil)
			showViewController(singleArtViewController, sender: self)
			
//			if let singleArtViewController = artNavController.viewControllers.last as? SingleArtViewController {
//				singleArtViewController.updateArt(art, artBackgroundColor: nil)
//				showDetailViewController(artNavController, sender: self)
//			}
		}
	}

	// MARK: Notification handlers
	
//	func contentSizeCategoryDidChange() {
//		collectionView?.reloadData()
//	}
	
	func newArtCityDatabase(notification: NSNotification) {
		collectionView?.reloadData()
	}
	
	// MARK: Misc
	func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
		//		self.collectionView?.alpha = 0.0
	}
	
	func navigationController(navigationController: UINavigationController, didShowViewController viewController: UIViewController, animated: Bool) {
		//		self.collectionView?.alpha = 1.0
	}
	
	//	override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
	//		var supplementaryView: UICollectionReusableView = UICollectionReusableView()
	//		if kind == UICollectionElementKindSectionHeader {
	//			supplementaryView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "ArtCitySupplementaryView", forIndexPath: indexPath) as! UICollectionReusableView // TODO:
	//			if let supplementaryView = supplementaryView as? ArtCitySupplementaryView {
	//				if let sections = fetchResultsController.sections {
	//					var tableSections = sections as NSArray
	//					var locationSection = tableSections[indexPath.section] as! NSFetchedResultsSectionInfo
	//					supplementaryView.label.text = locationSection.name ?? ""
	//					supplementaryView.label.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody) // TODO: has to be a better way
	//				}
	//			}
	//
	//		}
	//		return supplementaryView
	//	}

//	override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
//		super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
//		
//		if let artPhotoCollectionViewFlowLayout = self.artPhotoCollectionViewFlowLayout {
//			artPhotoCollectionViewFlowLayout.currentPage = collectionView!.contentOffset.x / collectionView!.bounds.width
//		}
//		
//		coordinator.animateAlongsideTransitionInView(view, animation: { (context) -> Void in
//			if let artPhotoCollectionViewFlowLayout = self.artPhotoCollectionViewFlowLayout {
//				self.setupArtPhotosFullScreenItemSize(artPhotoCollectionViewFlowLayout)
//			}
//			
//			}) { (context) -> Void in
//				var i = 0.0
//		}
//	}
	

	
	// MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}

extension ArtPiecesCollectionViewController : NSFetchedResultsControllerDelegate {
	
	func controllerDidChangeContent(controller: NSFetchedResultsController) {
		collectionView?.reloadData()
	}
}

