//
//  ArtExtension.swift
//  City Art San Francisco
//
//  Created by Michael Kinney on 12/27/14.
//  Copyright (c) 2014 mkinney. All rights reserved.
//

import Foundation
import CoreData

extension Art {
	
	class func create(parseArt: ParseArt, moc: NSManagedObjectContext) -> Art? {
		
		if let art = NSEntityDescription.insertNewObjectForEntityForName(ModelEntity.art, inManagedObjectContext:moc) as? Art {
	
			art.objectId = parseArt.objectId!
			art.createdAt = parseArt.createdAt!
			art.updatedAt = parseArt.updatedAt!

			art.accession = parseArt.accession ?? ""
			art.artistName = parseArt.artistName ?? ""
			art.condition = parseArt.condition ?? ""
			art.credit = parseArt.credit ?? ""
		
			art.dimensions = parseArt.dimensions ?? ""
			art.hasThumbPhoto = parseArt.hasThumbPhoto ?? false
			art.idArt = parseArt.idArt ?? ""
			art.idLocation = parseArt.idLocation ?? ""
			art.medium = parseArt.medium ?? ""
			art.missing = parseArt.missing ?? false
			art.tags = parseArt.tags ?? ""
			art.title = parseArt.title ?? ""
			
			var latitude = parseArt.latitude ?? ""
			var longitude = parseArt.longitude ?? ""
			var coordinates = mapCoordinates(latitude: latitude, longitude: longitude)
			art.longitude = coordinates.longitude
			art.latitude = coordinates.latitude
			
			if let descriptionFile = parseArt.descriptionFile {
				art.descriptionFileName = descriptionFile.name
				art.descriptionFileURL = descriptionFile.url ?? ""
			}
			
			if let webLink = parseArt.webLink1 {
				art.webLinkName = webLink.name
				art.webLinkURL = webLink.url ?? ""
			}
			
			return art
		}
		
		return nil
	}
	
	class func update(art: Art, parseArt: ParseArt) {
		art.objectId = parseArt.objectId!
		art.createdAt = parseArt.createdAt!
		art.updatedAt = parseArt.updatedAt!
		
		art.accession = parseArt.accession ?? ""
		art.artistName = parseArt.artistName ?? ""
		art.condition = parseArt.condition ?? ""
		art.credit = parseArt.credit ?? ""
		
		art.dimensions = parseArt.dimensions ?? ""
		art.hasThumbPhoto = parseArt.hasThumbPhoto ?? false
		art.idArt = parseArt.idArt ?? ""
		art.idLocation = parseArt.idLocation ?? ""
		art.medium = parseArt.medium ?? ""
		art.missing = parseArt.missing ?? false
		art.tags = parseArt.tags ?? ""
		art.title = parseArt.title ?? ""
		
		var latitude = parseArt.latitude ?? ""
		var longitude = parseArt.longitude ?? ""
		var coordinates = mapCoordinates(latitude: latitude, longitude: longitude)
		art.longitude = coordinates.longitude
		art.latitude = coordinates.latitude
		
		if let descriptionFile = parseArt.descriptionFile {
			art.descriptionFileName = descriptionFile.name
			art.descriptionFileURL = descriptionFile.url ?? ""
		}
		
		if let webLink = parseArt.webLink1 {
			art.webLinkName = webLink.name
			art.webLinkURL = webLink.url ?? ""
		}		
	}
	
//	//
//	class func fromJSON(json:JSON, moc: NSManagedObjectContext) -> (Art)? {
//		
//		if let art = NSEntityDescription.insertNewObjectForEntityForName(ModelEntity.art, inManagedObjectContext:moc) as? Art {
//			art.artistName = json["artistName"].stringValue
//			art.createdAt = json["createdAt"].stringValue
//			art.credit = json["credit"].stringValue
//			art.dimensions = json["dimensions"].stringValue
//			art.idArt = json["idArt"].stringValue
//			art.idLocation = json["idLocation"].stringValue
//			var latitude = json["latitude"].stringValue
//			var longitude = json["longitude"].stringValue
//			var coordinates = mapCoordinates(latitude: latitude, longitude: longitude)
//			art.longitude = coordinates.longitude
//			art.latitude = coordinates.latitude
//			//			art.locDescription = json["locDescription"].stringValue
//			art.medium = json["medium"].stringValue
//			art.objectId = json["objectId"].stringValue
//			art.title = json["title"].stringValue
//			//			art.imageFileName = json["thumbFile"].stringValue
//			//			art.imageAspectRatio = json["imageAspectRatio"].double ?? 1.0
//			art.updatedAt = json["updatedAt"].stringValue
//			return art
//		}
//		
//		return nil
//	}
//	

	
}
