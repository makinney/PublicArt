//
//  GeneralIdentifiers.swift
//  City Art San Francisco
//
//  Created by Michael Kinney on 11/19/14.
//  Copyright (c) 2014 mkinney. All rights reserved.
//

import Foundation

public enum SortMode {
	case byTitle
	case byNeighborhood
	case byArtist
}

public enum SortOrder {
	case ascending
	case descending
	case unordered
}

public enum ArtAppNotifications: String {
	case PhotosDownloaded = "PhotosDownloadedNotification"
	case NewArtCityDatabase = "NewArtCityDatabase"
}

enum UserDefaultKeys: String {
	case LastPublicArtUpdate = "LastPublicArtUpdateKey"
	case SingleArtViewPhotoTouchedAtLeastOnce = "KeySingleArtViewPhotoTouchedAtLeastOnce"
}



