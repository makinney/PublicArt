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
	private var selectedMenuItem: (title: String, tag: String)?

	
	// MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
		let nibName = UINib(nibName: CellIdentifier.CategoryCollectionViewCell.rawValue, bundle: nil)
		self.collectionView?.registerNib(nibName, forCellWithReuseIdentifier: CellIdentifier.CategoryCollectionViewCell.rawValue)
				
		setupFlowLayout()
		collectionView?.reloadData()
		
		title = "Catagories"
    }
	
	override func viewWillAppear(animated: Bool) {
		if UIScreen.mainScreen().traitCollection.horizontalSizeClass == .Regular,
			let selectedMenuItem = selectedMenuItem {
			let filter = ArtPiecesCollectionViewDataFilter(key: "tags", value: selectedMenuItem.tag, title: selectedMenuItem.title)
			if let navigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ArtPiecesNavControllerID") as? UINavigationController,
				let artPiecesCollectionViewController = navigationController.viewControllers.last as? ArtPiecesCollectionViewController {
					artPiecesCollectionViewController.fetchFilter(filter)
					showDetailViewController(navigationController, sender: self)
			}
		}
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("\(__FILE__) \(__FUNCTION__)")
    }


	func setupFlowLayout() {
		let maxCellHeight: CGFloat = 40.0
		if let collectionViewFlowLayout: UICollectionViewFlowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
			collectionViewFlowLayout.scrollDirection = .Vertical
			let masterViewsWidth = splitViewController?.primaryColumnWidth ?? 100
			collectionViewFlowLayout.headerReferenceSize = CGSize(width: 0, height: 0)
			collectionViewFlowLayout.minimumLineSpacing = 1
			var minimumCellsPerLine = 0
			
			userInterfaceIdion = traitCollection.userInterfaceIdiom
			if userInterfaceIdion == .Phone || userInterfaceIdion == .Unspecified {
				let sectionInset: CGFloat = 2
				collectionViewFlowLayout.sectionInset.top = sectionInset
				collectionViewFlowLayout.sectionInset.left = sectionInset
				collectionViewFlowLayout.sectionInset.right = sectionInset
				let itemSpacing: CGFloat = sectionInset / 2.0
				collectionViewFlowLayout.minimumInteritemSpacing = itemSpacing
				
				minimumCellsPerLine = 1
				let maxPhotoWidth = maxCellWidth(masterViewsWidth, cellsPerLine: minimumCellsPerLine, itemSpacing: itemSpacing, flowLayout: collectionViewFlowLayout)
				collectionViewFlowLayout.itemSize = CGSize(width: maxPhotoWidth, height: maxCellHeight) // TODO: hard constant hack for aspect ratio
			} else {
				let sectionInset: CGFloat = 2
				collectionViewFlowLayout.sectionInset.top = sectionInset
				collectionViewFlowLayout.sectionInset.left = sectionInset
				collectionViewFlowLayout.sectionInset.right = sectionInset
				let itemSpacing: CGFloat = sectionInset / 2.0
				collectionViewFlowLayout.minimumInteritemSpacing = itemSpacing
				minimumCellsPerLine = 1
				let maxPhotoWidth = maxCellWidth(masterViewsWidth, cellsPerLine: minimumCellsPerLine, itemSpacing: itemSpacing, flowLayout: collectionViewFlowLayout)
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
		cell.menuItemName.text = menuItem(indexPath.row).title
		cell.backgroundColor = UIColor.blackColor()
		cell.menuItemName.textColor = UIColor.whiteColor()
        return cell
    }
	
	
	func menuItem(row: Int) -> (title: String, tag: String) {
		switch(row) {
		case CatagoryMenuOrder.Monuments.rawValue:
			return (title: categoryMenuItem.value(.Monuments).title, tag: categoryMenuItem.value(.Monuments).tag)
		case CatagoryMenuOrder.Murals.rawValue:
			return (title: categoryMenuItem.value(.Murals).title, tag: categoryMenuItem.value(.Murals).tag)
		case CatagoryMenuOrder.Plagues.rawValue:
			return (title: categoryMenuItem.value(.Plagues).title, tag: categoryMenuItem.value(.Plagues).tag)
		case CatagoryMenuOrder.Sculpture.rawValue:
			return (title: categoryMenuItem.value(.Sculpture).title, tag: categoryMenuItem.value(.Sculpture).tag)
		case CatagoryMenuOrder.Steel.rawValue:
			return (title: categoryMenuItem.value(.Steel).title, tag: categoryMenuItem.value(.Steel).tag)
		case CatagoryMenuOrder.Statues.rawValue:
			return (title: categoryMenuItem.value(.Statues).title, tag: categoryMenuItem.value(.Statues).tag)

//		case CatagoryMenuOrder.StreetArt.rawValue:
//			return (title: categoryMenuItem.value(.StreetArt).title, tag: categoryMenuItem.value(.StreetArt).tag)
		default:
			return (title: "", tag: "")
		}
	}
    // MARK: UICollectionViewDelegate
	
	override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		selectedMenuItem = menuItem(indexPath.row)
		let filter = ArtPiecesCollectionViewDataFilter(key: "tags", value: selectedMenuItem!.tag, title: selectedMenuItem!.title)
		if UIScreen.mainScreen().traitCollection.horizontalSizeClass == .Compact {
			artPiecesCollectionViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ArtPiecesViewControllerID") as? ArtPiecesCollectionViewController
			if artPiecesCollectionViewController != nil {
				artPiecesCollectionViewController!.fetchFilter(filter)
				showDetailViewController(artPiecesCollectionViewController!, sender: self)
			}
		} else {
			if let navigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ArtPiecesNavControllerID") as? UINavigationController,
				let artPiecesCollectionViewController = navigationController.viewControllers.last as? ArtPiecesCollectionViewController {
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
		let indexPathsVisible = collectionView.indexPathsForVisibleItems()
		for path in indexPathsVisible {
				let cell = collectionView.cellForItemAtIndexPath(path) as? CategoryCollectionViewCell
				cell?.backgroundColor = UIColor.blackColor()
				cell?.menuItemName.textColor = UIColor.whiteColor()
		}
		
		if UIScreen.mainScreen().traitCollection.horizontalSizeClass == .Regular {
			let cell = collectionView.cellForItemAtIndexPath(indexPath) as? CategoryCollectionViewCell
			cell?.backgroundColor = UIColor.sfOrangeColor()
			cell?.menuItemName.textColor = UIColor.blackColor()
		}
	}
}
