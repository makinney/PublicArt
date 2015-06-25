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
	
	class func create(parseArtist: ParseArtist, moc: NSManagedObjectContext) -> Artist? {
		if let artist = NSEntityDescription.insertNewObjectForEntityForName(ModelEntity.artist, inManagedObjectContext:moc) as? Artist {
			artist.objectId = parseArtist.objectId!
			artist.createdAt = parseArtist.createdAt!
			artist.updatedAt = parseArtist.updatedAt!

			artist.idArtist = parseArtist.idArtist ?? ""
			artist.name = parseArtist.name ?? ""
			if let webLinkName = parseArtist.webLinkName {
				artist.webLinkName = webLinkName
			}
			if let webLinkURL = parseArtist.webLinkURL {
				artist.webLinkURL = webLinkURL
			}
		
			return artist
		}
		return nil
	}
	
	
	class func update(artist: Artist, parseArtist: ParseArtist) {
		artist.objectId = parseArtist.objectId!
		artist.createdAt = parseArtist.createdAt!
		artist.updatedAt = parseArtist.updatedAt!
		
		artist.idArtist = parseArtist.idArtist ?? ""
		artist.name = parseArtist.name ?? ""
		if let webLinkName = parseArtist.webLinkName {
			artist.webLinkName = webLinkName
		}
		if let webLinkURL = parseArtist.webLinkURL {
			artist.webLinkURL = webLinkURL
		}
	}

}