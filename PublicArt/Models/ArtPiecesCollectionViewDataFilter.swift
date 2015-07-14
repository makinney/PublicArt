//
//  ArtPiecesCollectionViewDataFilter.swift
//  PublicArt
//
//  Created by Michael Kinney on 7/14/15.
//  Copyright (c) 2015 makinney. All rights reserved.
//

import Foundation

struct ArtPiecesCollectionViewDataFilter: ArtPiecesCollectionViewControllerDataFilterProtocol {
	var fetchFilterKey: String
	var fetchFilterValue: String
	var pageTitle: String
	
	init(key: String, value: String, title: String) {
		fetchFilterKey = key
		fetchFilterValue = value
		pageTitle = title
	}
}
