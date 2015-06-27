//
//  SingleArtPhotosCollectionViewController.swift
//  ArtCity
//
//  Created by Michael Kinney on 2/2/15.
//  Copyright (c) 2015 mkinney. All rights reserved.
//

import UIKit

class SingleArtPhotosCollectionViewController: UICollectionViewController {
 
	var art: Art? {
		didSet {
			if let art = art {
				photoFileNames = PhotoFileNames(art: art)
				collectionView?.reloadData()
			}
		}
	}
	
	var artPhotoImages: ArtPhotoImages = ArtPhotoImages.sharedInstance
	var photoFileNames: PhotoFileNames?
	var collectionViewFlowLayout = SingleArtPhotosCollectionViewFlowLayout()
	
	override init(collectionViewLayout: UICollectionViewLayout) {
		super.init(collectionViewLayout: collectionViewLayout)
	}

	required init(coder aDecoder: NSCoder) {
		super.init(coder:aDecoder)
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		var nibName = UINib(nibName: "SingleArtPhotosCollectionViewCell", bundle: nil) // TODO:
		self.collectionView?.registerNib(nibName, forCellWithReuseIdentifier: "SingleArtPhotosCollectionViewCell")
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
		println("\(__FILE__) did receive memory warning")
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
		var navBarHeight = navigationController?.navigationBar.frame.size.height ?? 0
		var tabBarHeight = tabBarController?.tabBar.frame.size.height ?? 0
		var statusBarHeight = UIApplication.sharedApplication().statusBarFrame.size.height ?? 0
		var collectionViewHeight = collectionView?.frame.height ?? 0
		
			if let collectionView = self.collectionView {
				var presentedViewHeight = collectionView.frame.size.height
				var presentedViewWidth = collectionView.frame.size.width
				if let presentationController = self.presentationController as? SingleArtPhotosPresentationController {
					presentedViewHeight = presentationController.frameOfPresentedViewInContainerView().height  - navBarHeight - tabBarHeight - statusBarHeight
					presentedViewWidth = presentationController.frameOfPresentedViewInContainerView().width
				}
				var height : CGFloat = presentedViewHeight  - collectionViewFlowLayout.sectionInset.top - collectionViewFlowLayout.sectionInset.bottom + 20 // FIXME: adding 20 allows vertical paging to line up,why ?
				collectionViewFlowLayout.itemSize = CGSize(width: presentedViewWidth, height: height)
			}
	}

	override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CellIdentifier.SingleArtPhotosCollectionViewCell.rawValue, forIndexPath: indexPath) as! SingleArtPhotosCollectionViewCell
		if let photoFileName = photoFileNames?.getFileName(indexPath.row) {
			artPhotoImages.getImage(photoFileName, completion: { (image) -> () in
				cell.imageView.image = image
			})
		} else {
			cell.imageView.image = nil
		}

		cell.backgroundColor = UIColor.clearColor()
		cell.imageView.backgroundColor = UIColor.clearColor()
		
		return cell
	}
	
	override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return 1
	}
	
	override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if let count = photoFileNames?.fileCount() {
			return count
		}
		return 0
	}
}
