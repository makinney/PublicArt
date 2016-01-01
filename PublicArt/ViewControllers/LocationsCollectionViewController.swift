 //
//  LocationsCollectionViewController.Swift
//  PublicArt
//
//  Created by Michael Kinney on 6/5/15.
//  Copyright (c) 2015 makinney. All rights reserved.
//

import UIKit
import CoreData


final class LocationsCollectionViewController: UICollectionViewController, UINavigationControllerDelegate, UICollectionViewDelegateFlowLayout {

	// MARK: Properties
	var photoImages: PhotoImages?
	private var artPiecesCollectionViewController: ArtPiecesCollectionViewController?
//	private var artPiecesNavigationController: UINavigationController
//	private var detailViewController: UIViewController?
	private var collapseDetailViewController = true
	private var initialHorizontalSizeClass: UIUserInterfaceSizeClass?
	private var selectedLocation: Location?
	
	private var error:NSError?
	private let moc: NSManagedObjectContext?
	
	var fetchFilterKey: String?
	var fetchFilterValue: String?
	
	private var userInterfaceIdion: UIUserInterfaceIdiom = .Phone
	
	override init(collectionViewLayout: UICollectionViewLayout) {
		moc = CoreDataStack.sharedInstance.managedObjectContext
		super.init(collectionViewLayout: collectionViewLayout)
	}
	
	required init?(coder aDecoder: NSCoder) {
		moc = CoreDataStack.sharedInstance.managedObjectContext
		super.init(coder:aDecoder)
	}
	
	deinit {
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = "Location" // TITLE
		
		
		let nibName = UINib(nibName: CellIdentifier.LocationCollectionViewCell.rawValue, bundle: nil) // TODO:
		self.collectionView?.registerNib(nibName, forCellWithReuseIdentifier: CellIdentifier.LocationCollectionViewCell.rawValue)
		setupFlowLayout()
		
		fetchResultsController.delegate = self
		do {
			try fetchResultsController.performFetch()
		} catch let error1 as NSError {
			error = error1
		}
		
		//
//		if UIScreen.mainScreen().traitCollection.horizontalSizeClass == .Compact {
//			if let artPiecesCollectionViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ArtPiecesViewControllerID") as? ArtPiecesCollectionViewController {
//				self.artPiecesCollectionViewController = artPiecesCollectionViewController
//				detailViewController = self.artPiecesCollectionViewController
//			}
//		} else {
//			if let navigationController:UINavigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ArtPiecesNavControllerID") as? UINavigationController,
//				let artPiecesCollectionViewController = navigationController.viewControllers.last as? ArtPiecesCollectionViewController {
//				self.artPiecesNavigationController = navigationController
//				detailViewController = self.artPiecesNavigationController
//				self.artPiecesCollectionViewController = artPiecesCollectionViewController
//			}
//		}
		
		collectionView?.reloadData()
	}
	
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		if UIScreen.mainScreen().traitCollection.horizontalSizeClass == .Regular,
			let selectedLocation = selectedLocation {
				showArtPiecesFromNavController(selectedLocation)
		}
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
		setupFlowLayout()
		collectionView?.reloadData()
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("\(__FILE__) \(__FUNCTION__)")
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
	
    // MARK: - Navigation
	
	func setupFlowLayout() {
		if let collectionViewFlowLayout: UICollectionViewFlowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
			collectionViewFlowLayout.scrollDirection = .Vertical
			let masterViewsWidth = splitViewController?.primaryColumnWidth ?? 100
			collectionViewFlowLayout.headerReferenceSize = CGSize(width: 0, height: 0)
			var maxCellWidth: CGFloat = 0.0

			collectionViewFlowLayout.minimumLineSpacing = 2
			var minimumNumberCellsPerLine = 2 // ultimately up to flow layout
			
			userInterfaceIdion = traitCollection.userInterfaceIdiom
			if userInterfaceIdion == .Phone || userInterfaceIdion == .Unspecified {
				let sectionInset: CGFloat = 1.0
				collectionViewFlowLayout.sectionInset.top = sectionInset
				collectionViewFlowLayout.sectionInset.left = sectionInset
				collectionViewFlowLayout.sectionInset.right = sectionInset
				let itemSpacing: CGFloat = 1.0
				collectionViewFlowLayout.minimumInteritemSpacing = itemSpacing
				minimumNumberCellsPerLine = 3
				maxCellWidth = cellWidthAvailable(masterViewsWidth, cellsPerLine: minimumNumberCellsPerLine, itemSpacing: itemSpacing, flowLayout: collectionViewFlowLayout)
				collectionViewFlowLayout.itemSize = CGSize(width: maxCellWidth, height: maxCellWidth) 
			} else {
				let sectionInset: CGFloat = 2.0
				collectionViewFlowLayout.sectionInset.top = sectionInset
				collectionViewFlowLayout.sectionInset.left = sectionInset
				collectionViewFlowLayout.sectionInset.right = sectionInset
				let itemSpacing: CGFloat = 2.0
				collectionViewFlowLayout.minimumInteritemSpacing = itemSpacing
				minimumNumberCellsPerLine = 3
				maxCellWidth = cellWidthAvailable(masterViewsWidth, cellsPerLine: minimumNumberCellsPerLine, itemSpacing: itemSpacing, flowLayout: collectionViewFlowLayout)
				collectionViewFlowLayout.itemSize = CGSize(width: maxCellWidth, height: maxCellWidth)
			}
		}
	}
	
	func cellWidthAvailable(screenWidth: CGFloat, cellsPerLine: Int, itemSpacing: CGFloat, flowLayout:UICollectionViewFlowLayout ) -> CGFloat {
		let numCells: CGFloat = CGFloat(cellsPerLine)
		var totalInterItemSpacing: CGFloat = 0.0
		var totalInsetSpacing: CGFloat = 0.0
		var totalSpacing: CGFloat = 0.0
		var spaceLeftForCells: CGFloat = 0.0
		var cell: CGFloat = 0.0
		
		totalInterItemSpacing = numCells * itemSpacing
		totalInsetSpacing = flowLayout.sectionInset.left + flowLayout.sectionInset.right
		totalSpacing = totalInterItemSpacing + totalInsetSpacing
		spaceLeftForCells = screenWidth - totalSpacing
		cell = spaceLeftForCells / numCells
		return cell
	}
	
	func resetVisibleCellBackgroundColors() {
		if let indexPathsVisible = self.collectionView?.indexPathsForVisibleItems() ,
			let collectionView = collectionView {
				for path in indexPathsVisible { // hack fix for bug where deselected cells still look selected, sometimes
					let location = fetchResultsController.objectAtIndexPath(path) as! Location
					if location.artwork.count > 0 || location.name == "All"{
						let cell = collectionView.cellForItemAtIndexPath(path) as? LocationCollectionViewCell
						cell?.backgroundColor = UIColor.blackColor()
						cell?.title.textColor = UIColor.sfOrangeColor()
					}
				}
		}
	}
	
    // MARK: UICollectionViewDataSource
	
	override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CellIdentifier.LocationCollectionViewCell.rawValue, forIndexPath: indexPath) as! LocationCollectionViewCell
		let location = fetchResultsController.objectAtIndexPath(indexPath) as! Location
	
		if location.name != "All" {
			cell.title.text = location.name
		} else {
			cell.title.text = "San Francisco"
		}

		if location.artwork.count > 0 || location.name == "All" {
			cell.backgroundColor = UIColor.blackColor()
			cell.title.textColor = UIColor.sfOrangeColor()
		} else  {
			cell.backgroundColor = UIColor.lightGrayColor()
			cell.title.textColor =  UIColor.grayColor()
		}
		
		return cell
	}
	
	override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return fetchResultsController.sections?.count ?? 0
	}
	
	override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		let sectionInfo = fetchResultsController.sections![section] 
		return sectionInfo.numberOfObjects
	}
	
    // MARK: UICollectionViewDelegate
