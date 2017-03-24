//
//  ArtworkCollectionViewLayout.swift
//  PublicArt
//
//  Created by Michael Kinney on 1/15/16.
//  Copyright © 2016 makinney. All rights reserved.
//

import UIKit

protocol ArtworkLayoutDelegate {
	func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat
	func collectionView(_ collectionView: UICollectionView, heightForAnnotationAtIndexPath indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat
}


class ArtworkLayoutAttributes: UICollectionViewLayoutAttributes {
	
	var photoHeight: CGFloat = 0
	
	override func copy(with zone: NSZone?) -> Any {
		let copy = super.copy(with: zone) as! ArtworkLayoutAttributes
		copy.photoHeight = photoHeight
		return copy
	}
	
	override func isEqual(_ object: Any?) -> Bool {
		if let attributes = object as? ArtworkLayoutAttributes {
			if attributes.photoHeight == photoHeight {
				return super.isEqual(object)
			}
		}
		return false
	}
}

class ArtworkCollectionViewLayout: UICollectionViewLayout {

	var delegate: ArtworkLayoutDelegate?
	var cellPadding: CGFloat = 0
	var numberOfColumns = 2
	
	fileprivate var cache = [ArtworkLayoutAttributes]()
	fileprivate var contentHeight: CGFloat = 0
	fileprivate var width: CGFloat {
		get {
			guard let collectionView = collectionView else {
				return 1
			}
			let insets = collectionView.contentInset
			return collectionView.bounds.width - (insets.left + insets.right)
		}
	}
	
	override class var layoutAttributesClass : AnyClass {
		return ArtworkLayoutAttributes.self
	}
	
	override var collectionViewContentSize : CGSize {
		return CGSize(width: width, height: contentHeight)
	}
	
	override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
		cache = []
		return true
	}


	 override func prepare() {
		guard let delegate = delegate,
              collectionView!.numberOfSections > 0 else {
			return
		}
		if cache.isEmpty {
			let columnWidth = width / CGFloat(numberOfColumns)
			
			var xOffsets = [CGFloat]()
			for column in 0..<numberOfColumns {
				xOffsets.append(CGFloat(column) * columnWidth)
			}
			
			var yOffsets = [CGFloat](repeating: 0, count: numberOfColumns)
			
			var column = 0
			for item in 0..<collectionView!.numberOfItems(inSection: 0) {
				let indexPath = IndexPath(item: item, section: 0)
				
				let width = columnWidth - (cellPadding * 2)
				let photoHeight = delegate.collectionView(collectionView!, heightForPhotoAtIndexPath: indexPath, withWidth: width)
				let annotationHeight = delegate.collectionView(collectionView!, heightForAnnotationAtIndexPath: indexPath, withWidth: width)
				let height = cellPadding + photoHeight + annotationHeight + cellPadding
				
				let frame = CGRect(x: xOffsets[column], y: yOffsets[column], width: columnWidth, height: height)
				let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
				let attributes = ArtworkLayoutAttributes(forCellWith: indexPath)
				attributes.frame = insetFrame
				attributes.photoHeight = photoHeight
				cache.append(attributes)
				contentHeight = max(contentHeight, frame.maxY)
				yOffsets[column] = yOffsets[column] + height
                if column >= numberOfColumns - 1 {
                    column = 0
                } else {
                    column += 1
                }
			}
		}
	}
	
	override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
		var layoutAttributes = [UICollectionViewLayoutAttributes]()
		for attributes in cache {
			if attributes.frame.intersects(rect) {
				layoutAttributes.append(attributes)
			}
		}
		return layoutAttributes
	}

}






























