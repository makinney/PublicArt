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
	
	class func fromJSON(json:JSON) -> (Location)? {
		//		println("\(__FUNCTION__) \(json)")
		let moc = CoreDataStack.sharedInstance.managedObjectContext! // TODO - do not do this ! pass in instead , check other models
		
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