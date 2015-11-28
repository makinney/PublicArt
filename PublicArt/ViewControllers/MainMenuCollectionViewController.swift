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
	private var artPiecesCollectionViewController: ArtPiecesCollectionViewController?
	
	// MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
		let nibName = UINib(nibName: "HomeCollectionViewCell", bundle: nil)
		self.collectionView?.registerNib(nibName, forCellWithReuseIdentifier: "HomeCollectionViewCellID")
		setupFlowLayout()
		collectionView?.reloadData()
		self.title = "Public Art" // TITLE
		
		if userInterfaceIdion == .Phone || userInterfaceIdion == .Unspecified {
			collectionView?.backgroundColor = UIColor.whiteColor()
		} else {
			collectionView?.backgroundColor = UIColor.whiteColor()
		}
		
		if UIScreen.mainScreen().traitCollection.horizontalSizeClass == .Regular {
			showDefaultDetailViewController()
		}
    }

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
	}
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("\(__FILE__) \(__FUNCTION__)")
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
		let totalInterItemSpacing: CGFloat = numPhotos * itemSpacing
		let totalInsetSpacing: CGFloat = flowLayout.sectionInset.left + flowLayout.sectionInset.right
		let totalSpacing: CGFloat = totalInterItemSpacing + totalInsetSpacing
		let spaceLeftForPhotos: CGFloat = screenWidth - totalSpacing
		let photoWidth: CGFloat = spaceLeftForPhotos / numPhotos
		return photoWidth
	}
	
	
	func setupFlowLayout() {
		if let collectionViewFlowLayout: UICollectionViewFlowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
			collectionViewFlowLayout.scrollDirection = .Vertical
			let masterViewsWidth = splitViewController?.primaryColumnWidth ?? 100
			collectionViewFlowLayout.headerReferenceSize = CGSize(width: 0, height: 0)
			
			var minimumPhotosPerLine = 0 // ultimately up to flow layout
			
			userInterfaceIdion = traitCollection.userInterfaceIdiom
			if userInterfaceIdion == .Phone || userInterfaceIdion == .Unspecified {
				collectionViewFlowLayout.minimumLineSpacing = 1
				let sectionInset: CGFloat = 1
				collectionViewFlowLayout.sectionInset.top = sectionInset
				collectionViewFlowLayout.sectionInset.left = sectionInset
				collectionViewFlowLayout.sectionInset.right = sectionInset
				let itemSpacing: CGFloat = 1
				collectionViewFlowLayout.minimumInteritemSpacing = itemSpacing
				
				minimumPhotosPerLine = 2
				let maxPhotoWidth = maxCellWidth(masterViewsWidth, photosPerLine: minimumPhotosPerLine, itemSpacing: itemSpacing, flowLayout: collectionViewFlowLayout)
				collectionViewFlowLayout.itemSize = CGSize(width: maxPhotoWidth, height: maxPhotoWidth) // TODO: hard constant hack for aspect ratio
			} else {
				collectionViewFlowLayout.minimumLineSpacing = 4
				let sectionInset: CGFloat = 4
				collectionViewFlowLayout.sectionInset.top = sectionInset
				collectionViewFlowLayout.sectionInset.left = sectionInset
				collectionViewFlowLayout.sectionInset.right = sectionInset
				let itemSpacing: CGFloat = 4
				collectionViewFlowLayout.minimumInteritemSpacing = itemSpacing
				
				minimumPhotosPerLine = 1
				let maxPhotoWidth = maxCellWidth(masterViewsWidth, photosPerLine: minimumPhotosPerLine, itemSpacing: itemSpacing, flowLayout: collectionViewFlowLayout)
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
		
		let row = indexPath.row
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
			print("\(__FILE__) \(__FUNCTION__) menu row not defined for row \(row)")
		}
		
		if let mainMenuItem = mainMenuItem {
			cell.menuItemName.text = mainMenuItem.title
			cell.imageView.image = mainMenuItem.image
		}
        return cell
    }

    // MARK: UICollectionViewDelegate
	
	var artistCollectionViewController: ArtistCollectionViewController?
	var catagoryCollectionViewController: CatagoryCollectionViewController?
	var locationsCollectionViewController: LocationsCollectionViewController?
	var titlesCollectionViewController: TitlesCollectionViewController?
	var mediaCollectionViewController: MediaCollectionViewController?

	
	override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		let row = indexPath.row
	
	
		switch(row) {
		case MainMenuRow.Artists.rawValue:
		
			if artistCollectionViewController == nil {
				artistCollectionViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(ViewControllerIdentifier.ArtistCollectionViewController.rawValue) as? ArtistCollectionViewController
			}
			
			showViewController(artistCollectionViewController!, sender: self)

		case MainMenuRow.Catagory.rawValue:
		
			if catagoryCollectionViewController == nil {
				catagoryCollectionViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(ViewControllerIdentifier.CatagoryCollectionViewController.rawValue) as? CatagoryCollectionViewController
			}
			showViewController(catagoryCollectionViewController!, sender: self)
			
		case MainMenuRow.Neighborhoods.rawValue:
			if locationsCollectionViewController == nil {
				locationsCollectionViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(ViewControllerIdentifier.LocationCollectionViewController.rawValue) as? LocationsCollectionViewController
			}
			showViewController(locationsCollectionViewController!, sender: self)

		case MainMenuRow.Titles.rawValue:
		
			if titlesCollectionViewController == nil {
			 titlesCollectionViewController  = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(ViewControllerIdentifier.TitlesCollectionViewController.rawValue) as? TitlesCollectionViewController
			}
		
			showViewController(titlesCollectionViewController!, sender: self)


		case MainMenuRow.Medium.rawValue:
		
			if mediaCollectionViewController == nil {
				mediaCollectionViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(ViewControllerIdentifier.MediaCollectionViewController.rawValue) as? MediaCollectionViewController
			}
			showViewController(mediaCollectionViewController!, sender: self)

		
//		case MainMenuRow.Favorites.rawValue:
		default:
			print("\(__FILE__) \(__FUNCTION__) menu row not defined for row \(row)")
		}
		
	
//		var exploreCollectionViewController:ExploreCollectionViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ExploreCollectionViewControllerID") as! ExploreCollectionViewController
//		showViewController(exploreCollectionViewController, sender: self)
	}

	func showDefaultDetailViewController() {
		if UIScreen.mainScreen().traitCollection.horizontalSizeClass == .Compact {
			artPiecesCollectionViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ArtPiecesViewControllerID") as? ArtPiecesCollectionViewController
			if artPiecesCollectionViewController != nil {
				artPiecesCollectionViewController?.pageTitle = "San Francisco"
				showDetailViewController(artPiecesCollectionViewController!, sender: self)
			}
		} else {
			if let navigationController:UINavigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ArtPiecesNavControllerID") as? UINavigationController,
				let artPiecesCollectionViewController = navigationController.viewControllers.last as? ArtPiecesCollectionViewController {
					artPiecesCollectionViewController.pageTitle = "San Francisco"
					showDetailViewController(navigationController, sender: self)
			}
		}
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
