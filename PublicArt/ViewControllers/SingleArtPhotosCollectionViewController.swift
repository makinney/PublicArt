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
		self.collectionView?.register(nibName, forCellWithReuseIdentifier: "SingleArtPhotosCollectionViewCell")
//		self.collectionView?.delegate = self
		self.view.backgroundColor = UIColor.clear
		collectionView?.backgroundColor = UIColor.clear
        if #available(iOS 10.0, *) {
            collectionView?.isPrefetchingEnabled = false
        } else {
            // Fallback on earlier versions
        }

		collectionView?.reloadData() // required to prevent Assertion failure in -[UICollectionViewData numberOfItemsBeforeSection:]
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		collectionView?.collectionViewLayout = collectionViewFlowLayout
		collectionViewFlowLayout.minimumLineSpacing = 0
		collectionViewFlowLayout.scrollDirection = .horizontal
//		collectionViewFlowLayout.scrollDirection = .Vertical
//		if let collectionView = collectionView {
//			collectionViewFlowLayout.currentPage = collectionView.contentOffset.y / collectionView.bounds.height
//		}
		collectionView?.isPagingEnabled = true
		updateItemSize()
		collectionView?.reloadData()
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
		print("\(#file) did receive memory warning")
    }
	
	
	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		super.viewWillTransition(to: size, with: coordinator)
		
		if let collectionView = collectionView {
			collectionViewFlowLayout.currentPage = collectionView.contentOffset.y / collectionView.bounds.height
		}
		
		coordinator.animateAlongsideTransition(in: view, animation: { (context) -> Void in
				self.updateItemSize()
			}) { (context) -> Void in
		}
	}
	
	func updateItemSize() {
		let navBarHeight = navigationController?.navigationBar.frame.size.height ?? 0
		let tabBarHeight = tabBarController?.tabBar.frame.size.height ?? 0
		let statusBarHeight = UIApplication.shared.statusBarFrame.size.height 
		//var collectionViewHeight = collectionView?.frame.height ?? 0
		
			if let collectionView = self.collectionView {
				var presentedViewHeight = collectionView.frame.size.height
				var presentedViewWidth = collectionView.frame.size.width
				if let presentationController = self.presentationController as? SingleArtPhotosPresentationController {
                    presentedViewHeight = presentationController.frameOfPresentedViewInContainerView.height - navBarHeight - tabBarHeight - statusBarHeight
					presentedViewWidth = presentationController.frameOfPresentedViewInContainerView.width
				}
				let height : CGFloat = presentedViewHeight  - collectionViewFlowLayout.sectionInset.top - collectionViewFlowLayout.sectionInset.bottom + 20 // FIXME: adding 20 allows vertical paging to line up,why ?
				collectionViewFlowLayout.itemSize = CGSize(width: presentedViewWidth, height: height)
			}
	}

	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.SingleArtPhotosCollectionViewCell.rawValue, for: indexPath) as! SingleArtPhotosCollectionViewCell
		cell.imageView.image = nil
		if let photo = photos?[indexPath.row] {
			cell.imageFileName = photo.imageFileName
			cell.activityIndicator.startAnimating()
			PhotoImages.sharedInstance.getImage(photo, complete: { (image, imageFileName) -> () in
				if let image = image, cell.imageFileName == imageFileName {
						cell.imageView.image = image
				}
				cell.activityIndicator.stopAnimating()
			})
		}

		cell.backgroundColor = UIColor.clear
		cell.imageView.backgroundColor = UIColor.clear
		
		return cell
	}
	
	override func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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
