//
//  TitlesCollectionViewController.swift
//  PublicArt
//
//  Created by Michael Kinney on 7/13/15.
//  Copyright (c) 2015 makinney. All rights reserved.
//

import UIKit
import CoreData

final class TitlesCollectionViewController: UICollectionViewController {

	// MARK: Properties
	private var collapseDetailViewController = true
	private var initialHorizontalSizeClass: UIUserInterfaceSizeClass?
	private var maxCellWidth: CGFloat = 0.0
	private var error:NSError?
	private let moc: NSManagedObjectContext?
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
		
		let nibName = UINib(nibName: CellIdentifier.MediaCollectionViewCell.rawValue, bundle: nil) // TODO: view for titles
		self.collectionView?.registerNib(nibName, forCellWithReuseIdentifier: CellIdentifier.MediaCollectionViewCell.rawValue)
		
		title = "Titles"
		collectionView?.backgroundColor = UIColor.whiteColor()
		
		setupArtTitlesFlowLayout()
		
		fetchResultsController.delegate = self
		do {
			try fetchResultsController.performFetch()
		} catch let error1 as NSError {
			error = error1
		}
		collectionView?.reloadData()
		
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
	}
	
	override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
		setupArtTitlesFlowLayout()
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
		let sortDescriptor = [NSSortDescriptor(key:ModelAttributes.artworkTitle, ascending:true, selector: "localizedStandardCompare:")]
		fetchRequest.sortDescriptors = sortDescriptor
		let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.moc!, sectionNameKeyPath: nil, cacheName: nil)
		return frc
		}()
	
	// MARK: - Navigation
	
	func setupArtTitlesFlowLayout() {
		if let collectionViewFlowLayout: UICollectionViewFlowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
			collectionViewFlowLayout.scrollDirection = .Vertical
			let masterViewsWidth = splitViewController?.primaryColumnWidth ?? 100
			collectionViewFlowLayout.headerReferenceSize = CGSize(width: 0, height: 0)
			
			collectionViewFlowLayout.minimumLineSpacing = 1
			var minimumCellsPerLine = 2 // ultimately up to flow layout
			
			userInterfaceIdion = traitCollection.userInterfaceIdiom
			if userInterfaceIdion == .Phone || userInterfaceIdion == .Unspecified {
				let sectionInset: CGFloat = 2.0
				collectionViewFlowLayout.sectionInset.top = sectionInset
				collectionViewFlowLayout.sectionInset.left = sectionInset
				collectionViewFlowLayout.sectionInset.right = sectionInset
				let itemSpacing: CGFloat = sectionInset / 2.0
				collectionViewFlowLayout.minimumInteritemSpacing = itemSpacing
				
				
				minimumCellsPerLine = 1
				maxCellWidth = cellWidthToUse(masterViewsWidth, cellsPerLine: minimumCellsPerLine, itemSpacing: itemSpacing, flowLayout: collectionViewFlowLayout)
				collectionViewFlowLayout.itemSize = CGSize(width: maxCellWidth, height: maxCellWidth / 8.0) // TODO: hard constant hack for aspect ratio
			} else {
				let sectionInset: CGFloat = 2.0
				collectionViewFlowLayout.sectionInset.top = sectionInset
				collectionViewFlowLayout.sectionInset.left = sectionInset
				collectionViewFlowLayout.sectionInset.right = sectionInset
				let itemSpacing: CGFloat = sectionInset / 2.0
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
		if let art = fetchResultsController.objectAtIndexPath(indexPath) as? Art {
			cell.title.text = art.title
			cell.backgroundColor = UIColor.blackColor()
			cell.title.textColor = UIColor.whiteColor()
		}
		return cell
	}
	
	override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return 1
	}
	
	override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		let sectionInfo = fetchResultsController.sections![section] 
		return sectionInfo.numberOfObjects
	}
	
	// MARK: UICollectionViewDelegate
	
	override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		if let art = fetchResultsController.objectAtIndexPath(indexPath) as? Art {
			if UIScreen.mainScreen().traitCollection.horizontalSizeClass == .Compact {
				if	let singleArtViewController: SingleArtViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(ViewControllerIdentifier.SingleArtViewController.rawValue) as?  SingleArtViewController {
						singleArtViewController.update(art, artBackgroundColor: nil)
						showViewController(singleArtViewController, sender: self)
				}
			} else {
				if let navigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ArtPiecesNavControllerID") as? UINavigationController {
					let singleArtViewController: SingleArtViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(ViewControllerIdentifier.SingleArtViewController.rawValue) as!  SingleArtViewController
						singleArtViewController.update(art, artBackgroundColor: nil)
					navigationController.setViewControllers([singleArtViewController], animated: false)
						showDetailViewController(navigationController, sender: self)
				}
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
		if UIScreen.mainScreen().traitCollection.horizontalSizeClass == .Regular {
			let indexPathsVisible = collectionView.indexPathsForVisibleItems()
			for path in indexPathsVisible {
					let cell = collectionView.cellForItemAtIndexPath(path) as? MediaCollectionViewCell
					cell?.backgroundColor = UIColor.blackColor()
					cell?.title.textColor = UIColor.whiteColor()
			}
			
			if UIScreen.mainScreen().traitCollection.horizontalSizeClass == .Regular {
				let cell = collectionView.cellForItemAtIndexPath(indexPath) as? MediaCollectionViewCell
				cell?.backgroundColor = UIColor.sfOrangeColor()
				cell?.title.textColor = UIColor.blackColor()
			}
		}
	}
	
}

extension TitlesCollectionViewController : NSFetchedResultsControllerDelegate {
	
	func controllerDidChangeContent(controller: NSFetchedResultsController) {
		collectionView?.reloadData()
	}
}


