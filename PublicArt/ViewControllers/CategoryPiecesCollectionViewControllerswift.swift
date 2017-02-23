//
//  CategoryPiecesCollectionViewController.swift
//  ArtCity
//
//  Created by Michael Kinney on 5/2/15.
//  Copyright (c) 2015 mkinney. All rights reserved.
//

import UIKit
import CoreData


class CategoryPiecesCollectionViewController: UICollectionViewController, UINavigationControllerDelegate, UICollectionViewDelegateFlowLayout {
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
		
		setupArtCityPhotosFlowLayout()
		
		NotificationCenter.default.addObserver(self,
			selector:#selector(CategoryPiecesCollectionViewController.newArtCityDatabase(_:)),
			name: NSNotification.Name(rawValue: ArtAppNotifications.NewArtCityDatabase.rawValue),
			object: nil)
		
		
		NotificationCenter.default.addObserver(self,
			selector: #selector(CategoryPiecesCollectionViewController.contentSizeCategoryDidChange),
			name: NSNotification.Name.UIContentSizeCategoryDidChange,
			object: nil)
        
        if #available(iOS 10.0, *) {
            collectionView?.isPrefetchingEnabled = false
        } else {
            // Fallback on earlier versions
        }
		
		fetchResultsController.delegate = self
		do {
			try fetchResultsController.performFetch()
		} catch let error1 as NSError {
			error = error1
		}
		
		collectionView?.reloadData()
		
		userInterfaceIdion = traitCollection.userInterfaceIdiom
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.navigationController?.navigationBar.topItem?.title = "Category Pieces"
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
//		collectionView?.reloadData()
	}
	
	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
	
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
   //     let sortDescriptor = [NSSortDescriptor(key: ModelAttributes.artworkTitle, ascending: true, selector:  )]
        let sortDescriptor = [NSSortDescriptor(key: ModelAttributes.artworkTitle, ascending:true, selector: #selector(NSString.localizedStandardCompare))]

		fetchRequest.sortDescriptors = sortDescriptor
		let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.moc!, sectionNameKeyPath: nil, cacheName: nil)
		return frc
	}()
	
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
				collectionViewFlowLayout.sectionInset.left = sectionInset
				collectionViewFlowLayout.sectionInset.right = sectionInset
				let itemSpacing: CGFloat = sectionInset / 2.0
				collectionViewFlowLayout.minimumInteritemSpacing = itemSpacing

				
				minimumPhotosPerLine = 2
				let maxPhotoWidth = photoWidthAvailable(masterViewsWidth, photosPerLine: minimumPhotosPerLine, itemSpacing: itemSpacing, flowLayout: collectionViewFlowLayout)
				collectionViewFlowLayout.itemSize = CGSize(width: maxPhotoWidth, height: 1.33 * maxPhotoWidth) // TODO: hard constant hack for aspect ratio
			} else {
				let sectionInset: CGFloat = 5.0
				collectionViewFlowLayout.sectionInset.left = sectionInset
				collectionViewFlowLayout.sectionInset.right = sectionInset
				let itemSpacing: CGFloat = sectionInset / 2.0
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

}

extension CategoryPiecesCollectionViewController : NSFetchedResultsControllerDelegate {
	
	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		collectionView?.reloadData()
	}
}

