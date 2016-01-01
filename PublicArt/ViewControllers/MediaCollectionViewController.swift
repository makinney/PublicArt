//
//  MediaCollectionViewController.swift
//  PublicArt
//
//  Created by Michael Kinney on 7/13/15.
//  Copyright (c) 2015 makinney. All rights reserved.
//

import UIKit
import CoreData

final class MediaCollectionViewController: UICollectionViewController {

	// MARK: Properties
	var photoImages: PhotoImages?
	private var artPiecesCollectionViewController: ArtPiecesCollectionViewController?
	private var collapseDetailViewController = true
	private var initialHorizontalSizeClass: UIUserInterfaceSizeClass?
	private var maxCellWidth: CGFloat = 0.0
	private var error:NSError?
	private let moc: NSManagedObjectContext?
	private var media = [String]()
	private var selectedMediumName: String?
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
		
		title = "Media" // TITLE
		
		let nibName = UINib(nibName: CellIdentifier.MediaCollectionViewCell.rawValue, bundle: nil) // TODO:
		self.collectionView?.registerNib(nibName, forCellWithReuseIdentifier: CellIdentifier.MediaCollectionViewCell.rawValue)
		setupMediaFlowLayout()
		
		fetchResultsController.delegate = self
		do {
			try fetchResultsController.performFetch()
		} catch let error1 as NSError {
			error = error1
		}
		let art = fetchResultsController.fetchedObjects as! [Art]
		media = createMediaNameList(art)
		collectionView?.reloadData()
		
	}
	
	func createMediaNameList(artwork: [Art]) -> [String] {
		var mediaName = [String]()
		var lastMedium = String()
		for art in artwork {
			if art.medium != lastMedium {
				mediaName.append(art.medium)
				lastMedium = art.medium
			}
		}
		return mediaName
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		if UIScreen.mainScreen().traitCollection.horizontalSizeClass == .Regular,
			let selectedMediumName = selectedMediumName {
				let filter = ArtPiecesCollectionViewDataFilter(key: "medium", value: selectedMediumName, title: selectedMediumName)
				if let navigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ArtPiecesNavControllerID") as? UINavigationController,
					let artPiecesCollectionViewController = navigationController.viewControllers.last as? ArtPiecesCollectionViewController {
						artPiecesCollectionViewController.fetchFilter(filter)
						showDetailViewController(navigationController, sender: self)
				}
		}
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
	}
	
	override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
		setupMediaFlowLayout()
		collectionView?.reloadData()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		print("\(__FILE__) \(__FUNCTION__)")
	}
	
	// MARK: Fetch Results Controller
	//
	lazy var fetchResultsController:NSFetchedResultsController = {
		let fetchRequest = NSFetchRequest(entityName:ModelEntity.art)
		let sortDescriptor = [NSSortDescriptor(key:ModelAttributes.medium, ascending:true, selector: "localizedStandardCompare:")]
		fetchRequest.sortDescriptors = sortDescriptor
		let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.moc!, sectionNameKeyPath: nil, cacheName: nil)
		return frc
		}()
	
	// MARK: - Navigation
	
	func setupMediaFlowLayout() {
		if let collectionViewFlowLayout: UICollectionViewFlowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
			collectionViewFlowLayout.scrollDirection = .Vertical
			let masterViewsWidth = splitViewController?.primaryColumnWidth ?? 100
			collectionViewFlowLayout.headerReferenceSize = CGSize(width: 0, height: 0)
			
			collectionViewFlowLayout.minimumLineSpacing = 1
			var minimumCellsPerLine = 2 // ultimately up to flow layout
			
			userInterfaceIdion = traitCollection.userInterfaceIdiom
			if userInterfaceIdion == .Phone || userInterfaceIdion == .Unspecified {
				let sectionInset: CGFloat = 1.0
				collectionViewFlowLayout.sectionInset.top = sectionInset
				collectionViewFlowLayout.sectionInset.left = sectionInset
				collectionViewFlowLayout.sectionInset.right = sectionInset
				let itemSpacing: CGFloat = 1.0
				collectionViewFlowLayout.minimumInteritemSpacing = itemSpacing
				
				
				minimumCellsPerLine = 1
				maxCellWidth = cellWidthToUse(masterViewsWidth, cellsPerLine: minimumCellsPerLine, itemSpacing: itemSpacing, flowLayout: collectionViewFlowLayout)
				collectionViewFlowLayout.itemSize = CGSize(width: maxCellWidth, height: maxCellWidth / 8.0) // TODO: hard constant hack for aspect ratio
			} else {
				let sectionInset: CGFloat = 2.0
				collectionViewFlowLayout.sectionInset.top = sectionInset
				collectionViewFlowLayout.sectionInset.left = sectionInset
				collectionViewFlowLayout.sectionInset.right = sectionInset
				let itemSpacing: CGFloat = 2.0
				collectionViewFlowLayout.minimumInteritemSpacing = itemSpacing
				minimumCellsPerLine = 1
				maxCellWidth = cellWidthToUse(masterViewsWidth, cellsPerLine: minimumCellsPerLine, itemSpacing: itemSpacing, flowLayout: collectionViewFlowLayout)
				collectionViewFlowLayout.itemSize = CGSize(width: maxCellWidth, height: (maxCellWidth / 8.0))
			}
		}
	}
	
	func cellWidthToUse(screenWidth: CGFloat, cellsPerLine: Int, itemSpacing: CGFloat, flowLayout:UICollectionViewFlowLayout ) -> CGFloat {
		let numCells: CGFloat = CGFloat(cellsPerLine)
		var totalInterItemSpacing: CGFloat = 0.0
		var totalInsetSpacing: CGFloat = 0.0
		var totalSpacing: CGFloat = 0.0
		var spaceLeftForCells: CGFloat = 0.0
		var cellWidth: CGFloat = 0.0
		
		totalInterItemSpacing = numCells * itemSpacing
		totalInsetSpacing = flowLayout.sectionInset.left + flowLayout.sectionInset.right
		totalSpacing = totalInterItemSpacing + totalInsetSpacing
		spaceLeftForCells = screenWidth - totalSpacing
		cellWidth = spaceLeftForCells / numCells
		return cellWidth
	}
	
	
	
	// MARK: UICollectionViewDataSource
	
	override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CellIdentifier.MediaCollectionViewCell.rawValue, forIndexPath: indexPath) as! MediaCollectionViewCell
		let mediumName = media[indexPath.row] as String
		cell.title.text = mediumName
		cell.backgroundColor = UIColor.blackColor()
		cell.title.textColor = UIColor.sfOrangeColor()
		return cell
	}
	
	override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return 1
	}
	
	override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return media.count
	}
	
	// MARK: UICollectionViewDelegate
	
	override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		selectedMediumName = media[indexPath.row] as String
		let filter = ArtPiecesCollectionViewDataFilter(key: "medium", value: selectedMediumName!, title: selectedMediumName!)
	
		if UIScreen.mainScreen().traitCollection.horizontalSizeClass == .Compact {
			artPiecesCollectionViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ArtPiecesViewControllerID") as? ArtPiecesCollectionViewController
			if artPiecesCollectionViewController != nil {
				artPiecesCollectionViewController!.fetchFilter(filter)
				artPiecesCollectionViewController!.photoImages = photoImages
				showDetailViewController(artPiecesCollectionViewController!, sender: self)
			}
		} else {
			if let navigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ArtPiecesNavControllerID") as? UINavigationController,
				let artPiecesCollectionViewController = navigationController.viewControllers.last as? ArtPiecesCollectionViewController {
					artPiecesCollectionViewController.fetchFilter(filter)
					artPiecesCollectionViewController.photoImages = photoImages
					showDetailViewController(navigationController, sender: self)
			}
		}
	}
	
	override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
		return true
	}
	
	override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
		return true
	}
	
	override func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
		let indexPathsVisible = collectionView.indexPathsForVisibleItems()
		for path in indexPathsVisible {
					let cell = collectionView.cellForItemAtIndexPath(path) as? MediaCollectionViewCell
					cell?.backgroundColor = UIColor.blackColor()
					cell?.title.textColor = UIColor.sfOrangeColor()
		}
		
		if UIScreen.mainScreen().traitCollection.horizontalSizeClass == .Regular {
			let cell = collectionView.cellForItemAtIndexPath(indexPath) as? MediaCollectionViewCell
			cell?.backgroundColor = UIColor.whiteColor()
			cell?.title.textColor = UIColor.blackColor()
		}
	}
	
}

extension MediaCollectionViewController : NSFetchedResultsControllerDelegate {
	
	func controllerDidChangeContent(controller: NSFetchedResultsController) {
		let art = fetchResultsController.fetchedObjects as! [Art]
		media = createMediaNameList(art)
		collectionView?.reloadData()
	}
}


