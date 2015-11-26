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
	
	func createOrUpdateAppCommon(parseAppCommon: ParseAppCommon) ->(created: [AppCommon], updated: [AppCommon]) {
		var created = [AppCommon]()
		var updated = [AppCommon]()
		
		if let objectId = parseAppCommon.objectId,
			let appCommon = self.fetcher.fetchManagedObjWithId(objectId, inEntityNamed: ModelEntity.appCommon, moc: moc) as? AppCommon {
				AppCommon.update(appCommon, parseAppCommon: parseAppCommon)
				updated.append(appCommon)
		} else {
			if let appCommon = AppCommon.create(parseAppCommon, moc: moc) {
				created.append(appCommon)
			}
		}
		return (created, updated)
	}

	
	func createOrUpdateArt(parseArt: [ParseArt]) ->(created: [Art], updated: [Art]) {
		var created = [Art]()
		var updated = [Art]()
		
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
		
		for parsePhoto in parsePhoto {
			if let objectId = parsePhoto.objectId,
			   let photo = self.fetcher.fetchManagedObjWithId(objectId, inEntityNamed: ModelEntity.photo, moc: moc) as? Photo {
				Photo.update(photo, parsePhoto: parsePhoto )
					updated.append(photo)
			} else {
				if let photo = Photo.create(parsePhoto, moc: moc) {
					created.append(photo)
				}
			}
		}
		return (created, updated)
	}
	
	
	func createOrUpdateThumbs(parseThumb: [ParseThumb]) ->(created: [Thumb], updated: [Thumb]) {
		var created = [Thumb]()
		var updated = [Thumb]()
		
		for parseThumb in parseThumb {
			if let objectId = parseThumb.objectId,
				let thumb = self.fetcher.fetchManagedObjWithId(objectId, inEntityNamed: ModelEntity.thumb, moc: moc) as? Thumb {
					Thumb.update(thumb, parseThumb: parseThumb )
					updated.append(thumb)
			} else {
				if let thumb = Thumb.create(parseThumb, moc: moc) {
					created.append(thumb)
				}
			}
		}
		return (created, updated)
	}
	
	
	func createOrUpdateLocations(parseLocation: [ParseLocation]) ->(created: [Location], updated: [Location]) {
		var created = [Location]()
		var updated = [Location]()
		
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
	
	func createOrUpdateLocPhotos(parseLocPhoto: [ParseLocPhoto]) ->(created: [LocPhoto], updated: [LocPhoto]) {
		var created = [LocPhoto]()
		var updated = [LocPhoto]()
		
		for parseLocPhoto in parseLocPhoto {
			if let objectId = parseLocPhoto.objectId,
				let locPhoto = self.fetcher.fetchManagedObjWithId(objectId, inEntityNamed: ModelEntity.locPhoto, moc: moc) as? LocPhoto {
					LocPhoto.update(locPhoto, parseLocPhoto: parseLocPhoto )
					updated.append(locPhoto)
			} else {
				if let locPhoto = LocPhoto.create(parseLocPhoto, moc: moc) {
					created.append(locPhoto)
				}
			}
		}
		return (created, updated)
	}
	
	
}