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
	
	class func create(_ parseArt: ParseArt, moc: NSManagedObjectContext) -> Art? {
		
		if let art = NSEntityDescription.insertNewObject(forEntityName: ModelEntity.art, into:moc) as? Art {
	
			art.objectId = parseArt.objectId!
			art.createdAt = parseArt.createdAt!
			art.updatedAt = parseArt.updatedAt!

			art.accession = parseArt.accession ?? ""
			art.condition = parseArt.condition ?? ""
			art.credit = parseArt.credit ?? ""
		
			art.dimensions = parseArt.dimensions ?? ""
			art.hasThumb = parseArt.hasThumb as NSNumber? ?? false // FIXME: Swift 3  why NSNumber?
			art.idArt = parseArt.idArt ?? ""
			art.idArtist = parseArt.idArtist ?? ""
			art.idLocation = parseArt.idLocation ?? ""
			art.medium = parseArt.medium ?? ""
			art.missing = parseArt.missing as NSNumber? ?? false
			art.tags = parseArt.tags ?? ""
			art.title = parseArt.title ?? ""
			art.address = parseArt.address ?? ""
			
			let latitude = parseArt.latitude ?? ""
			let longitude = parseArt.longitude ?? ""
			let coordinates = mapCoordinates(latitude: latitude, longitude: longitude)
			art.longitude = NSNumber(value: coordinates.longitude)
			art.latitude = NSNumber(value: coordinates.latitude)
			art.artWebLink = parseArt.artWebLink ?? ""
			
			if let descriptionFile = parseArt.descriptionFile {
				art.descriptionFileName = descriptionFile.name
				art.descriptionFileURL = descriptionFile.url ?? ""
			}
			
			return art
		}
		
		return nil
	}
	

	class func update(_ art: Art, parseArt: ParseArt) {
		art.objectId = parseArt.objectId!
		art.createdAt = parseArt.createdAt!
		art.updatedAt = parseArt.updatedAt!
		
		art.accession = parseArt.accession ?? ""
		art.condition = parseArt.condition ?? ""
		art.credit = parseArt.credit ?? ""
		
		art.dimensions = parseArt.dimensions ?? ""
		art.hasThumb = parseArt.hasThumb as NSNumber? ?? false
		art.idArt = parseArt.idArt ?? ""
		art.idArtist = parseArt.idArtist ?? ""
		art.idLocation = parseArt.idLocation ?? ""
		art.medium = parseArt.medium ?? ""
		art.missing = parseArt.missing as NSNumber? ?? false
		art.tags = parseArt.tags ?? ""
		art.title = parseArt.title ?? ""
		art.address = parseArt.address ?? ""
		
		let latitude = parseArt.latitude ?? ""
		let longitude = parseArt.longitude ?? ""
		let coordinates = mapCoordinates(latitude: latitude, longitude: longitude)
		art.longitude = NSNumber(value: coordinates.longitude)
		art.latitude = NSNumber(value: coordinates.latitude)
		art.artWebLink = parseArt.artWebLink ?? ""
		
		if let descriptionFile = parseArt.descriptionFile {
			art.descriptionFileName = descriptionFile.name
			art.descriptionFileURL = descriptionFile.url ?? ""
		}

	}
	
}
