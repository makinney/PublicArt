//
//  Fetcher.swift
//  City Art San Francisco
//
//  Created by Michael Kinney on 12/2/14.
//  Copyright (c) 2014 mkinney. All rights reserved.
//

import Foundation
import CoreData
 
class Fetcher {
	
	let moc:NSManagedObjectContext

	init(managedObjectContext moc:NSManagedObjectContext) {
		self.moc = moc
	}
	
	func fetchAppCommon() -> (AppCommon?) {
		var appCommon:AppCommon?
		let fetchRequest = NSFetchRequest()
		fetchRequest.entity = NSEntityDescription.entityForName(ModelEntity.appCommon, inManagedObjectContext:moc)
		
		var error:NSError? = nil
		var fetchedObjects: [AnyObject]?
		do {
			fetchedObjects = try moc.executeFetchRequest(fetchRequest)
		} catch let error1 as NSError {
			error = error1
			fetchedObjects = nil
		}
		if(error == nil) {
			if fetchedObjects?.count > 0 {
				appCommon = fetchedObjects?.last as? AppCommon
			}
		} else {
			DLog(error!.description)
		}
		return appCommon
	}
	
	
	func fetchAllArt() -> [Art] {
		var art = [Art]()
		let fetchRequest = NSFetchRequest()
		fetchRequest.entity = NSEntityDescription.entityForName(ModelEntity.art, inManagedObjectContext:moc)
		var fetchedObjects: [AnyObject]?
		
		do {
			fetchedObjects = try moc.executeFetchRequest(fetchRequest)
			art = fetchedObjects as! [Art]
		} catch let error as NSError {
			print("__FUNCTION__ \(error.description)")
		}
		
		return art
	}
	
	func fetchAllArtWithPhotos() -> [Art] {
		var art = [Art]()
		let fetchRequest = NSFetchRequest()
		fetchRequest.entity = NSEntityDescription.entityForName(ModelEntity.art, inManagedObjectContext:moc)
		fetchRequest.predicate = NSPredicate(format:"%K != %@", "imageFileName", "")

		var error:NSError? = nil
		var fetchedObjects: [AnyObject]?
		do {
			fetchedObjects = try moc.executeFetchRequest(fetchRequest)
		} catch let error1 as NSError {
			error = error1
			fetchedObjects = nil
		}
		if(error == nil) {
			art = fetchedObjects as! [Art]
		} else {
			DLog(error!.description)
		}
		return art
	}
	
	func fetchArt(idArt:String) -> (Art?) {
		var art:Art?
		let fetchRequest = NSFetchRequest()
		fetchRequest.entity = NSEntityDescription.entityForName(ModelEntity.art, inManagedObjectContext:moc)
		fetchRequest.predicate = NSPredicate(format:"%K == %@", "idArt", idArt) // TODO: define
		
		var error:NSError? = nil
		var fetchedObjects: [AnyObject]?
		do {
			fetchedObjects = try moc.executeFetchRequest(fetchRequest)
		} catch let error1 as NSError {
			error = error1
			fetchedObjects = nil
		}
		if(error == nil) {
			if fetchedObjects?.count > 0 {
				art = fetchedObjects?.last as? Art
			}
		} else {
			DLog(error!.description)
		}
		return art
	}
	
	func fetchArtFor(idLocation:String) -> ([Art]?) {
		var art:[Art]?
		let fetchRequest = NSFetchRequest()
		fetchRequest.entity = NSEntityDescription.entityForName(ModelEntity.art, inManagedObjectContext:moc)
		fetchRequest.predicate = NSPredicate(format:"%K == %@", "idLocation", idLocation) // TODO: define
		
		var error:NSError? = nil
		var fetchedObjects: [AnyObject]?
		do {
			fetchedObjects = try moc.executeFetchRequest(fetchRequest)
		} catch let error1 as NSError {
			error = error1
			fetchedObjects = nil
		}
		if(error == nil) {
			if fetchedObjects?.count > 0 {
				art = fetchedObjects as? [Art]
			}
		} else {
			DLog(error!.description)
		}
		return art
	}
	
