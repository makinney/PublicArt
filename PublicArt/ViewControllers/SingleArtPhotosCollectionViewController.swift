//
//  SingleArtPhotosCollectionViewController.swift
//  ArtCity
//
//  Created by Michael Kinney on 2/2/15.
//  Copyright (c) 2015 mkinney. All rights reserved.
//

import UIKit

final class SingleArtPhotosCollectionViewController: UICollectionViewController {
 
	var art: Art? {
		didSet {
			if let art = art,
				let photoSet: Set<Photo> = art.photos as? Set {
				photos = convertToSortedArray(photoSet)
				photos = sortThumbnailPhotoToFirstPositionIn(photos!)
				collectionView?.reloadData()
			}
		}
	}
	
	var collectionViewFlowLayout = SingleArtPhotosCollectionViewFlowLayout()
	var photos: [Photo]?
	
	override init(collectionViewLayout: UICollectionViewLayout) {
		super.init(collectionViewLayout: collectionViewLayout)
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder:aDecoder)
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		let nibName = UINib(nibName: "SingleArtPhotosCollectionViewCell", bundle: nil) // TODO:
		self.collectionView?.registerNib(nibName, forCellWithReuseIdentifier: "SingleArtPhotosCollectionViewCell")
//		self.collectionView?.delegate = self
		self.view.backgroundColor = UIColor.clearColor()
		collectionView?.backgroundColor = UIColor.clearColor()
		collectionView?.reloadData() // required to prevent Assertion failure in -[UICollectionViewData numberOfItemsBeforeSection:]
    }

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		collectionView?.collectionViewLayout = collectionViewFlowLayout
		collectionViewFlowLayout.minimumLineSpacing = 0
		collectionViewFlowLayout.scrollDirection = .Horizontal
//		collectionViewFlowLayout.scrollDirection = .Vertical
//		if let collectionView = collectionView {
//			collectionViewFlowLayout.currentPage = collectionView.contentOffset.y / collectionView.bounds.height
//		}
		collectionView?.pagingEnabled = true
		updateItemSize()
		collectionView?.reloadData()
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
		print("\(__FILE__) did receive memory warning")
    }
	
	
	override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
		super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
		
		if let collectionView = collectionView {
			collectionViewFlowLayout.currentPage = collectionView.contentOffset.y / collectionView.bounds.height
		}
		
		coordinator.animateAlongsideTransitionInView(view, animation: { (context) -> Void in
				self.updateItemSize()
			}) { (context) -> Void in
		}
	}
	
	func updateItemSize() {
		let navBarHeight = navigationController?.navigationBar.frame.size.height ?? 0
		let tabBarHeight = tabBarController?.tabBar.frame.size.height ?? 0
		let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.size.height ?? 0
		//var collectionViewHeight = collectionView?.frame.height ?? 0
		
			if let collectionView = self.collectionView {
				var presentedViewHeight = collectionView.frame.size.height
				var presentedViewWidth = collectionView.frame.size.width
				if let presentationController = self.presentationController as? SingleArtPhotosPresentationController {
					presentedViewHeight = presentationController.frameOfPresentedViewInContainerView().height  - navBarHeight - tabBarHeight - statusBarHeight
					presentedViewWidth = presentationController.frameOfPresentedViewInContainerView().width
				}
				let height : CGFloat = presentedViewHeight  - collectionViewFlowLayout.sectionInset.top - collectionViewFlowLayout.sectionInset.bottom + 20 // FIXME: adding 20 allows vertical paging to line up,why ?
				collectionViewFlowLayout.itemSize = CGSize(width: presentedViewWidth, height: height)
			}
	}

	override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CellIdentifier.SingleArtPhotosCollectionViewCell.rawValue, forIndexPath: indexPath) as! SingleArtPhotosCollectionViewCell
		cell.imageView.image = nil
		if let photo = photos?[indexPath.row] {
			cell.imageFileName = photo.imageFileName
			cell.activityIndicator.startAnimating()
			PhotoImages.sharedInstance.getImage(photo, complete: { (image, imageFileName) -> () in
				if let image = image
					where cell.imageFileName == imageFileName {
						cell.imageView.image = image
				}
				cell.activityIndicator.stopAnimating()
			})
		}

		cell.backgroundColor = UIColor.clearColor()
		cell.imageView.backgroundColor = UIColor.clearColor()
		
		return cell
	}
	
	override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return 1
	}
	
	override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if let count = photos?.count {
			return count
		}
		return 0
	}
	
//	override func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
//		if let selectedIndex = self.collectionView?.indexPathsForVisibleItems().last as? NSIndexPath
//		{
//	//		self.collectionViewFlowLayout.invalidateLayout()
//			let cell = self.collectionView?.cellForItemAtIndexPath(selectedIndex)
//			return cell
//		}
//		return nil
////		return self.collectionView
//	}
//	
//	override func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView!, atScale scale: CGFloat) {
//
//	}
}
