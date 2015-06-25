//
//  CoreDataIdentifiers.swift
//  City Art San Francisco
//
//  Created by Michael Kinney on 11/19/14.
//  Copyright (c) 2014 mkinney. All rights reserved.
//

import Foundation

struct ModelEntity {
	static let art = "Art"
	static let artist = "Artist"
	static let location = "Location"
	static let locPhoto = "LocPhoto"
	static let photo = "Photo"
	static let thumb = "Thumb"
	static let objectId = "objectId"
}

struct ModelAttributes {
	static let artworkTitle = "title" // TODO: move to the model attribute name structure
	static let locationName = "name"
}

