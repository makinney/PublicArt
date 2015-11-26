//
//  ArtPiecesCollectionViewController.swift
//  ArtCity
//
//  Created by Michael Kinney on 5/2/15.
//  Copyright (c) 2015 mkinney. All rights reserved.
//

import UIKit
import CoreData

protocol ArtPiecesCollectionViewControllerDataFilterProtocol {
	var fetchFilterKey: String {get set}
	var fetchFilterValue: String {get set}
	var pageTitle: String {get set}
}

final class ArtPiecesCollectionViewController: UICollectionViewController, UINavigationControllerDelegate, UICollectionViewDelegateFlowLayout {
	private var collapseDetailViewController = true
	private var initialHorizontalSizeClass: UIUserInterfaceSizeClass?
	private var maxPhotoWidth: CGFloat = 0.0
	private let moc: NSManagedObjectContext?
	private var userInterfaceIdion: UIUserInterfaceIdiom = .Phone

	private var error:NSError?
	
	var fetchFilterKey: String?
	var fetchFilterValue: String?
	var pageTitle: String?
	
	func fetchFilter(filter: ArtPiecesCollectionViewControllerDataFilterProtocol) {
		fetchFilterKey = filter.fetchFilterKey
		fetchFilterValue = filter.fetchFilterValue
		pageTitle = filter.pageTitle
	}
	
	override init(collectionViewLayout: UICollectionViewLayout) {
		moc = CoreDataStack.sharedInstance.managedObjectContext
		super.init(collectionViewLayout: collectionViewLayout)
	}
	
	required init?(coder aDecoder: NSCoder) {
		moc = CoreDataStack.sharedInstance.managedObjectContext
		super.init(coder:aDecoder)
	}
	
	deinit {
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationController?.interactivePopGestureRecognizer?.enabled = false
		navigationController?.delegate = self
	
		let nibName = UINib(nibName: CellIdentifier.ArtworkCollectionViewCell.rawValue, bundle: nil) // TODO:
		self.collectionView?.registerNib(nibName, forCellWithReuseIdentifier: CellIdentifier.ArtworkCollectionViewCell.rawValue)
		setupArtPiecesPhotosFlowLayout()
		
		NSNotificationCenter.defaultCenter().addObserver(self,
			selector:"newArtCityDatabase:",
			name: ArtAppNotifications.NewArtCityDatabase.rawValue,
			object: nil)
		
		fetchResultsController.delegate = self
		do {
			try fetchResultsController.performFetch()
		} catch let error1 as NSError {
			error = error1
		}
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		if let pageTitle = pageTitle {
			title = pageTitle
		}
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
//		collectionView?.reloadData()
	}
	
