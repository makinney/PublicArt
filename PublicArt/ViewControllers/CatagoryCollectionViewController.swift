//
//  CatagoryCollectionViewController.Swift
//  PublicArt
//
//  Created by Michael Kinney on 6/5/15.
//  Copyright (c) 2015 makinney. All rights reserved.
//

import UIKit

final class CatagoryCollectionViewController: UICollectionViewController {

	fileprivate var artPiecesCollectionViewController: ArtPiecesCollectionViewController?
	fileprivate var userInterfaceIdion: UIUserInterfaceIdiom = .phone
	fileprivate var categoryMenuItem = CatagoryMenuItem()
	fileprivate var selectedMenuItem: (title: String, tag: String)?

	
	// MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
		let nibName = UINib(nibName: CellIdentifier.CategoryCollectionViewCell.rawValue, bundle: nil)
		self.collectionView?.register(nibName, forCellWithReuseIdentifier: CellIdentifier.CategoryCollectionViewCell.rawValue)
		collectionView?.backgroundColor = UIColor.white

		setupFlowLayout()
        collectionView?.backgroundColor = UIColor.black
        if #available(iOS 10.0, *) {
            collectionView?.isPrefetchingEnabled = false
        } else {
            // Fallback on earlier versions
        }
		collectionView?.reloadData()
		
		title = "Catagories"
    }
	
	override func viewWillAppear(_ animated: Bool) {
		if UIScreen.main.traitCollection.horizontalSizeClass == .regular,
			let selectedMenuItem = selectedMenuItem {
			let filter = ArtPiecesCollectionViewDataFilter(key: "tags", value: selectedMenuItem.tag, title: selectedMenuItem.title)
			if let navigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ArtPiecesNavControllerID") as? UINavigationController,
				let artPiecesCollectionViewController = navigationController.viewControllers.last as? ArtPiecesCollectionViewController {
					artPiecesCollectionViewController.fetchFilter(filter)
					showDetailViewController(navigationController, sender: self)
			}
		}
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("\(#file) \(#function)")
    }


	func setupFlowLayout() {
		let maxCellHeight: CGFloat = 44
		if let collectionViewFlowLayout: UICollectionViewFlowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
			collectionViewFlowLayout.scrollDirection = .vertical
			let masterViewsWidth = splitViewController?.primaryColumnWidth ?? 100
			collectionViewFlowLayout.headerReferenceSize = CGSize(width: 0, height: 0)
			collectionViewFlowLayout.minimumLineSpacing = 1
			var minimumCellsPerLine = 0
			
			userInterfaceIdion = traitCollection.userInterfaceIdiom
			if userInterfaceIdion == .phone || userInterfaceIdion == .unspecified {
				let sectionInset: CGFloat = 1
				collectionViewFlowLayout.sectionInset.top = sectionInset
				collectionViewFlowLayout.sectionInset.left = sectionInset
				collectionViewFlowLayout.sectionInset.right = sectionInset
				let itemSpacing: CGFloat = 1
				collectionViewFlowLayout.minimumInteritemSpacing = itemSpacing
				
				minimumCellsPerLine = 1
				let maxPhotoWidth = maxCellWidth(masterViewsWidth, cellsPerLine: minimumCellsPerLine, itemSpacing: itemSpacing, flowLayout: collectionViewFlowLayout)
				collectionViewFlowLayout.itemSize = CGSize(width: maxPhotoWidth, height: maxCellHeight) // : hard constant hack for aspect ratio
			} else {
				let sectionInset: CGFloat = 2
				collectionViewFlowLayout.sectionInset.top = sectionInset
				collectionViewFlowLayout.sectionInset.left = sectionInset
				collectionViewFlowLayout.sectionInset.right = sectionInset
				let itemSpacing: CGFloat = 2.0
				collectionViewFlowLayout.minimumInteritemSpacing = itemSpacing
				minimumCellsPerLine = 1
				let maxPhotoWidth = maxCellWidth(masterViewsWidth, cellsPerLine: minimumCellsPerLine, itemSpacing: itemSpacing, flowLayout: collectionViewFlowLayout)
				collectionViewFlowLayout.itemSize = CGSize(width: maxPhotoWidth, height: maxCellHeight)
			}
		}
	}
	
	func maxCellWidth(_ screenWidth: CGFloat, cellsPerLine: Int, itemSpacing: CGFloat, flowLayout:UICollectionViewFlowLayout ) -> CGFloat {
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
	

	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		setupFlowLayout()
		//		collectionView?.reloadData()
	}
	

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
		return CatagoryMenuOrder.countRows.rawValue
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.CategoryCollectionViewCell.rawValue, for: indexPath) as! CategoryCollectionViewCell
		cell.menuItemName.text = menuItem(indexPath.row).title
		cell.backgroundColor = UIColor.white
		cell.menuItemName.textColor = UIColor.black
        return cell
    }
	
	
	func menuItem(_ row: Int) -> (title: String, tag: String) {
		switch(row) {
		case CatagoryMenuOrder.monuments.rawValue:
			return (title: categoryMenuItem.value(.monuments).title, tag: categoryMenuItem.value(.monuments).tag)
		case CatagoryMenuOrder.murals.rawValue:
			return (title: categoryMenuItem.value(.murals).title, tag: categoryMenuItem.value(.murals).tag)
		case CatagoryMenuOrder.plaques.rawValue:
			return (title: categoryMenuItem.value(.plaques).title, tag: categoryMenuItem.value(.plaques).tag)
		case CatagoryMenuOrder.sculpture.rawValue:
			return (title: categoryMenuItem.value(.sculpture).title, tag: categoryMenuItem.value(.sculpture).tag)
		case CatagoryMenuOrder.steel.rawValue:
			return (title: categoryMenuItem.value(.steel).title, tag: categoryMenuItem.value(.steel).tag)
		case CatagoryMenuOrder.statues.rawValue:
			return (title: categoryMenuItem.value(.statues).title, tag: categoryMenuItem.value(.statues).tag)

//		case CatagoryMenuOrder.StreetArt.rawValue:
//			return (title: categoryMenuItem.value(.StreetArt).title, tag: categoryMenuItem.value(.StreetArt).tag)
		default:
			return (title: "", tag: "")
		}
	}
    // MARK: UICollectionViewDelegate
	
	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		selectedMenuItem = menuItem(indexPath.row)
		let filter = ArtPiecesCollectionViewDataFilter(key: "tags", value: selectedMenuItem!.tag, title: selectedMenuItem!.title)
		if UIScreen.main.traitCollection.horizontalSizeClass == .compact {
			artPiecesCollectionViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ArtPiecesViewControllerID") as? ArtPiecesCollectionViewController
			if artPiecesCollectionViewController != nil {
				artPiecesCollectionViewController!.fetchFilter(filter)
				showDetailViewController(artPiecesCollectionViewController!, sender: self)
			}
		} else {
			if let navigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ArtPiecesNavControllerID") as? UINavigationController,
				let artPiecesCollectionViewController = navigationController.viewControllers.last as? ArtPiecesCollectionViewController {
					artPiecesCollectionViewController.fetchFilter(filter)
					showDetailViewController(navigationController, sender: self)
			}
		}
	}

	override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
		return true
	}
	
	
	override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
		return true
	}
	
	override func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
		let indexPathsVisible = collectionView.indexPathsForVisibleItems
		for path in indexPathsVisible {
				let cell = collectionView.cellForItem(at: path) as? CategoryCollectionViewCell
				cell?.backgroundColor = UIColor.white
				cell?.menuItemName.textColor = UIColor.black
		}
		
		if UIScreen.main.traitCollection.horizontalSizeClass == .regular {
			let cell = collectionView.cellForItem(at: indexPath) as? CategoryCollectionViewCell
			cell?.backgroundColor = UIColor.black
			cell?.menuItemName.textColor = UIColor.white
		}
	}
}
