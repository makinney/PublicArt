//
//  LocationPiecesCollectionViewController.swift
//  ArtCity
//
//  Created by Michael Kinney on 5/2/15.
//  Copyright (c) 2015 mkinney. All rights reserved.
//

import UIKit
import CoreData
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}



final class LocationPiecesCollectionViewController: UICollectionViewController, UINavigationControllerDelegate, UICollectionViewDelegateFlowLayout {
	fileprivate var collapseDetailViewController = true
	fileprivate var initialHorizontalSizeClass: UIUserInterfaceSizeClass?
	

	fileprivate var error:NSError?
	fileprivate let moc: NSManagedObjectContext?
	
//	private lazy var artNavController:UINavigationController = {
//		var navigationController:UINavigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(ViewControllerIdentifier.ArtNavigationController.rawValue) as! UINavigationController
//		var vc = navigationController.viewControllers.last as! UIViewController!
//		vc.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
//		vc.navigationItem.leftItemsSupplementBackButton = true
//		return navigationController
//		}()

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
		NotificationCenter.default.removeObserver(self)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationController?.interactivePopGestureRecognizer?.isEnabled = false
		navigationController?.delegate = self
		
		
		let nibName = UINib(nibName: "ArtworkCollectionViewCell", bundle: nil) // TODO:
		self.collectionView?.register(nibName, forCellWithReuseIdentifier: "ArtworkCollectionViewCell")
//		var subNibName = UINib(nibName: "ArtCitySupplementaryView", bundle: nil) // TODO:
//		self.collectionView?.registerNib(subNibName, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "ArtCitySupplementaryView")
        if #available(iOS 10.0, *) {
                collectionView?.isPrefetchingEnabled = false
              } else {
                // Fallback on earlier versions
        }

		setupArtCityPhotosFlowLayout()
		
		NotificationCenter.default.addObserver(self,
			selector:#selector(LocationPiecesCollectionViewController.newArtCityDatabase(_:)),
			name: NSNotification.Name(rawValue: ArtAppNotifications.newArtCityDatabase.rawValue),
			object: nil)
		
		
		NotificationCenter.default.addObserver(self,
			selector: #selector(LocationPiecesCollectionViewController.contentSizeCategoryDidChange),
			name: NSNotification.Name.UIContentSizeCategoryDidChange,
			object: nil)
		
		fetchResultsController.delegate = self
		do {
			try fetchResultsController.performFetch()
		} catch let error1 as NSError {
			error = error1
		}
		
		collectionView?.reloadData()
		
		userInterfaceIdion = traitCollection.userInterfaceIdiom
		if userInterfaceIdion == .pad {
			displayDefaultArt()
		}

	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.navigationController?.navigationBar.topItem?.title = "Location Pieces"
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
//		collectionView?.reloadData()
	}
	
	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		if initialHorizontalSizeClass == .compact {
			displayDefaultArt()
		}
	}
	
	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
	//	setupArtCityPhotosFlowLayout()
//		collectionView?.reloadData()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning() // TODO: FIXME this happens when rotating and trying different images
		print("\(#file) did receive memory warning")

	}

	// MARK: Fetch Results Controller
	//
	lazy var fetchResultsController:NSFetchedResultsController<Art> = {
		let fetchRequest = NSFetchRequest<Art>(entityName:ModelEntity.art)
		fetchRequest.predicate = NSPredicate(format:"%K != %@", "thumbFile", "") // TODO: define
/*	// sort by location and then title
		let sortDescriptor = [NSSortDescriptor(key: "locationName", ascending: true, selector: "localizedStandardCompare:"),
			NSSortDescriptor(key:ModelAttributes.artworkTitle, ascending:true, selector: "localizedStandardCompare:")]
*/
        let sortDescriptor = [NSSortDescriptor(key:ModelAttributes.artworkTitle, ascending:true, selector: #selector(NSString.localizedStandardCompare(_:)))]

		fetchRequest.sortDescriptors = sortDescriptor
		let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.moc!, sectionNameKeyPath: nil, cacheName: nil)
		return frc
	}()
	
	func displayDefaultArt() {
		if fetchResultsController.fetchedObjects?.count > 0 {
//			let indexPath = NSIndexPath(forItem: 0, inSection: 0)
//			if let art = fetchResultsController.objectAtIndexPath(indexPath) as? Art {
//				if let singleArtViewController = artNavController.viewControllers.last as? SingleArtViewController {
//						artPhotoImages.getImage(art.thumbFile, completion: { [weak self] (image) -> () in
//						if let image = image {
//							singleArtViewController.update(art, artBackgroundColor: nil)
//						}
//					})
//					showDetailViewController(artNavController, sender: self)
//				}
//			}
		}
	}
	
	func setupArtCityPhotosFlowLayout() {
		if let collectionViewFlowLayout: UICollectionViewFlowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
			collectionViewFlowLayout.scrollDirection = .vertical
			let masterViewsWidth = splitViewController?.primaryColumnWidth ?? 100
			collectionViewFlowLayout.headerReferenceSize = CGSize(width: 0, height: 0)
			
			collectionViewFlowLayout.minimumLineSpacing = 5
				var minimumPhotosPerLine = 0 // ultimately up to flow layout
			
			userInterfaceIdion = traitCollection.userInterfaceIdiom
			if userInterfaceIdion == .phone || userInterfaceIdion == .unspecified {
				let sectionInset: CGFloat = 5.0
				collectionViewFlowLayout.sectionInset.top = sectionInset
				collectionViewFlowLayout.sectionInset.left = sectionInset
				collectionViewFlowLayout.sectionInset.right = sectionInset
				let itemSpacing: CGFloat = 2.5
				collectionViewFlowLayout.minimumInteritemSpacing = itemSpacing

				
				minimumPhotosPerLine = 2
				let maxPhotoWidth = photoWidthAvailable(masterViewsWidth, photosPerLine: minimumPhotosPerLine, itemSpacing: itemSpacing, flowLayout: collectionViewFlowLayout)
				collectionViewFlowLayout.itemSize = CGSize(width: maxPhotoWidth, height: 1.33 * maxPhotoWidth) // TODO: hard constant hack for aspect ratio
			} else {
				let sectionInset: CGFloat = 5.0
				collectionViewFlowLayout.sectionInset.top = sectionInset
				collectionViewFlowLayout.sectionInset.left = sectionInset
				collectionViewFlowLayout.sectionInset.right = sectionInset
				let itemSpacing: CGFloat = 2.5
				collectionViewFlowLayout.minimumInteritemSpacing = itemSpacing
				minimumPhotosPerLine = 2
				let maxPhotoWidth = photoWidthAvailable(masterViewsWidth, photosPerLine: minimumPhotosPerLine, itemSpacing: itemSpacing, flowLayout: collectionViewFlowLayout)
				collectionViewFlowLayout.itemSize = CGSize(width: maxPhotoWidth, height: 1.33 * maxPhotoWidth)
			}
		}
	}
	
	func photoWidthAvailable(_ screenWidth: CGFloat, photosPerLine: Int, itemSpacing: CGFloat, flowLayout:UICollectionViewFlowLayout ) -> CGFloat {
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
	
		
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.ArtworkCollectionViewCell.rawValue, for: indexPath) as! ArtworkCollectionViewCell
//		let art = fetchResultsController.objectAtIndexPath(indexPath) as! Art
//		cell.imageUrl = art.thumbFile
		cell.imageView.image = nil
