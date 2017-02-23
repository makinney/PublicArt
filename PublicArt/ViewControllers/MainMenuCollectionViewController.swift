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
	
	fileprivate var userInterfaceIdion: UIUserInterfaceIdiom = .phone
	fileprivate var mainMenu = MainMenu()
	fileprivate var artPiecesCollectionViewController: ArtPiecesCollectionViewController?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
	
	// MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
		let nibName = UINib(nibName: "HomeCollectionViewCell", bundle: nil)
		self.collectionView?.register(nibName, forCellWithReuseIdentifier: "HomeCollectionViewCellID")
		collectionView?.reloadData()
		self.title = "Public Art" // TITLE
		
        if #available(iOS 10.0, *) {
            collectionView?.isPrefetchingEnabled = false
        } else {
            // Fallback on earlier versions
        }   
		
		let artworkCollectionViewLayout = collectionViewLayout as! ArtworkCollectionViewLayout
		
		userInterfaceIdion = traitCollection.userInterfaceIdiom
		if userInterfaceIdion == .pad {
			artworkCollectionViewLayout.cellPadding = 5
			artworkCollectionViewLayout.delegate = self
			artworkCollectionViewLayout.numberOfColumns = 1
		} else {
			artworkCollectionViewLayout.cellPadding = 1
			artworkCollectionViewLayout.delegate = self
			artworkCollectionViewLayout.numberOfColumns = 2
		}
	
		
		if UIScreen.main.traitCollection.horizontalSizeClass == .regular {
			showDefaultDetailViewController()
		}
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
				if userInterfaceIdion == .phone || userInterfaceIdion == .unspecified {
					collectionView?.backgroundColor = UIColor.black
				} else {
					collectionView?.backgroundColor = UIColor.black
				}

		
	}
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("\(#file) \(#function)")
    }
	
    // MARK: - Navigation

	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		//		collectionView?.reloadData()
	}
	
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
		return MainMenuRow.countRows.rawValue
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCellID", for: indexPath) as! HomeCollectionViewCell
		cell.imageView.image = UIImage()
		
		let row = indexPath.row
		var mainMenuItem: MainMenuItem?
		
		switch(row) {
		case MainMenuRow.artists.rawValue:
			 mainMenuItem = mainMenu.item(.artists)
		case MainMenuRow.catagory.rawValue:
			 mainMenuItem = mainMenu.item(.catagory)
		case MainMenuRow.neighborhoods.rawValue:
			 mainMenuItem = mainMenu.item(.neighborhoods)
		case MainMenuRow.titles.rawValue:
			mainMenuItem = mainMenu.item(.titles)
		case MainMenuRow.medium.rawValue:
			 mainMenuItem = mainMenu.item(.medium)
		case MainMenuRow.favorites.rawValue:
			 mainMenuItem = mainMenu.item(.favorites)
		default:
			print("\(#file) \(#function) menu row not defined for row \(row)")
		}
		
		if let mainMenuItem = mainMenuItem {
			cell.menuItemName.text = mainMenuItem.title
//			cell.imageView.image = mainMenuItem.image
		}
        return cell
    }

    // MARK: UICollectionViewDelegate
	
	var artistCollectionViewController: ArtistCollectionViewController?
	var catagoryCollectionViewController: CatagoryCollectionViewController?
	var locationsCollectionViewController: LocationsCollectionViewController?
	var titlesCollectionViewController: TitlesCollectionViewController?
	var mediaCollectionViewController: MediaCollectionViewController?

	
	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let row = indexPath.row
	
	
		switch(row) {
		case MainMenuRow.artists.rawValue:
		
			if artistCollectionViewController == nil {
				artistCollectionViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: ViewControllerIdentifier.ArtistCollectionViewController.rawValue) as? ArtistCollectionViewController
			}
			
			show(artistCollectionViewController!, sender: self)

		case MainMenuRow.catagory.rawValue:
		
			if catagoryCollectionViewController == nil {
				catagoryCollectionViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: ViewControllerIdentifier.CatagoryCollectionViewController.rawValue) as? CatagoryCollectionViewController
			}
			show(catagoryCollectionViewController!, sender: self)
			
		case MainMenuRow.neighborhoods.rawValue:
			if locationsCollectionViewController == nil {
				locationsCollectionViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: ViewControllerIdentifier.LocationCollectionViewController.rawValue) as? LocationsCollectionViewController
			}
			show(locationsCollectionViewController!, sender: self)

		case MainMenuRow.titles.rawValue:
		
			if titlesCollectionViewController == nil {
				titlesCollectionViewController  = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: ViewControllerIdentifier.TitlesCollectionViewController.rawValue) as? TitlesCollectionViewController
			}
		
			show(titlesCollectionViewController!, sender: self)


		case MainMenuRow.medium.rawValue:
		
			if mediaCollectionViewController == nil {
				mediaCollectionViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: ViewControllerIdentifier.MediaCollectionViewController.rawValue) as? MediaCollectionViewController
			}
			show(mediaCollectionViewController!, sender: self)

		
//		case MainMenuRow.Favorites.rawValue:
		default:
			print("\(#file) \(#function) menu row not defined for row \(row)")
		}
		
	
//		var exploreCollectionViewController:ExploreCollectionViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ExploreCollectionViewControllerID") as! ExploreCollectionViewController
//		showViewController(exploreCollectionViewController, sender: self)
	}

	func showDefaultDetailViewController() {
		if UIScreen.main.traitCollection.horizontalSizeClass == .compact {
			artPiecesCollectionViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ArtPiecesViewControllerID") as? ArtPiecesCollectionViewController
			if artPiecesCollectionViewController != nil {
				artPiecesCollectionViewController!.pageTitle = "San Francisco"
				showDetailViewController(artPiecesCollectionViewController!, sender: self)
			}
		} else {
			if let navigationController:UINavigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ArtPiecesNavControllerID") as? UINavigationController,
				let artPiecesCollectionViewController = navigationController.viewControllers.last as? ArtPiecesCollectionViewController {
					artPiecesCollectionViewController.pageTitle = "San Francisco"
					showDetailViewController(navigationController, sender: self)
			}
		}
	}
}

extension MainMenuCollectionViewController: ArtworkLayoutDelegate {

	func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat {
		let height = width
		return height
	}
	
	func collectionView(_ collectionView: UICollectionView, heightForAnnotationAtIndexPath indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat {
		return 0 // FIXME:
	}
}
	