	func fetchArtWithPhotosForLocation(idLocation: String, sorted: Bool = true) -> ([Art]?) {
		var art:[Art]?
		let fetchRequest = NSFetchRequest()
		fetchRequest.entity = NSEntityDescription.entityForName(ModelEntity.art, inManagedObjectContext:moc)
		if sorted {
			let sortDescriptor = NSSortDescriptor(key:ModelAttributes.artworkTitle, ascending:true)
			fetchRequest.sortDescriptors = [sortDescriptor]
		}
		
		let locationPredicate = NSPredicate(format:"%K == %@", "idLocation", idLocation)
		let thumbPredicate = NSPredicate(format:"%K != %@", "imageFileName", "")
		let predicateArray = [locationPredicate, thumbPredicate]
		let compound = NSCompoundPredicate(andPredicateWithSubpredicates:predicateArray)
		fetchRequest.predicate = compound
		var error:NSError? = nil
		var fetchedObjects: [AnyObject]?
		do {
			fetchedObjects = try moc.executeFetchRequest(fetchRequest)
		} catch let error1 as NSError {
			error = error1
			fetchedObjects = nil
		}
		if(error == nil) {
			if fetchedObjects?.count > 0 {
				art = fetchedObjects as? [Art]
			}
		} else {
			DLog(error!.description)
		}
		return art
	}
	
	func fetchArtist(idArtist:String) -> (Artist?) {
		var artist:Artist?
		let fetchRequest = NSFetchRequest()
		fetchRequest.entity = NSEntityDescription.entityForName(ModelEntity.artist, inManagedObjectContext:moc)
		fetchRequest.predicate = NSPredicate(format:"%K == %@", "idArtist", idArtist)
		
		var error:NSError? = nil
		var fetchedObjects: [AnyObject]?
		do {
			fetchedObjects = try moc.executeFetchRequest(fetchRequest)
		} catch let error1 as NSError {
			error = error1
			fetchedObjects = nil
		}
		if(error == nil) {
			if fetchedObjects?.count > 0 {
				artist = fetchedObjects?.last as? Artist
			}
		} else {
			DLog(error!.description)
		}
		return artist
	}
	
	func fetchAllArtist() -> [Artist] {
		var artists = [Artist]()
		let fetchRequest = NSFetchRequest()
		fetchRequest.entity = NSEntityDescription.entityForName(ModelEntity.artist, inManagedObjectContext:moc)
		
		var error:NSError? = nil
		var fetchedObjects: [AnyObject]?
		do {
			fetchedObjects = try moc.executeFetchRequest(fetchRequest)
		} catch let error1 as NSError {
			error = error1
			fetchedObjects = nil
		}
		if(error == nil) {
			if let fetchedObjects = fetchedObjects {
				if fetchedObjects.count > 0 {
					artists = fetchedObjects as! [Artist]
				}
			}
		} else {
			DLog(error!.description)
		}
		
		return artists
	}
	
	
	func fetchLocation(idLocation:String) -> (Location?) {
		var location:Location?
		let fetchRequest = NSFetchRequest()
		fetchRequest.entity = NSEntityDescription.entityForName(ModelEntity.location, inManagedObjectContext:moc)
		fetchRequest.predicate = NSPredicate(format:"%K == %@", "idLocation", idLocation) // TODO: define
		
		var error:NSError? = nil
		var fetchedObjects: [AnyObject]?
		do {
			fetchedObjects = try moc.executeFetchRequest(fetchRequest)
		} catch let error1 as NSError {
			error = error1
			fetchedObjects = nil
		}
		if(error == nil) {
			if fetchedObjects?.count > 0 {
				location = fetchedObjects?.last as? Location
			}
		} else {
			DLog(error!.description)
		}
		return location
	}
	
