//
//  Create.swift
//  City Art San Francisco
//
//  Created by Michael Kinney on 12/30/14.
//  Copyright (c) 2014 mkinney. All rights reserved.
//

import Foundation
import CoreData

class ArtDataCreator {

	let moc:NSManagedObjectContext
	let fetcher:Fetcher
	
	init(managedObjectContext: NSManagedObjectContext) {
		moc = managedObjectContext
		fetcher = Fetcher(managedObjectContext: moc)
	}
	
	// MARK: create
	
	func createOrUpdateArt(parseArt: [ParseArt]) ->(created: [Art], updated: [Art]) {
		var created = [Art]()
		var updated = [Art]()
		var managedObject: NSManagedObject?
		
		for parseArt in parseArt {
			if let objectId = parseArt.objectId,
				let art = self.fetcher.fetchManagedObjWithId(objectId, inEntityNamed: ModelEntity.art, moc: moc) as? Art {
					Art.update(art, parseArt: parseArt)
					updated.append(art)
			} else {
				if let art = Art.create(parseArt, moc: moc) {
					created.append(art)
				}
			}
		}
		return (created, updated)
	}
	
	func createOrUpdateArtist(parseArtist: [ParseArtist]) ->(created: [Artist], updated: [Artist]) {
		var created = [Artist]()
		var updated = [Artist]()
		var managedObject: NSManagedObject?
		
		for parseArtist in parseArtist {
			if let objectId = parseArtist.objectId,
				let artist = self.fetcher.fetchManagedObjWithId(objectId, inEntityNamed: ModelEntity.artist, moc: moc) as? Artist {
					Artist.update(artist, parseArtist: parseArtist)
					updated.append(artist)
			} else {
				if let artist = Artist.create(parseArtist, moc: moc) {
					created.append(artist)
				}
			}
		}
		return (created, updated)
	}
	
	
	func createOrUpdatePhotos(parsePhoto: [ParsePhoto]) ->(created: [Photo], updated: [Photo]) {
		var created = [Photo]()
		var updated = [Photo]()
		var managedObject: NSManagedObject?
		
		for parsePhoto in parsePhoto {
			if let objectId = parsePhoto.objectId,
				let photo = self.fetcher.fetchManagedObjWithId(objectId, inEntityNamed: ModelEntity.photo, moc: moc) as? Photo {
					Photo.update(photo, parsePhoto: parsePhoto)
					updated.append(photo)
			} else {
				if let photo = Photo.create(parsePhoto, moc: moc) {
					created.append(photo)
				}
			}
		}
		return (created, updated)
	}
	
	func createOrUpdateLocations(parseLocation: [ParseLocation]) ->(created: [Location], updated: [Location]) {
		var created = [Location]()
		var updated = [Location]()
		var managedObject: NSManagedObject?
		
		for parseLocation in parseLocation {
			if let objectId = parseLocation.objectId,
				let location = self.fetcher.fetchManagedObjWithId(objectId, inEntityNamed: ModelEntity.location, moc: moc) as? Location {
					Location.update(location, parseLocation: parseLocation)
					updated.append(location)
			} else {
				if let location = Location.create(parseLocation, moc: moc) {
					created.append(location)
				}
			}
		}
		return (created, updated)
	}
	
}