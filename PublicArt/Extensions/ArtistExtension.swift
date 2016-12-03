//
//  ArtistExtension.swift
//  PublicArt
//
//  Created by Michael Kinney on 6/17/15.
//  Copyright (c) 2015 makinney. All rights reserved.
//

import Foundation
import CoreData

extension Artist {
	
	class func create(_ parseArtist: ParseArtist, moc: NSManagedObjectContext) -> Artist? {
		if let artist = NSEntityDescription.insertNewObject(forEntityName: ModelEntity.artist, into:moc) as? Artist {
			artist.objectId = parseArtist.objectId!
			artist.createdAt = parseArtist.createdAt!
			artist.updatedAt = parseArtist.updatedAt!
			artist.idArtist = parseArtist.idArtist ?? ""
			artist.firstName = parseArtist.firstName ?? ""
			artist.lastName = parseArtist.lastName ?? ""
			artist.webLink = parseArtist.webLink ?? ""
			return artist
		}
		return nil
	}
	
	
	class func update(_ artist: Artist, parseArtist: ParseArtist) {
		artist.objectId = parseArtist.objectId!
		artist.createdAt = parseArtist.createdAt!
		artist.updatedAt = parseArtist.updatedAt!
		artist.idArtist = parseArtist.idArtist ?? ""
		artist.firstName = parseArtist.firstName ?? ""
		artist.lastName = parseArtist.lastName ?? ""
		artist.webLink = parseArtist.webLink ?? ""
	}

}