	func fetchAllLocations(sorted: Bool = true) -> ([Location]?) {
		var locations:[Location]?
		let fetchRequest = NSFetchRequest()
		fetchRequest.entity = NSEntityDescription.entityForName(ModelEntity.location, inManagedObjectContext:moc)
		if sorted {
			let sortDescriptor = NSSortDescriptor(key:ModelAttributes.locationName, ascending:true)
			fetchRequest.sortDescriptors = [sortDescriptor]
		}		
		var error:NSError? = nil
		var fetchedObjects: [AnyObject]?
		do {
			fetchedObjects = try moc.executeFetchRequest(fetchRequest)
		} catch let error1 as NSError {
			error = error1
			fetchedObjects = nil
		}
		if(error == nil) {
			locations = fetchedObjects as? [Location]
		} else {
			DLog(error!.description)
		}
		return locations
	}
	
	func fetchAllLocationsHavingArtWithPhotos(sorted: Bool = true) -> ([Location]?) {
		var locationsWithArtPhotos: [Location] = []
		if let locations = fetchAllLocations() {
			for location in locations {
				if let _ = fetchArtWithPhotosForLocation(location.idLocation) {
					locationsWithArtPhotos.append(location)
				}
			}
		}
		return locationsWithArtPhotos
	}


	func fetchPhotosFor(idArt:String) -> ([Photo]?) {
		var photos:[Photo]?
		let fetchRequest = NSFetchRequest()
		fetchRequest.entity = NSEntityDescription.entityForName(ModelEntity.photo, inManagedObjectContext:moc)
		fetchRequest.predicate = NSPredicate(format:"%K == %@", "idArt", idArt) // TODO: define
		
		var error:NSError? = nil
		var fetchedObjects: [AnyObject]?
		do {
			fetchedObjects = try moc.executeFetchRequest(fetchRequest)
		} catch let error1 as NSError {
			error = error1
			fetchedObjects = nil
		}
		if(error == nil) {
			photos = fetchedObjects as? [Photo]
		} else {
			DLog(error!.description)
		}
		return photos
	}
	
	func fetchManagedObjWithId(objectId: String, inEntityNamed:String, moc: NSManagedObjectContext) -> NSManagedObject? {
		let fetchRequest = NSFetchRequest()
		fetchRequest.entity = NSEntityDescription.entityForName(inEntityNamed, inManagedObjectContext:moc)
		fetchRequest.predicate = NSPredicate(format:"%K == %@", ModelEntity.objectId, objectId)
		
		let error:NSError? = nil
		let fetchedObjects:[AnyObject] = try! moc.executeFetchRequest(fetchRequest)
		if(error == nil) {
			let managedObject = fetchedObjects.last as? NSManagedObject
			return managedObject
		} else {
			print("\(__FILE__) \(__FUNCTION__) \(error?.description)")
		}
		
		return nil
	}
	

	
	func fetchManagedObjsWithIdsMatching(jsonIds: [String], inEntityNamed:String, moc: NSManagedObjectContext) -> [String]? {
		var objectIds = [String]()
		let fetchRequest = NSFetchRequest()
		fetchRequest.entity = NSEntityDescription.entityForName(inEntityNamed, inManagedObjectContext:moc)
		fetchRequest.predicate = NSPredicate(format:"%K IN %@", ModelEntity.objectId, jsonIds)
		
		let error:NSError? = nil
		let fetchedObjects:[AnyObject] = try! moc.executeFetchRequest(fetchRequest)
		if(error == nil) {
			for obj in fetchedObjects {
				let id = obj.valueForKey(ModelEntity.objectId) as! String!
				objectIds += [id]
			}
		} else {
			DLog(error!.description)
		}
		
		if objectIds.count == 0 {
			return nil
		}
		return objectIds
	}
	

	
}