	override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
//		if self.view.frame.size.width != size.width ||
//			self.view.frame.size.height != size.height {
//				setupArtCityPhotosFlowLayout()
//				collectionView?.reloadData()
//		
//		}
//		if initialHorizontalSizeClass == .Compact {
//			displayDefaultArt()
//		}
	}

	override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
		if let previousTraitCollection = previousTraitCollection {
			userInterfaceIdion = traitCollection.userInterfaceIdiom
			if userInterfaceIdion == .Pad {
				setupArtPiecesPhotosFlowLayout()
				collectionView?.reloadData()
			} else if traitCollection.horizontalSizeClass != previousTraitCollection.horizontalSizeClass ||
				traitCollection.verticalSizeClass != previousTraitCollection.verticalSizeClass {
				setupArtPiecesPhotosFlowLayout()
				collectionView?.reloadData()
			}
		}
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning() // TODO: FIXME this happens when rotating and trying different images
		print("\(__FILE__) did receive memory warning")

	}

	// MARK: Fetch Results Controller
	//
	lazy var fetchResultsController:NSFetchedResultsController = {
		let fetchRequest = NSFetchRequest(entityName:ModelEntity.art)
		
		if let key = self.fetchFilterKey,
			let value = self.fetchFilterValue {
			if key != "tags" {
				fetchRequest.predicate = NSPredicate(format:"%K == %@", key,value)
			} else {
				fetchRequest.predicate = NSPredicate(format:"%K CONTAINS[cd] %@", key,value)
			}
		}

		let sortDescriptor = [NSSortDescriptor(key:ModelAttributes.artworkTitle, ascending:true, selector: "localizedStandardCompare:")]
		fetchRequest.sortDescriptors = sortDescriptor
		let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.moc!, sectionNameKeyPath: nil, cacheName: nil)
		return frc
	}()
	
	
	func setupArtPiecesPhotosFlowLayout() {
		if let collectionViewFlowLayout: UICollectionViewFlowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
			collectionViewFlowLayout.scrollDirection = .Vertical
			let masterViewsWidth = splitViewController?.primaryColumnWidth ?? 100
			collectionViewFlowLayout.headerReferenceSize = CGSize(width: 0, height: 0)
			
			collectionViewFlowLayout.minimumLineSpacing = 5
				var minimumPhotosPerLine = 2 // ultimately up to flow layout
			
			userInterfaceIdion = traitCollection.userInterfaceIdiom
			if userInterfaceIdion == .Phone || userInterfaceIdion == .Unspecified {
				let sectionInset: CGFloat = 5.0
				collectionViewFlowLayout.sectionInset.left = sectionInset
				collectionViewFlowLayout.sectionInset.right = sectionInset
				let itemSpacing: CGFloat = sectionInset / 2.0
				collectionViewFlowLayout.minimumInteritemSpacing = itemSpacing

				
				minimumPhotosPerLine = 2
				maxPhotoWidth = photoWidthAvailable(masterViewsWidth, photosPerLine: minimumPhotosPerLine, itemSpacing: itemSpacing, flowLayout: collectionViewFlowLayout)
				collectionViewFlowLayout.itemSize = CGSize(width: maxPhotoWidth, height: maxPhotoWidth) // TODO: hard constant hack for aspect ratio
			} else {
				let sectionInset: CGFloat = 5.0
				collectionViewFlowLayout.sectionInset.left = sectionInset
				collectionViewFlowLayout.sectionInset.right = sectionInset
				let itemSpacing: CGFloat = sectionInset / 2.0
				collectionViewFlowLayout.minimumInteritemSpacing = itemSpacing
				minimumPhotosPerLine = 2
				maxPhotoWidth = photoWidthAvailable(masterViewsWidth, photosPerLine: minimumPhotosPerLine, itemSpacing: itemSpacing, flowLayout: collectionViewFlowLayout)
				collectionViewFlowLayout.itemSize = CGSize(width: maxPhotoWidth, height: maxPhotoWidth)
			}
		}
	}
	
	func photoWidthAvailable(screenWidth: CGFloat, photosPerLine: Int, itemSpacing: CGFloat, flowLayout:UICollectionViewFlowLayout ) -> CGFloat {
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
	
		
	override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CellIdentifier.ArtworkCollectionViewCell.rawValue, forIndexPath: indexPath) as! ArtworkCollectionViewCell
		let art = fetchResultsController.objectAtIndexPath(indexPath) as! Art
		cell.title.text = art.title
		if let thumb = art.thumb {
			if cell.imageView.image == nil { // prevents spinning over existing images
				cell.activityIndicator.startAnimating()
			} else {
				cell.imageView.image = nil //
			}
			cell.imageFileName = thumb.imageFileName
			ImageDownload.downloadThumb(art, complete: { (data, imageFileName) -> () in
				if let data = data
				   where cell.imageFileName == imageFileName {
					cell.imageView.image = UIImage(data: data) ?? UIImage()
				}
				cell.activityIndicator.stopAnimating()
			})
		}
		
		return cell
	}
		
	
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
		// default square
		var height: CGFloat = maxPhotoWidth
		var width: CGFloat = maxPhotoWidth
	
		if let art = fetchResultsController.objectAtIndexPath(indexPath) as? Art {
			if let thumb = art.thumb {
				let aspectRatio = thumb.imageAspectRatio as Double
				if aspectRatio > 0 && aspectRatio <= 1 {
					height = width / CGFloat(aspectRatio) + 21.0 // FIXME: hack based on label height
				} else if aspectRatio > 1 {
					width = width * 2.0  // FIXME fine tune
					height = width / CGFloat(aspectRatio) + 21.0 // FIXME: hack based on label height
				}
			}			
		}
		return CGSize(width: width, height: height)
	}
	
	
	override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return fetchResultsController.sections?.count ?? 0
	}
	
	override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		let sectionInfo = fetchResultsController.sections![section] 
		return sectionInfo.numberOfObjects
	}
	
	// MARK: ArtPhotos Navigation
	
	override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		if let art = fetchResultsController.objectAtIndexPath(indexPath) as? Art,
			let singleArtViewController: SingleArtViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(ViewControllerIdentifier.SingleArtViewController.rawValue) as?  SingleArtViewController {
			singleArtViewController.update(art, artBackgroundColor: nil)
			showViewController(singleArtViewController, sender: self)
		}
	}

	// MARK: Notification handlers
	func newArtCityDatabase(notification: NSNotification) {
		collectionView?.reloadData()
	}
}

extension ArtPiecesCollectionViewController : NSFetchedResultsControllerDelegate {
	
	func controllerDidChangeContent(controller: NSFetchedResultsController) {
		collectionView?.reloadData()
	}
}

