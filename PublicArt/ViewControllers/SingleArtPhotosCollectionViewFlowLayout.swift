//
//  SingleArtPhotosCollectionViewFlowLayout.swift
//  ArtCity
//
//  Created by Michael Kinney on 2/21/15.
//  Copyright (c) 2015 mkinney. All rights reserved.
//

import UIKit

class SingleArtPhotosCollectionViewFlowLayout: UICollectionViewFlowLayout {

	var currentPage: CGFloat = 0.0

	override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint) -> CGPoint {
		var contentOffset = CGPoint(x: 0.0,y: proposedContentOffset.y)
		if let collectionView = collectionView {
			var xPosition  = currentPage * itemSize.width
			contentOffset = CGPoint(x: xPosition, y: proposedContentOffset.y)
		}
		return contentOffset
	}

   
}
