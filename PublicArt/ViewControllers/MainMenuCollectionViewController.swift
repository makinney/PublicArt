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
	
	let photoImages = PhotoImages() 
	// MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
		let nibName = UINib(nibName: "HomeCollectionViewCell", bundle: nil)
		self.collectionView?.registerNib(nibName, forCellWithReuseIdentifier: "HomeCollectionViewCellID")
		collectionView?.reloadData()
		self.title = "Public Art" // TITLE
		
		
		let artworkCollectionViewLayout = collectionViewLayout as! ArtworkCollectionViewLayout
		artworkCollectionViewLayout.cellPadding = 1
		artworkCollectionViewLayout.delegate = self
		artworkCollectionViewLayout.numberOfColumns = 2
		
		if UIScreen.mainScreen().traitCollection.horizontalSizeClass == .Regular {
			showDefaultDetailViewController()
		}
    }

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
				if userInterfaceIdion == .Phone || userInterfaceIdion == .Unspecified {
					collectionView?.backgroundColor = UIColor.blackColor()
				} else {
					collectionView?.backgroundColor = UIColor.blackColor()
				}

		
	}
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("\(__FILE__) \(__FUNCTION__)")
    }
	
    // MARK: - Navigation

	override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
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
				artistCollectionViewController?.photoImages = photoImages
			}
			
			showViewController(artistCollectionViewController!, sender: self)

		case MainMenuRow.Catagory.rawValue:
		
			if catagoryCollectionViewController == nil {
				catagoryCollectionViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(ViewControllerIdentifier.CatagoryCollectionViewController.rawValue) as? CatagoryCollectionViewController
				catagoryCollectionViewController?.photoImages = photoImages
			}
			showViewController(catagoryCollectionViewController!, sender: self)
			
		case MainMenuRow.Neighborhoods.rawValue:
			if locationsCollectionViewController == nil {
				locationsCollectionViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(ViewControllerIdentifier.LocationCollectionViewController.rawValue) as? LocationsCollectionViewController
				locationsCollectionViewController?.photoImages = photoImages
			}
			showViewController(locationsCollectionViewController!, sender: self)

		case MainMenuRow.Titles.rawValue:
		
			if titlesCollectionViewController == nil {
				titlesCollectionViewController  = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(ViewControllerIdentifier.TitlesCollectionViewController.rawValue) as? TitlesCollectionViewController
				titlesCollectionViewController?.photoImages = photoImages
			}
		
			showViewController(titlesCollectionViewController!, sender: self)


		case MainMenuRow.Medium.rawValue:
		
			if mediaCollectionViewController == nil {
				mediaCollectionViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(ViewControllerIdentifier.MediaCollectionViewController.rawValue) as? MediaCollectionViewController
				mediaCollectionViewController?.photoImages = photoImages
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
				artPiecesCollectionViewController!.photoImages = photoImages
				artPiecesCollectionViewController!.pageTitle = "San Francisco"
				showDetailViewController(artPiecesCollectionViewController!, sender: self)
			}
		} else {
			if let navigationController:UINavigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ArtPiecesNavControllerID") as? UINavigationController,
				let artPiecesCollectionViewController = navigationController.viewControllers.last as? ArtPiecesCollectionViewController {
					artPiecesCollectionViewController.photoImages = photoImages
					artPiecesCollectionViewController.pageTitle = "San Francisco"
					showDetailViewController(navigationController, sender: self)
			}
		}
	}
}

extension MainMenuCollectionViewController: ArtworkLayoutDelegate {

	func collectionView(collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat {
		let height = width
		return height
	}
	
	func collectionView(collectionView: UICollectionView, heightForAnnotationAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat {
		return 0 // FIXME:
	}
}
	



