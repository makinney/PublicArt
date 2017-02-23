 //
//  LocationsCollectionViewController.Swift
//  PublicArt
//
//  Created by Michael Kinney on 6/5/15.
//  Copyright (c) 2015 makinney. All rights reserved.
//

import UIKit
import CoreData


final class LocationsCollectionViewController: UICollectionViewController, UINavigationControllerDelegate, UICollectionViewDelegateFlowLayout {

	// MARK: Properties
	fileprivate var artPiecesCollectionViewController: ArtPiecesCollectionViewController?
	fileprivate var collapseDetailViewController = true
	fileprivate var initialHorizontalSizeClass: UIUserInterfaceSizeClass?
	fileprivate var selectedLocation: Location?
	
	fileprivate var error:NSError?
	fileprivate let moc: NSManagedObjectContext?
	
	var fetchFilterKey: String?
	var fetchFilterValue: String?
	
	fileprivate var userInterfaceIdion: UIUserInterfaceIdiom = .phone
	
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
		
		title = "Location" // TITLE
		
		
		let nibName = UINib(nibName: CellIdentifier.LocationCollectionViewCell.rawValue, bundle: nil) // TODO:
		self.collectionView?.register(nibName, forCellWithReuseIdentifier: CellIdentifier.LocationCollectionViewCell.rawValue)
		
		collectionView?.backgroundColor = UIColor.black
        if #available(iOS 10.0, *) {
            collectionView?.isPrefetchingEnabled = false
        } else {
            // Fallback on earlier versions
        }
        
		let artworkCollectionViewLayout = collectionViewLayout as! ArtworkCollectionViewLayout
		artworkCollectionViewLayout.cellPadding = 1
		artworkCollectionViewLayout.delegate = self
		artworkCollectionViewLayout.numberOfColumns = 3

        
		
		fetchResultsController.delegate = self
		do {
			try fetchResultsController.performFetch()
		} catch let error1 as NSError {
			error = error1
		}
		
		//
//		if UIScreen.mainScreen().traitCollection.horizontalSizeClass == .Compact {
//			if let artPiecesCollectionViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ArtPiecesViewControllerID") as? ArtPiecesCollectionViewController {
//				self.artPiecesCollectionViewController = artPiecesCollectionViewController
//				detailViewController = self.artPiecesCollectionViewController
//			}
//		} else {
//			if let navigationController:UINavigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ArtPiecesNavControllerID") as? UINavigationController,
//				let artPiecesCollectionViewController = navigationController.viewControllers.last as? ArtPiecesCollectionViewController {
//				self.artPiecesNavigationController = navigationController
//				detailViewController = self.artPiecesNavigationController
//				self.artPiecesCollectionViewController = artPiecesCollectionViewController
//			}
//		}
		
		collectionView?.reloadData()
	}
	
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		if UIScreen.main.traitCollection.horizontalSizeClass == .regular,
			let selectedLocation = selectedLocation {
				showArtPiecesFromNavController(selectedLocation)
		}
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
	}
	
