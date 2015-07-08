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
			art.hasThumb = parseArt.hasThumb ?? false
			art.idArt = parseArt.idArt ?? ""
			art.idLocation = parseArt.idLocation ?? ""
			art.medium = parseArt.medium ?? ""
			art.missing = parseArt.missing ?? false
			art.tags = parseArt.tags ?? ""
			art.title = parseArt.title ?? ""
			art.address = parseArt.address ?? ""
			
			var latitude = parseArt.latitude ?? ""
			var longitude = parseArt.longitude ?? ""
			var coordinates = mapCoordinates(latitude: latitude, longitude: longitude)
			art.longitude = coordinates.longitude
			art.latitude = coordinates.latitude
			
			if let descriptionFile = parseArt.descriptionFile {
				art.descriptionFileName = descriptionFile.name
				art.descriptionFileURL = descriptionFile.url ?? ""
			}
			
			if let artWebLink = parseArt.artWebLink {
				art.artWebLink = artWebLink
			}
			if let artistWebLink = parseArt.artistWebLink {
				art.artistWebLink = artistWebLink
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
		art.hasThumb = parseArt.hasThumb ?? false
		art.idArt = parseArt.idArt ?? ""
		art.idLocation = parseArt.idLocation ?? ""
		art.medium = parseArt.medium ?? ""
		art.missing = parseArt.missing ?? false
		art.tags = parseArt.tags ?? ""
		art.title = parseArt.title ?? ""
		art.address = parseArt.address ?? ""
		
		var latitude = parseArt.latitude ?? ""
		var longitude = parseArt.longitude ?? ""
		var coordinates = mapCoordinates(latitude: latitude, longitude: longitude)
		art.longitude = coordinates.longitude
		art.latitude = coordinates.latitude
		
		if let descriptionFile = parseArt.descriptionFile {
			art.descriptionFileName = descriptionFile.name
			art.descriptionFileURL = descriptionFile.url ?? ""
		}
		
		if let artWebLink = parseArt.artWebLink {
			art.artWebLink = artWebLink
		}
		if let artistWebLink = parseArt.artistWebLink {
			art.artistWebLink = artistWebLink
		}
	}
	
}
