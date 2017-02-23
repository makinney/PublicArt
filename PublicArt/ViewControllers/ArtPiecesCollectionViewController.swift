//
//  ArtPiecesCollectionViewController.swift
//  ArtCity
//
//  Created by Michael Kinney on 5/2/15.2
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
	fileprivate var collapseDetailViewController = true
	fileprivate var initialHorizontalSizeClass: UIUserInterfaceSizeClass?
	fileprivate var maxPhotoWidth: CGFloat = 0.0
	fileprivate let moc: NSManagedObjectContext?
	fileprivate var userInterfaceIdion: UIUserInterfaceIdiom = .phone

	fileprivate var error:NSError?
	
	var fetchFilterKey: String?
	var fetchFilterValue: String?
	var pageTitle: String?
	
	func fetchFilter(_ filter: ArtPiecesCollectionViewControllerDataFilterProtocol) {
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
		NotificationCenter.default.removeObserver(self)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationController?.interactivePopGestureRecognizer?.isEnabled = false
		navigationController?.delegate = self
	
		let nibName = UINib(nibName: CellIdentifier.ArtworkCollectionViewCell.rawValue, bundle: nil)
		self.collectionView?.register(nibName, forCellWithReuseIdentifier: CellIdentifier.ArtworkCollectionViewCell.rawValue)
        if #available(iOS 10.0, *) {
            collectionView?.isPrefetchingEnabled = false
        } else {
            // Fallback on earlier versions
        }
		
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
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		if let pageTitle = pageTitle {
			title = pageTitle
		}
		
		collectionView?.backgroundColor = UIColor.black
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
//		collectionView?.reloadData()
	}
	

	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		if let previousTraitCollection = previousTraitCollection {
			userInterfaceIdion = traitCollection.userInterfaceIdiom
			if userInterfaceIdion == .pad {
				collectionView?.reloadData()
			} else if traitCollection.horizontalSizeClass != previousTraitCollection.horizontalSizeClass ||
				traitCollection.verticalSizeClass != previousTraitCollection.verticalSizeClass {
				collectionView?.reloadData()
			}
		}
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		print("\(#file) did receive memory warning")

	}

	// MARK: Fetch Results Controller
	//
	lazy var fetchResultsController:NSFetchedResultsController<Art> = {
		let fetchRequest = NSFetchRequest<Art>(entityName:ModelEntity.art)
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
		predicates.append(NSPredicate(format:"%K == %@", "hasThumb",NSNumber(value: true as Bool))) // has photos FIXME: Swift 3 what is true as Bool
		
		var compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
		fetchRequest.predicate = compoundPredicate

		let sortDescriptor = [NSSortDescriptor(key:"hasThumb", ascending:false, selector: #selector(NSString.localizedStandardCompare(_:))), NSSortDescriptor(key:ModelAttributes.artworkTitle, ascending:true, selector: #selector(NSString.localizedStandardCompare(_:)))]
		fetchRequest.sortDescriptors = sortDescriptor
		let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.moc!, sectionNameKeyPath: nil, cacheName: nil)
		return frc
	}()
	
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.ArtworkCollectionViewCell.rawValue, for: indexPath) as! ArtworkCollectionViewCell

		let art = fetchResultsController.object(at: indexPath)

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
		
	override func numberOfSections(in collectionView: UICollectionView) -> Int {
		return fetchResultsController.sections?.count ?? 0
	}
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		let sectionInfo = fetchResultsController.sections![section]
		return sectionInfo.numberOfObjects
	}
	
	// MARK: ArtPhotos Navigation
	
	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let art = fetchResultsController.object(at: indexPath)
		if let singleArtViewController: SingleArtViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: ViewControllerIdentifier.SingleArtViewController.rawValue) as?  SingleArtViewController {
			singleArtViewController.update(art, artBackgroundColor: nil)
			show(singleArtViewController, sender: self)
		}
	}

	// MARK: Notification handlers
	func newArtCityDatabase(_ notification: Notification) {
		collectionView?.reloadData()
	}
}

extension ArtPiecesCollectionViewController: ArtworkLayoutDelegate {
	
	func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat {
		var height: CGFloat = 100
		let boundingRect = CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT)) //
		var imageHeight = width //
		
        let art = fetchResultsController.object(at: indexPath)
        
		if let thumb = art.thumb {
            imageHeight = width / (thumb.imageAspectRatio as CGFloat)
		} else {
			imageHeight = width * 0.25
		}
		
		let rect = AVMakeRect(aspectRatio: CGSize(width: width, height: imageHeight), insideRect: boundingRect)
		height = rect.height
		return height
	}
	
	func collectionView(_ collectionView: UICollectionView, heightForAnnotationAtIndexPath indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat {
		return 25 // FIXME:
	}
}


extension ArtPiecesCollectionViewController : NSFetchedResultsControllerDelegate {
	
	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		collectionView?.reloadData()
	}
}