//	override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
//		if initialHorizontalSizeClass == .Compact {
//			displayDefaultArt()
//		}
//	}
	
	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		collectionView?.reloadData()
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("\(#file) \(#function)")
    }

	// MARK: Fetch Results Controller
	// FIXME: what is NSFetchRequestResult
	lazy var fetchResultsController:NSFetchedResultsController<Location> = {
		let fetchRequest = NSFetchRequest<Location>(entityName:ModelEntity.location)
        let sortDescriptor = [NSSortDescriptor(key:ModelAttributes.locationName, ascending:true, selector: #selector(NSString.localizedStandardCompare(_:)))]
		fetchRequest.sortDescriptors = sortDescriptor
		let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.moc!, sectionNameKeyPath: nil, cacheName: nil)
		return frc
		}()
	
	func cellWidthAvailable(_ screenWidth: CGFloat, cellsPerLine: Int, itemSpacing: CGFloat, flowLayout:UICollectionViewFlowLayout ) -> CGFloat {
		let numCells: CGFloat = CGFloat(cellsPerLine)
		var totalInterItemSpacing: CGFloat = 0.0
		var totalInsetSpacing: CGFloat = 0.0
		var totalSpacing: CGFloat = 0.0
		var spaceLeftForCells: CGFloat = 0.0
		var cell: CGFloat = 0.0
		
		totalInterItemSpacing = numCells * itemSpacing
		totalInsetSpacing = flowLayout.sectionInset.left + flowLayout.sectionInset.right
		totalSpacing = totalInterItemSpacing + totalInsetSpacing
		spaceLeftForCells = screenWidth - totalSpacing
		cell = spaceLeftForCells / numCells
		return cell
	}
	
	func resetVisibleCellBackgroundColors() {
		if let indexPathsVisible = self.collectionView?.indexPathsForVisibleItems ,
			let collectionView = collectionView {
				for path in indexPathsVisible { // hack fix for bug where deselected cells still look selected, sometimes
					let location = fetchResultsController.object(at: path)
					if location.artwork.count > 0 || location.name == "All"{
						let cell = collectionView.cellForItem(at: path) as? LocationCollectionViewCell
						cell?.backgroundColor = UIColor.white
						cell?.title.textColor = UIColor.black
					}
				}
		}
	}
	
    // MARK: UICollectionViewDataSource
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.LocationCollectionViewCell.rawValue, for: indexPath) as! LocationCollectionViewCell
		let location = fetchResultsController.object(at: indexPath)
	
		if location.name != "All" {
			cell.title.text = location.name
		} else {
			cell.title.text = "San Francisco"
		}

		if location.artwork.count > 0 || location.name == "All" {
			cell.backgroundColor = UIColor.white
			cell.title.textColor = UIColor.black
		} else  {
			cell.backgroundColor = UIColor.white
			cell.title.textColor =  UIColor.gray
		}
		
		return cell
	}
	
	override func numberOfSections(in collectionView: UICollectionView) -> Int {
		return fetchResultsController.sections?.count ?? 0
	}
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		let sectionInfo = fetchResultsController.sections![section] 
		return sectionInfo.numberOfObjects
	}
	
    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let location = fetchResultsController.object(at: indexPath)
        selectedLocation = location
        if UIScreen.main.traitCollection.horizontalSizeClass == .compact {
            showArtPiecesWithoutNavController(location)
        } else {
            showArtPiecesFromNavController(location)
        }
    }
	
	func showArtPiecesFromNavController(_ location: Location) {
		if let navigationController:UINavigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ArtPiecesNavControllerID") as? UINavigationController,
			let artPiecesCollectionViewController = navigationController.viewControllers.last as? ArtPiecesCollectionViewController {
				if location.name != "All" {
					let filter = ArtPiecesCollectionViewDataFilter(key: "idLocation", value: location.idLocation, title: location.name)
					artPiecesCollectionViewController.fetchFilter(filter)
				} else {
					artPiecesCollectionViewController.pageTitle = "San Francisco"
				}
				
				showDetailViewController(navigationController, sender: self)
		}
	}
	
	func showArtPiecesWithoutNavController(_ location: Location) {
		if let artPiecesCollectionViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ArtPiecesViewControllerID") as? ArtPiecesCollectionViewController {
			if location.name != "All" {
				let filter = ArtPiecesCollectionViewDataFilter(key: "idLocation", value: location.idLocation, title: location.name)
				artPiecesCollectionViewController.fetchFilter(filter)
			} else {
				artPiecesCollectionViewController.pageTitle = "San Francisco"
			}
			showDetailViewController(artPiecesCollectionViewController, sender: self)
		}
	}

	
	override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
		let location = fetchResultsController.object(at: indexPath)
		if location.artwork.count > 0 || location.name == "All" {
			return true
		}
		return false
	}

    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
		let location = fetchResultsController.object(at: indexPath) 
		if location.artwork.count > 0 || location.name == "All" {
			return true
		}
		return false
    }
	
	
	override func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
	
		resetVisibleCellBackgroundColors()
		if UIScreen.main.traitCollection.horizontalSizeClass == .regular {
			let cell = collectionView.cellForItem(at: indexPath) as? LocationCollectionViewCell
			cell?.backgroundColor = UIColor.black
			cell?.title.textColor = UIColor.white
		}
	}
	
	override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
		let cell = collectionView.cellForItem(at: indexPath) as? LocationCollectionViewCell
		cell?.backgroundColor = UIColor.white
		cell?.title.textColor = UIColor.black
	}
	
}

extension LocationsCollectionViewController : NSFetchedResultsControllerDelegate {
	
	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		collectionView?.reloadData()
	}
}


extension LocationsCollectionViewController: ArtworkLayoutDelegate {
	
	func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat {
		let height = width // photos for menus are always square
		return height
	}
	
	func collectionView(_ collectionView: UICollectionView, heightForAnnotationAtIndexPath indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat {
		return 0 // FIXME:
	}
}




