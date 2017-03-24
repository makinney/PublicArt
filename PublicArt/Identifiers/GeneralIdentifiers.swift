//
//  GeneralIdentifiers.swift
//  City Art San Francisco
//
//  Created by Michael Kinney on 11/19/14.
//  Copyright (c) 2014 mkinney. All rights reserved.
//

import Foundation

public struct ImageFileName {
	static let NoThumbImage = "noThumb"
}


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
	case photosDownloaded = "PhotosDownloadedNotification"
	case newArtCityDatabase = "NewArtCityDatabase"
    case artDataDidBind = "artDataDidBind"
}



enum UserDefaultKeys: String {
	case lastPublicArtUpdate = "LastPublicArtUpdateKey"
	case singleArtViewPhotoTouchedAtLeastOnce = "KeySingleArtViewPhotoTouchedAtLeastOnce"
    case initialArtDataBindingsComplete = "KeyInitialArtDataBindingsComplete"
}



