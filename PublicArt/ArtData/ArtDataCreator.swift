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
	
	func createArt(jsonArt: [JSON]) ->([Art]?) {
		var newArt:[Art] = []
		var jsonIds:[String] = getUniqueIds(jsonArt)
		if let managedObjects = self.fetcher.fetchManagedObjsWithIdsMatching(jsonIds, inEntityNamed: ModelEntity.art, moc: moc) {
			if let idsWithoutObjects = findIdsIn(jsonIds, notIn: managedObjects) {
				for index in 0..<jsonArt.count {
					if let jsonId = jsonArt[index][ModelEntity.objectId].string {
						if contains(idsWithoutObjects, jsonId) {
							if let art = Art.fromJSON(jsonArt[index], moc: moc) {
								newArt += [art]
							}
						}
					}
				}
			}
		} else {
			for index in 0..<jsonArt.count {
				if let art = Art.fromJSON(jsonArt[index], moc: moc) {
					newArt += [art]
				}
			}
		}
		
		if newArt.count > 0 {
			return newArt
		} else {
			return nil
		}
	}
	
	func createLocations(jsonLocations: [JSON]) ->([Location]?) {
		var newLocations:[Location] = []
		var jsonIds:[String] = getUniqueIds(jsonLocations)
		if let managedObjects = self.fetcher.fetchManagedObjsWithIdsMatching(jsonIds, inEntityNamed: ModelEntity.location, moc: moc) {
			if let idsWithoutObjects = findIdsIn(jsonIds, notIn: managedObjects) {
				for index in 0..<jsonLocations.count {
					if let jsonId = jsonLocations[index][ModelEntity.objectId].string {
						if contains(idsWithoutObjects, jsonId) {
							if let location = Location.fromJSON(jsonLocations[index], moc: moc) {
								newLocations += [location]
							}
						}
					}
				}
			}
		} else {
			for index in 0..<jsonLocations.count {
				if let location = Location.fromJSON(jsonLocations[index], moc: moc) {
					newLocations += [location]
				}
			}
		}
		
		if newLocations.count > 0 {
			return newLocations
		} else {
			return nil
		}
	}
	
	func createPhotos(jsonPhotoInfo: [JSON]) ->([Photo]?)  {
		var newPhotos:[Photo] = []
		var jsonIds = getUniqueIds(jsonPhotoInfo)
		if let managedObjects = self.fetcher.fetchManagedObjsWithIdsMatching(jsonIds, inEntityNamed: ModelEntity.photo, moc: moc) {
			if let idsWithoutObjects = findIdsIn(jsonIds, notIn: managedObjects) {
				for index in 0..<jsonPhotoInfo.count {
					if let jsonId = jsonPhotoInfo[index][ModelEntity.objectId].string {
						if contains(idsWithoutObjects, jsonId) {
							if let photo =  Photo.fromJSON(jsonPhotoInfo[index], moc: moc) {
								newPhotos += [photo]
							}
						}
					}
				}
			}
		} else {
			for index in 0..<jsonPhotoInfo.count {
				if let photo =  Photo.fromJSON(jsonPhotoInfo[index], moc: moc) {
					newPhotos += [photo]
				}
			}
		}
		
		if newPhotos.count > 0 {
			return newPhotos
		} else {
			return nil
		}
	}
	

	// MARK: utility
	
	private func findIdsIn(jsonIds: [String], notIn: [String]) -> [String]? {
		var needObjects:[String] = []
		var sortedJsonIds = jsonIds.sorted(ascending)
		let sortedBagOfIds = notIn.sorted(ascending)
		
		for (index, value) in enumerate(sortedBagOfIds) {
			while value != sortedJsonIds[index] && index < sortedJsonIds.count {
				needObjects += [sortedJsonIds.removeAtIndex(index)]
			}
		}
		if needObjects.count == 0 {
			return nil
		}
		return needObjects
	}
	
	private func getUniqueIds(json: [JSON]) ->[String] {
		var objectIds:[String] = []
		for index in 0..<json.count {
			if let id = json[index][ModelEntity.objectId].string {
				objectIds += [id]
			}
		}
		return objectIds
	}
	

	
}