//	
//	override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//		if let location = fetchResultsController.objectAtIndexPath(indexPath) as? Location {
//			if location.name != "All" {
//				let filter = ArtPiecesCollectionViewDataFilter(key: "idLocation", value: location.idLocation, title: location.name)
//				artPiecesCollectionViewController.fetchFilter(filter)
//			} else {
//				artPiecesCollectionViewController.pageTitle = "San Francisco"
//			}
//			showDetailViewController(detailViewController, sender: self)
//		}
//	}
	
	override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		if let location = fetchResultsController.objectAtIndexPath(indexPath) as? Location {
			selectedLocation = location
			if UIScreen.mainScreen().traitCollection.horizontalSizeClass == .Compact {
				showArtPiecesWithoutNavController(location)
			} else {
				showArtPiecesFromNavController(location)
			}
		}
	}
	
	func showArtPiecesFromNavController(location: Location) {
		if let navigationController:UINavigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ArtPiecesNavControllerID") as? UINavigationController,
			let artPiecesCollectionViewController = navigationController.viewControllers.last as? ArtPiecesCollectionViewController {
				artPiecesCollectionViewController.photoImages = photoImages
				if location.name != "All" {
					let filter = ArtPiecesCollectionViewDataFilter(key: "idLocation", value: location.idLocation, title: location.name)
					artPiecesCollectionViewController.fetchFilter(filter)
				} else {
					artPiecesCollectionViewController.pageTitle = "San Francisco"
				}
				
				showDetailViewController(navigationController, sender: self)
		}
	}
	
	func showArtPiecesWithoutNavController(location: Location) {
		if let artPiecesCollectionViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ArtPiecesViewControllerID") as? ArtPiecesCollectionViewController {
			artPiecesCollectionViewController.photoImages = photoImages
			if location.name != "All" {
				let filter = ArtPiecesCollectionViewDataFilter(key: "idLocation", value: location.idLocation, title: location.name)
				artPiecesCollectionViewController.fetchFilter(filter)
			} else {
				artPiecesCollectionViewController.pageTitle = "San Francisco"
			}
			showDetailViewController(artPiecesCollectionViewController, sender: self)
		}
	}

	
	override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
		let location = fetchResultsController.objectAtIndexPath(indexPath) as! Location
		if location.artwork.count > 0 || location.name == "All" {
			return true
		}
		return false
	}

    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
		let location = fetchResultsController.objectAtIndexPath(indexPath) as! Location
		if location.artwork.count > 0 || location.name == "All" {
			return true
		}
		return false
    }
	
	
	override func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
	
		resetVisibleCellBackgroundColors()
		if UIScreen.mainScreen().traitCollection.horizontalSizeClass == .Regular {
			let cell = collectionView.cellForItemAtIndexPath(indexPath) as? LocationCollectionViewCell
			cell?.backgroundColor = UIColor.whiteColor()
			cell?.title.textColor = UIColor.blackColor()
		}
	}
	
	override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
		let cell = collectionView.cellForItemAtIndexPath(indexPath) as? LocationCollectionViewCell
		cell?.backgroundColor = UIColor.blackColor()
		cell?.title.textColor = UIColor.sfOrangeColor()
	}
	
}

extension LocationsCollectionViewController : NSFetchedResultsControllerDelegate {
	
	func controllerDidChangeContent(controller: NSFetchedResultsController) {
		collectionView?.reloadData()
	}
}


