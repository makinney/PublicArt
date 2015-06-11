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
	
	class func fromJSON(json:JSON, moc: NSManagedObjectContext) -> (Location)? {
		//		println("\(__FUNCTION__) \(json)")
		
		if let location = NSEntityDescription.insertNewObjectForEntityForName(ModelEntity.location, inManagedObjectContext:moc) as? Location {
			location.idLocation = json["idLocation"].stringValue			
			location.createdAt = json["createdAt"].stringValue
			var latitude = json["latitude"].stringValue
			var longitude = json["longitude"].stringValue
			var coordinates = mapCoordinates(latitude: latitude, longitude: longitude)
			location.longitude = coordinates.longitude
			location.latitude = coordinates.latitude
			location.name = json["name"].stringValue
			location.objectId = json["objectId"].stringValue
			location.type = json["type"].stringValue
			location.updatedAt = json["updatedAt"].stringValue
			return location
		}
		return nil
	}
	
}