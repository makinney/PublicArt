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
	private var artPiecesCollectionViewController: ArtPiecesCollectionViewController?
	private var collapseDetailViewController = true
	private var initialHorizontalSizeClass: UIUserInterfaceSizeClass?
	
	private var error:NSError?
	private let moc: NSManagedObjectContext?
	
	var fetchFilterKey: String?
	var fetchFilterValue: String?
	
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
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = "Locations" // TITLE
		
		var nibName = UINib(nibName: CellIdentifier.LocationCollectionViewCell.rawValue, bundle: nil) // TODO:
		self.collectionView?.registerNib(nibName, forCellWithReuseIdentifier: CellIdentifier.LocationCollectionViewCell.rawValue)
		setupFlowLayout()
		
		fetchResultsController.delegate = self
		fetchResultsController.performFetch(&error)
		
		collectionView?.reloadData()
		
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
		setupFlowLayout()
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
	
    // MARK: - Navigation
	
	func setupFlowLayout() {
		if let collectionViewFlowLayout: UICollectionViewFlowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
			collectionViewFlowLayout.scrollDirection = .Vertical
			var masterViewsWidth = splitViewController?.primaryColumnWidth ?? 100
			collectionViewFlowLayout.headerReferenceSize = CGSize(width: 0, height: 0)
			var maxCellWidth: CGFloat = 0.0

			collectionViewFlowLayout.minimumLineSpacing = 5
			var minimumNumberCellsPerLine = 2 // ultimately up to flow layout
			
			userInterfaceIdion = traitCollection.userInterfaceIdiom
			if userInterfaceIdion == .Phone || userInterfaceIdion == .Unspecified {
				let sectionInset: CGFloat = 5.0
				collectionViewFlowLayout.sectionInset.left = sectionInset
				collectionViewFlowLayout.sectionInset.right = sectionInset
				let itemSpacing: CGFloat = sectionInset / 2.0
				collectionViewFlowLayout.minimumInteritemSpacing = itemSpacing
				minimumNumberCellsPerLine = 3
				maxCellWidth = cellWidthAvailable(masterViewsWidth, cellsPerLine: minimumNumberCellsPerLine, itemSpacing: itemSpacing, flowLayout: collectionViewFlowLayout)
				collectionViewFlowLayout.itemSize = CGSize(width: maxCellWidth, height: maxCellWidth) 
			} else {
				let sectionInset: CGFloat = 5.0
				collectionViewFlowLayout.sectionInset.left = sectionInset
				collectionViewFlowLayout.sectionInset.right = sectionInset
				let itemSpacing: CGFloat = sectionInset / 2.0
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
	
	
	
    // MARK: UICollectionViewDataSource
	
	override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CellIdentifier.LocationCollectionViewCell.rawValue, forIndexPath: indexPath) as! LocationCollectionViewCell
		let location = fetchResultsController.objectAtIndexPath(indexPath) as! Location
	
		cell.title.text = location.name

		if location.artwork.count > 0 || location.name == "All" {
			cell.backgroundColor = UIColor.whiteColor()
			cell.title.textColor = UIColor.blackColor()
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
		let sectionInfo = fetchResultsController.sections![section] as! NSFetchedResultsSectionInfo
		return sectionInfo.numberOfObjects
	}
	
    // MARK: UICollectionViewDelegate
	
	override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		if let location = fetchResultsController.objectAtIndexPath(indexPath) as? Location {
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
		var indexPathsVisible = collectionView.indexPathsForVisibleItems()
		for path in indexPathsVisible { // hack fix for bug where delected cells still look selected, sometimes
			if let visiblePath = path as? NSIndexPath {
				let location = fetchResultsController.objectAtIndexPath(visiblePath) as! Location
				if location.artwork.count > 0 || location.name == "All"{
					var cell = collectionView.cellForItemAtIndexPath(visiblePath) as? LocationCollectionViewCell
					cell?.backgroundColor = UIColor.whiteColor()
					cell?.title.textColor = UIColor.blackColor()
				}
			}
		}
	
		var cell = collectionView.cellForItemAtIndexPath(indexPath) as? LocationCollectionViewCell
		cell?.backgroundColor = UIColor.selectionBackgroundHighlite()
		cell?.title.textColor = UIColor.whiteColor()
	}
	
}

extension LocationsCollectionViewController : NSFetchedResultsControllerDelegate {
	
	func controllerDidChangeContent(controller: NSFetchedResultsController) {
		collectionView?.reloadData()
	}
}