//		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
//			if let thumbNail = self.artPhotoImages.getThumbNailWith(cell.imageUrl, size: cell.imageView.frame.size) {
//				if thumbNail.fileName == cell.imageUrl {
//					dispatch_async(dispatch_get_main_queue(), {
//						[weak self] in
//						cell.imageView.image = thumbNail.image
//						cell.title.alpha = 1.0
//						cell.title.text = art.title
//						cell.title.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody) // TODO: has to be a better way
//						// FIXME: this should be done one time somehow as it can slow scrolling down
//						})
//				} else {
//	//				cell.imageView.image = nil
//	//				cell.title.text = ""
//	//				cell.photoBorderView.backgroundColor = UIColor.whiteColor()
//				}
//			}
//		})
		
		return cell
	}
		
	
	
//	override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
//		var supplementaryView: UICollectionReusableView = UICollectionReusableView()
//		if kind == UICollectionElementKindSectionHeader {
//			supplementaryView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "ArtCitySupplementaryView", forIndexPath: indexPath) as! UICollectionReusableView // TODO:
//			if let supplementaryView = supplementaryView as? ArtCitySupplementaryView {
//				if let sections = fetchResultsController.sections {
//					var tableSections = sections as NSArray
//					var locationSection = tableSections[indexPath.section] as! NSFetchedResultsSectionInfo
//					supplementaryView.label.text = locationSection.name ?? ""
//					supplementaryView.label.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody) // TODO: has to be a better way
//				}
//			}
//			
//		}
//		return supplementaryView
//	}
	
	override func numberOfSections(in collectionView: UICollectionView) -> Int {
		return fetchResultsController.sections?.count ?? 0
	}
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		let sectionInfo = fetchResultsController.sections![section] 
		return sectionInfo.numberOfObjects
	}
	
	// MARK: ArtPhotos Navigation
	
	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//		if let art = fetchResultsController.objectAtIndexPath(indexPath) as? Art {
//			if let singleArtViewController = artNavController.viewControllers.last as? SingleArtViewController {
//				singleArtViewController.update(art, artBackgroundColor: nil)
//				showDetailViewController(artNavController, sender: self)
//			}
//		}
	}

	
//	override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
//		super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
//		
//		if let artPhotoCollectionViewFlowLayout = self.artPhotoCollectionViewFlowLayout {
//			artPhotoCollectionViewFlowLayout.currentPage = collectionView!.contentOffset.x / collectionView!.bounds.width
//		}
//		
//		coordinator.animateAlongsideTransitionInView(view, animation: { (context) -> Void in
//			if let artPhotoCollectionViewFlowLayout = self.artPhotoCollectionViewFlowLayout {
//				self.setupArtPhotosFullScreenItemSize(artPhotoCollectionViewFlowLayout)
//			}
//			
//			}) { (context) -> Void in
//				var i = 0.0
//		}
//	}
	
	// MARK: Notification handlers
	
	func contentSizeCategoryDidChange() {
		collectionView?.reloadData()
	}
	
	func newArtCityDatabase(_ notification: Notification) {
		collectionView?.reloadData()
	}
	
	// MARK: Misc
	func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
		//		self.collectionView?.alpha = 0.0
	}
	
	func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
		//		self.collectionView?.alpha = 1.0
	}
	

	
	
	// MARK: UICollectionViewDelegate

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

extension LocationPiecesCollectionViewController : NSFetchedResultsControllerDelegate {
	
	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		collectionView?.reloadData()
	}
}

