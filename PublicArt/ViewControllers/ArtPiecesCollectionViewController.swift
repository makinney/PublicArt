//
//  ArtPiecesCollectionViewController.swift
//  ArtCity
//
//  Created by Michael Kinney on 5/2/15.
//  Copyright (c) 2015 mkinney. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation

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
	
		let nibName = UINib(nibName: CellIdentifier.ArtworkCollectionViewCell.rawValue, bundle: nil)
		self.collectionView?.registerNib(nibName, forCellWithReuseIdentifier: CellIdentifier.ArtworkCollectionViewCell.rawValue)
		
		let artworkCollectionViewLayout = collectionViewLayout as! ArtworkCollectionViewLayout
		artworkCollectionViewLayout.cellPadding = 5
		artworkCollectionViewLayout.delegate = self
		artworkCollectionViewLayout.numberOfColumns = 2
		
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
		
		collectionView?.backgroundColor = UIColor.blackColor()
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
//		collectionView?.reloadData()
	}
	

	override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
		if let previousTraitCollection = previousTraitCollection {
			userInterfaceIdion = traitCollection.userInterfaceIdiom
			if userInterfaceIdion == .Pad {
				collectionView?.reloadData()
			} else if traitCollection.horizontalSizeClass != previousTraitCollection.horizontalSizeClass ||
				traitCollection.verticalSizeClass != previousTraitCollection.verticalSizeClass {
				collectionView?.reloadData()
			}
		}
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		print("\(__FILE__) did receive memory warning")

	}

	// MARK: Fetch Results Controller
	//
	lazy var fetchResultsController:NSFetchedResultsController = {
		let fetchRequest = NSFetchRequest(entityName:ModelEntity.art)
		var predicates = [NSPredicate]()
		// TODO: fixme should support multiple key:values
		if let key = self.fetchFilterKey,
			let value = self.fetchFilterValue {
			if key != "tags" {
				predicates.append(NSPredicate(format:"%K == %@", key,value))
			} else {
				predicates.append(NSPredicate(format:"%K CONTAINS[cd] %@", key,value))
			}
		}
		//
		predicates.append(NSPredicate(format:"%K == %@", "hasThumb",NSNumber(bool: true))) // has photos
		
		var compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
		fetchRequest.predicate = compoundPredicate

		let sortDescriptor = [NSSortDescriptor(key:"hasThumb", ascending:false, selector: "localizedStandardCompare:"), NSSortDescriptor(key:ModelAttributes.artworkTitle, ascending:true, selector: "localizedStandardCompare:")]
		fetchRequest.sortDescriptors = sortDescriptor
		let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.moc!, sectionNameKeyPath: nil, cacheName: nil)
		return frc
	}()
	
	
	override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CellIdentifier.ArtworkCollectionViewCell.rawValue, forIndexPath: indexPath) as! ArtworkCollectionViewCell

		let art = fetchResultsController.objectAtIndexPath(indexPath) as! Art

		if cell.imageView.image == nil { // prevents spinning over existing images
			cell.activityIndicator.startAnimating()
		}

		ThumbImages.sharedInstance.getImage(art, complete: { (image, imageFileName) -> () in
			if let image = image {
				cell.imageView.image = image
				cell.title.text = art.title
				cell.noImageTitle.text = ""
			} else {
				cell.imageView.image = nil
				cell.title.text = ""
				cell.noImageTitle.text = art.title
			}
			
			cell.activityIndicator.stopAnimating()
		})
		
		return cell
	}
		
	override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return fetchResultsController.sections?.count ?? 0
	}
	
	override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		let sectionInfo = fetchResultsController.sections![section]
		print("\(sectionInfo.numberOfObjects) fetched")
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

extension ArtPiecesCollectionViewController: ArtworkLayoutDelegate {
	
	func collectionView(collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat {
		var height: CGFloat = 100
		let boundingRect = CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT)) //
		var imageHeight = width //
		
		if let art = fetchResultsController.objectAtIndexPath(indexPath) as? Art,
			let thumb = art.thumb {
				imageHeight = width / (thumb.imageAspectRatio as CGFloat)
		} else {
			imageHeight = width * 0.25
		}
		
		let rect = AVMakeRectWithAspectRatioInsideRect(CGSize(width: width, height: imageHeight), boundingRect)
		height = rect.height
		return height
	}
	
	func collectionView(collectionView: UICollectionView, heightForAnnotationAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat {
		return 25 // FIXME:
	}
}


extension ArtPiecesCollectionViewController : NSFetchedResultsControllerDelegate {
	
	func controllerDidChangeContent(controller: NSFetchedResultsController) {
		collectionView?.reloadData()
	}
}

