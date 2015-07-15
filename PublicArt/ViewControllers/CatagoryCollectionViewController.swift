//
//  CatagoryCollectionViewController.Swift
//  PublicArt
//
//  Created by Michael Kinney on 6/5/15.
//  Copyright (c) 2015 makinney. All rights reserved.
//

import UIKit

final class CatagoryCollectionViewController: UICollectionViewController {

	private var artPiecesCollectionViewController: ArtPiecesCollectionViewController?
	private var userInterfaceIdion: UIUserInterfaceIdiom = .Phone
	private var categoryMenuItem = CatagoryMenuItem()
	
	// MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
		var nibName = UINib(nibName: CellIdentifier.CategoryCollectionViewCell.rawValue, bundle: nil)
		self.collectionView?.registerNib(nibName, forCellWithReuseIdentifier: CellIdentifier.CategoryCollectionViewCell.rawValue)
				
		setupFlowLayout()
		collectionView?.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        println("\(__FILE__) \(__FUNCTION__)")
    }


	func setupFlowLayout() {
		let maxCellHeight: CGFloat = 75.0
		if let collectionViewFlowLayout: UICollectionViewFlowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
			collectionViewFlowLayout.scrollDirection = .Vertical
			var masterViewsWidth = splitViewController?.primaryColumnWidth ?? 100
			collectionViewFlowLayout.headerReferenceSize = CGSize(width: 0, height: 0)
			collectionViewFlowLayout.minimumLineSpacing = 5
			var minimumCellsPerLine = 0
			
			userInterfaceIdion = traitCollection.userInterfaceIdiom
			if userInterfaceIdion == .Phone || userInterfaceIdion == .Unspecified {
				let sectionInset: CGFloat = 10.0
				collectionViewFlowLayout.sectionInset.left = sectionInset
				collectionViewFlowLayout.sectionInset.right = sectionInset
				let itemSpacing: CGFloat = sectionInset / 2.0
				collectionViewFlowLayout.minimumInteritemSpacing = itemSpacing
				
				minimumCellsPerLine = 1
				var maxPhotoWidth = maxCellWidth(masterViewsWidth, cellsPerLine: minimumCellsPerLine, itemSpacing: itemSpacing, flowLayout: collectionViewFlowLayout)
				collectionViewFlowLayout.itemSize = CGSize(width: maxPhotoWidth, height: maxCellHeight) // TODO: hard constant hack for aspect ratio
			} else {
				let sectionInset: CGFloat = 10.0
				collectionViewFlowLayout.sectionInset.left = sectionInset
				collectionViewFlowLayout.sectionInset.right = sectionInset
				let itemSpacing: CGFloat = sectionInset / 2.0
				collectionViewFlowLayout.minimumInteritemSpacing = itemSpacing
				minimumCellsPerLine = 1
				var maxPhotoWidth = maxCellWidth(masterViewsWidth, cellsPerLine: minimumCellsPerLine, itemSpacing: itemSpacing, flowLayout: collectionViewFlowLayout)
				collectionViewFlowLayout.itemSize = CGSize(width: maxPhotoWidth, height: maxCellHeight)
			}
		}
	}
	
	func maxCellWidth(screenWidth: CGFloat, cellsPerLine: Int, itemSpacing: CGFloat, flowLayout:UICollectionViewFlowLayout ) -> CGFloat {
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
	

	override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
		setupFlowLayout()
		//		collectionView?.reloadData()
	}
	

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
		return CatagoryMenuOrder.CountRows.rawValue
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CellIdentifier.CategoryCollectionViewCell.rawValue, forIndexPath: indexPath) as! CategoryCollectionViewCell
		cell.menuItemName.text = menuItemTitle(indexPath.row)
        return cell
    }
	
	func menuItemTitle(row: Int) -> String {
		var title: String
		switch(row) {
		case CatagoryMenuOrder.Monuments.rawValue:
			return categoryMenuItem.value(.Monuments).title
		case CatagoryMenuOrder.Murals.rawValue:
			return categoryMenuItem.value(.Murals).title
		case CatagoryMenuOrder.Plagues.rawValue:
			return categoryMenuItem.value(.Plagues).title
		case CatagoryMenuOrder.Sculpture.rawValue:
			return categoryMenuItem.value(.Sculpture).title
		case CatagoryMenuOrder.Site.rawValue:
			return categoryMenuItem.value(.Site).title
		case CatagoryMenuOrder.Statues.rawValue:
			return categoryMenuItem.value(.Statues).title
		case CatagoryMenuOrder.StreetArt.rawValue:
			return categoryMenuItem.value(.StreetArt).title
		default:
			return ""
		}
	}
	
	func menuItemTag(row: Int) -> String {
		var title: String
		switch(row) {
		case CatagoryMenuOrder.Monuments.rawValue:
			return categoryMenuItem.value(.Monuments).tag
		case CatagoryMenuOrder.Murals.rawValue:
			return categoryMenuItem.value(.Murals).tag
		case CatagoryMenuOrder.Plagues.rawValue:
			return categoryMenuItem.value(.Plagues).tag
		case CatagoryMenuOrder.Sculpture.rawValue:
			return categoryMenuItem.value(.Sculpture).tag
		case CatagoryMenuOrder.Site.rawValue:
			return categoryMenuItem.value(.Site).tag
		case CatagoryMenuOrder.Statues.rawValue:
			return categoryMenuItem.value(.Statues).tag
		case CatagoryMenuOrder.StreetArt.rawValue:
			return categoryMenuItem.value(.StreetArt).tag
		default:
			return ""
		}
	}

    // MARK: UICollectionViewDelegate
	
	override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
	
		if UIScreen.mainScreen().traitCollection.horizontalSizeClass == .Compact {
			artPiecesCollectionViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ArtPiecesViewControllerID") as? ArtPiecesCollectionViewController
			if artPiecesCollectionViewController != nil {
				var tag = menuItemTag(indexPath.row)
				var title = menuItemTitle(indexPath.row)
				let filter = ArtPiecesCollectionViewDataFilter(key: "tags", value: tag, title: title)
				artPiecesCollectionViewController!.fetchFilter(filter)
				showDetailViewController(artPiecesCollectionViewController!, sender: self)
			}
		} else {
			if let navigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ArtPiecesNavControllerID") as? UINavigationController,
				let artPiecesCollectionViewController = navigationController.viewControllers.last as? ArtPiecesCollectionViewController {
					var tag = menuItemTag(indexPath.row)
					var title = menuItemTitle(indexPath.row)
					let filter = ArtPiecesCollectionViewDataFilter(key: "tags", value: tag, title: title)
					artPiecesCollectionViewController.fetchFilter(filter)
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
		var indexPathsVisible = collectionView.indexPathsForVisibleItems()
		for path in indexPathsVisible {
			if let visiblePath = path as? NSIndexPath {
				var cell = collectionView.cellForItemAtIndexPath(visiblePath) as? CategoryCollectionViewCell
				cell?.backgroundColor = UIColor.whiteColor()
				cell?.menuItemName.textColor = UIColor.blackColor()
			}
		}
		
		var cell = collectionView.cellForItemAtIndexPath(indexPath) as? CategoryCollectionViewCell
		cell?.backgroundColor = UIColor.blackColor()
		cell?.menuItemName.textColor = UIColor.whiteColor()
	}
}
