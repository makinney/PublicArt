//
//  LocationExtension.swift
//  ArtCity
//
//  Created by Michael Kinney on 1/21/15.
//  Copyright (c) 2015 mkinney. All rights reserved.
//

import Foundation

import CoreData

extension Location {

	class func create(_ parseLocation: ParseLocation, moc: NSManagedObjectContext) -> Location? {
		if let location = NSEntityDescription.insertNewObject(forEntityName: ModelEntity.location, into:moc) as? Location {
			location.objectId = parseLocation.objectId!
			location.createdAt = parseLocation.createdAt!
			location.updatedAt = parseLocation.updatedAt!

			location.name = parseLocation.name ?? ""
			location.idLocation	= parseLocation.idLocation ?? ""
		
			let latitude = parseLocation.latitude ?? ""
			let longitude = parseLocation.longitude ?? ""
			let coordinates = mapCoordinates(latitude: latitude, longitude: longitude)
            location.longitude = NSNumber(value: coordinates.longitude)
            location.latitude = NSNumber(value: coordinates.latitude)
			
	
			return location
		}
		return nil
	}

	class func update(_ location: Location, parseLocation: ParseLocation) {
	
		location.objectId = parseLocation.objectId!
		location.createdAt = parseLocation.createdAt!
		location.updatedAt = parseLocation.updatedAt!
		
		location.name = parseLocation.name ?? ""
		location.idLocation	= parseLocation.idLocation ?? ""
		
		let latitude = parseLocation.latitude ?? ""
		let longitude = parseLocation.longitude ?? ""
		let coordinates = mapCoordinates(latitude: latitude, longitude: longitude)
        location.longitude = NSNumber(value: coordinates.longitude)
        location.latitude = NSNumber(value: coordinates.latitude)
	}
	
}
