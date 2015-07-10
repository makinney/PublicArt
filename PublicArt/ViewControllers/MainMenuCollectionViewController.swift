//
//  MainMenuCollectionViewController.swift
//  PublicArt
//
//  Created by Michael Kinney on 6/5/15.
//  Copyright (c) 2015 makinney. All rights reserved.
//

import UIKit

final class MainMenuCollectionViewController: UICollectionViewController {

	// MARK: Properties
	
	
	private var userInterfaceIdion: UIUserInterfaceIdiom = .Phone
	private var mainMenu = MainMenu()
	
	// MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

		var nibName = UINib(nibName: "HomeCollectionViewCell", bundle: nil)
		self.collectionView?.registerNib(nibName, forCellWithReuseIdentifier: "HomeCollectionViewCellID")
				
		setupFlowLayout()
	
		collectionView?.reloadData()
		
		self.title = "Browse" // TITLE
		
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
			
			var minimumPhotosPerLine = 0 // ultimately up to flow layout
			
			userInterfaceIdion = traitCollection.userInterfaceIdiom
			if userInterfaceIdion == .Phone || userInterfaceIdion == .Unspecified {
				collectionViewFlowLayout.minimumLineSpacing = 2
				let sectionInset: CGFloat = 1
				collectionViewFlowLayout.sectionInset.top = sectionInset * 2
				collectionViewFlowLayout.sectionInset.left = sectionInset
				collectionViewFlowLayout.sectionInset.right = sectionInset
				let itemSpacing: CGFloat = sectionInset
				collectionViewFlowLayout.minimumInteritemSpacing = itemSpacing
				
				minimumPhotosPerLine = 2
				var maxPhotoWidth = maxCellWidth(masterViewsWidth, photosPerLine: minimumPhotosPerLine, itemSpacing: itemSpacing, flowLayout: collectionViewFlowLayout)
				collectionViewFlowLayout.itemSize = CGSize(width: maxPhotoWidth, height: maxPhotoWidth) // TODO: hard constant hack for aspect ratio
			} else {
				collectionViewFlowLayout.minimumLineSpacing = 2
				let sectionInset: CGFloat = 1
				collectionViewFlowLayout.sectionInset.top = sectionInset * 2
				collectionViewFlowLayout.sectionInset.left = sectionInset
				collectionViewFlowLayout.sectionInset.right = sectionInset
				let itemSpacing: CGFloat = sectionInset
				collectionViewFlowLayout.minimumInteritemSpacing = itemSpacing
				
				minimumPhotosPerLine = 1
				var maxPhotoWidth = maxCellWidth(masterViewsWidth, photosPerLine: minimumPhotosPerLine, itemSpacing: itemSpacing, flowLayout: collectionViewFlowLayout)
				collectionViewFlowLayout.itemSize = CGSize(width: maxPhotoWidth, height: maxPhotoWidth)
			}
		}
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
		return MainMenuRow.CountRows.rawValue
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("HomeCollectionViewCellID", forIndexPath: indexPath) as! HomeCollectionViewCell
		cell.imageView.image = UIImage()
		
		var row = indexPath.row
		var mainMenuItem: MainMenuItem?
		
		switch(row) {
		case MainMenuRow.Artists.rawValue:
			 mainMenuItem = mainMenu.item(.Artists)
		case MainMenuRow.Catagory.rawValue:
			 mainMenuItem = mainMenu.item(.Catagory)
		case MainMenuRow.Neighborhoods.rawValue:
			 mainMenuItem = mainMenu.item(.Neighborhoods)
		case MainMenuRow.Titles.rawValue:
			mainMenuItem = mainMenu.item(.Titles)
		case MainMenuRow.Medium.rawValue:
			 mainMenuItem = mainMenu.item(.Medium)
		case MainMenuRow.Favorites.rawValue:
			 mainMenuItem = mainMenu.item(.Favorites)
		default:
			println("\(__FILE__) \(__FUNCTION__) menu row not defined for row \(row)")
		}
		
		if let mainMenuItem = mainMenuItem {
			cell.menuItemName.text = mainMenuItem.title
			cell.imageView.image = mainMenuItem.image
		}
        return cell
    }

    // MARK: UICollectionViewDelegate
	
	override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		var row = indexPath.row
	
	
		switch(row) {
//		case MainMenuRow.Artists.rawValue:
		case MainMenuRow.Catagory.rawValue:
			var vc: CatagoryCollectionViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(ViewControllerIdentifier.CatagoryCollectionViewController.rawValue) as! CatagoryCollectionViewController
			showViewController(vc, sender: self)
			


		case MainMenuRow.Neighborhoods.rawValue:
			var vc: LocationsCollectionViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(ViewControllerIdentifier.LocationCollectionViewController.rawValue) as! LocationsCollectionViewController
			showViewController(vc, sender: self)

		
		case MainMenuRow.Titles.rawValue:
		
			var navigationController:UINavigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ArtPiecesNavControllerID") as! UINavigationController
			var vc: ArtPiecesCollectionViewController = navigationController.viewControllers.last as! ArtPiecesCollectionViewController
			showDetailViewController(navigationController, sender: self)
			
//		case MainMenuRow.Medium.rawValue:
//		case MainMenuRow.Favorites.rawValue:
		default:
			println("\(__FILE__) \(__FUNCTION__) menu row not defined for row \(row)")
		}
		
	
//		var exploreCollectionViewController:ExploreCollectionViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ExploreCollectionViewControllerID") as! ExploreCollectionViewController
//		showViewController(exploreCollectionViewController, sender: self)
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
