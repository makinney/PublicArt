//
//  HomeCollectionViewController.swift
//  PublicArt
//
//  Created by Michael Kinney on 6/5/15.
//  Copyright (c) 2015 makinney. All rights reserved.
//

import UIKit

class HomeCollectionViewController: UICollectionViewController {

	// MARK: Properties
	
	
	private var userInterfaceIdion: UIUserInterfaceIdiom = .Phone
	private var exploreCategoryTitles = ExploreCatagoryTitles()
	
	// MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

		var nibName = UINib(nibName: "HomeCollectionViewCell", bundle: nil)
		self.collectionView?.registerNib(nibName, forCellWithReuseIdentifier: "HomeCollectionViewCellID")
		
		setupFlowLayout()
	
		collectionView?.reloadData()
		
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        println("\(__FILE__) \(__FUNCTION__)")
    }

	
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
	
	
	// MARK: Flow Layout
	func maxCellWidth(screenWidth: CGFloat, photosPerLine: Int, itemSpacing: CGFloat, flowLayout:UICollectionViewFlowLayout ) -> CGFloat {
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
	
	
	func setupFlowLayout() {
		let maxCellHeight: CGFloat = 100.0
		if let collectionViewFlowLayout: UICollectionViewFlowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
			collectionViewFlowLayout.scrollDirection = .Vertical
			var masterViewsWidth = splitViewController?.primaryColumnWidth ?? 100
			collectionViewFlowLayout.headerReferenceSize = CGSize(width: 0, height: 0)
			
			collectionViewFlowLayout.minimumLineSpacing = 5
			var minimumPhotosPerLine = 0 // ultimately up to flow layout
			
			userInterfaceIdion = traitCollection.userInterfaceIdiom
			if userInterfaceIdion == .Phone || userInterfaceIdion == .Unspecified {
				let sectionInset: CGFloat = 10.0
				collectionViewFlowLayout.sectionInset.left = sectionInset
				collectionViewFlowLayout.sectionInset.right = sectionInset
				let itemSpacing: CGFloat = sectionInset / 2.0
				collectionViewFlowLayout.minimumInteritemSpacing = itemSpacing
				
				
				minimumPhotosPerLine = 1
				var maxPhotoWidth = maxCellWidth(masterViewsWidth, photosPerLine: minimumPhotosPerLine, itemSpacing: itemSpacing, flowLayout: collectionViewFlowLayout)
				collectionViewFlowLayout.itemSize = CGSize(width: maxPhotoWidth, height: maxCellHeight) // TODO: hard constant hack for aspect ratio
			} else {
				let sectionInset: CGFloat = 10.0
				collectionViewFlowLayout.sectionInset.left = sectionInset
				collectionViewFlowLayout.sectionInset.right = sectionInset
				let itemSpacing: CGFloat = sectionInset / 2.0
				collectionViewFlowLayout.minimumInteritemSpacing = itemSpacing
				minimumPhotosPerLine = 1
				var maxPhotoWidth = maxCellWidth(masterViewsWidth, photosPerLine: minimumPhotosPerLine, itemSpacing: itemSpacing, flowLayout: collectionViewFlowLayout)
				collectionViewFlowLayout.itemSize = CGSize(width: maxPhotoWidth, height: maxCellHeight)
			}
		}
	}
	


    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
		return ExploreCatagoryMenuRow.CountRows.rawValue
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("HomeCollectionViewCellID", forIndexPath: indexPath) as! HomeCollectionViewCell
		
		var row = indexPath.row
		
		switch(row) {
		case ExploreCatagoryMenuRow.Artists.rawValue:
			 cell.menuItemName.text = exploreCategoryTitles.title(.Artists)
		case ExploreCatagoryMenuRow.Monuments.rawValue:
			cell.menuItemName.text = exploreCategoryTitles.title(.Monuments)
		case ExploreCatagoryMenuRow.Murals.rawValue:
			cell.menuItemName.text = exploreCategoryTitles.title(.Murals)
		case ExploreCatagoryMenuRow.Plagues.rawValue:
			cell.menuItemName.text = exploreCategoryTitles.title(.Plagues)
		case ExploreCatagoryMenuRow.Sculpture.rawValue:
			cell.menuItemName.text = exploreCategoryTitles.title(.Sculpture)
		case ExploreCatagoryMenuRow.Statues.rawValue:
			cell.menuItemName.text = exploreCategoryTitles.title(.Statues)
		case ExploreCatagoryMenuRow.StreetArt.rawValue:
			cell.menuItemName.text = exploreCategoryTitles.title(.StreetArt)
		default:
			 cell.menuItemName.text = ""
		}
		
		
        return cell
    }

    // MARK: UICollectionViewDelegate
	
	override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		var exploreCollectionViewController:ExploreCollectionViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ExploreCollectionViewControllerID") as! ExploreCollectionViewController
		showViewController(exploreCollectionViewController, sender: self)
	}


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
