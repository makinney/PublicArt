//
//  Fetcher.swift
//  City Art San Francisco
//
//  Created by Michael Kinney on 12/2/14.
//  Copyright (c) 2014 mkinney. All rights reserved.
//

// Hello there Xcode Source Control

import Foundation
import CoreData
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}

 
class Fetcher {
	
	let moc:NSManagedObjectContext

	init(managedObjectContext moc:NSManagedObjectContext) {
		self.moc = moc
	}
	
	func fetchAppCommon() -> (AppCommon?) {
		var appCommon:AppCommon?
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
		fetchRequest.entity = NSEntityDescription.entity(forEntityName: ModelEntity.appCommon, in:moc)
		
		var error:NSError? = nil
		var fetchedObjects: [AnyObject]?
		do {
			fetchedObjects = try moc.fetch(fetchRequest)
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
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
		fetchRequest.entity = NSEntityDescription.entity(forEntityName: ModelEntity.art, in:moc)
		var fetchedObjects: [AnyObject]?
		
		do {
			fetchedObjects = try moc.fetch(fetchRequest)
			art = fetchedObjects as! [Art]
		} catch let error as NSError {
			print("__FUNCTION__ \(error.description)")
		}
		
		return art
	}
	
	func fetchAllArtWithPhotos() -> [Art] {
		var art = [Art]()
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
		fetchRequest.entity = NSEntityDescription.entity(forEntityName: ModelEntity.art, in:moc)
		fetchRequest.predicate = NSPredicate(format:"%K != %@", "imageFileName", "")

		var error:NSError? = nil
		var fetchedObjects: [AnyObject]?
		do {
			fetchedObjects = try moc.fetch(fetchRequest)
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
	
	func fetchArt(_ idArt:String) -> (Art?) {
		var art:Art?
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
		fetchRequest.entity = NSEntityDescription.entity(forEntityName: ModelEntity.art, in:moc)
		fetchRequest.predicate = NSPredicate(format:"%K == %@", "idArt", idArt) // TODO: define
		
		var error:NSError? = nil
		var fetchedObjects: [AnyObject]?
		do {
			fetchedObjects = try moc.fetch(fetchRequest)
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
	
	func fetchArtFor(_ idLocation:String) -> ([Art]?) {
		var art:[Art]?
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
		fetchRequest.entity = NSEntityDescription.entity(forEntityName: ModelEntity.art, in:moc)
		fetchRequest.predicate = NSPredicate(format:"%K == %@", "idLocation", idLocation) // TODO: define
		
		var error:NSError? = nil
		var fetchedObjects: [AnyObject]?
		do {
			fetchedObjects = try moc.fetch(fetchRequest)
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
	
	func fetchArtWithPhotosForLocation(_ idLocation: String, sorted: Bool = true) -> ([Art]?) {
		var art:[Art]?
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
		fetchRequest.entity = NSEntityDescription.entity(forEntityName: ModelEntity.art, in:moc)
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
			fetchedObjects = try moc.fetch(fetchRequest)
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
	
	func fetchArtist(_ idArtist:String) -> (Artist?) {
		var artist:Artist?
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
		fetchRequest.entity = NSEntityDescription.entity(forEntityName: ModelEntity.artist, in:moc)
		fetchRequest.predicate = NSPredicate(format:"%K == %@", "idArtist", idArtist)
		
		var error:NSError? = nil
		var fetchedObjects: [AnyObject]?
		do {
			fetchedObjects = try moc.fetch(fetchRequest)
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
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
		fetchRequest.entity = NSEntityDescription.entity(forEntityName: ModelEntity.artist, in:moc)
		
		var error:NSError? = nil
		var fetchedObjects: [AnyObject]?
		do {
			fetchedObjects = try moc.fetch(fetchRequest)
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
	
	
	func fetchLocation(_ idLocation:String) -> (Location?) {
		var location:Location?
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
		fetchRequest.entity = NSEntityDescription.entity(forEntityName: ModelEntity.location, in:moc)
		fetchRequest.predicate = NSPredicate(format:"%K == %@", "idLocation", idLocation) // TODO: define
		
		var error:NSError? = nil
		var fetchedObjects: [AnyObject]?
		do {
			fetchedObjects = try moc.fetch(fetchRequest)
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
	
	func fetchAllLocations(_ sorted: Bool = true) -> ([Location]?) {
		var locations:[Location]?
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
		fetchRequest.entity = NSEntityDescription.entity(forEntityName: ModelEntity.location, in:moc)
		if sorted {
			let sortDescriptor = NSSortDescriptor(key:ModelAttributes.locationName, ascending:true)
			fetchRequest.sortDescriptors = [sortDescriptor]
		}		
		var error:NSError? = nil
		var fetchedObjects: [AnyObject]?
		do {
			fetchedObjects = try moc.fetch(fetchRequest)
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
	
	func fetchAllLocationsHavingArtWithPhotos(_ sorted: Bool = true) -> ([Location]?) {
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


	func fetchPhotosFor(_ idArt:String) -> ([Photo]?) {
		var photos:[Photo]?
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
		fetchRequest.entity = NSEntityDescription.entity(forEntityName: ModelEntity.photo, in:moc)
		fetchRequest.predicate = NSPredicate(format:"%K == %@", "idArt", idArt) // TODO: define
		
		var error:NSError? = nil
		var fetchedObjects: [AnyObject]?
		do {
			fetchedObjects = try moc.fetch(fetchRequest)
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
	
	func fetchManagedObjWithId(_ objectId: String, inEntityNamed:String, moc: NSManagedObjectContext) -> NSManagedObject? {
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
		fetchRequest.entity = NSEntityDescription.entity(forEntityName: inEntityNamed, in:moc)
		fetchRequest.predicate = NSPredicate(format:"%K == %@", ModelEntity.objectId, objectId)
		
		let error:NSError? = nil
		let fetchedObjects:[AnyObject] = try! moc.fetch(fetchRequest)
		if(error == nil) {
			let managedObject = fetchedObjects.last as? NSManagedObject
			return managedObject
		} else {
			print("\(#file) \(#function) \(error?.description)")
		}
		
		return nil
	}
	

	
	func fetchManagedObjsWithIdsMatching(_ jsonIds: [String], inEntityNamed:String, moc: NSManagedObjectContext) -> [String]? {
		var objectIds = [String]()
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
		fetchRequest.entity = NSEntityDescription.entity(forEntityName: inEntityNamed, in:moc)
		fetchRequest.predicate = NSPredicate(format:"%K IN %@", ModelEntity.objectId, jsonIds)
		
		let error: NSError? = nil
		let fetchedObjects:[AnyObject] = try! moc.fetch(fetchRequest)
		if(error == nil) {
			for obj in fetchedObjects {
                if let id = obj.value(forKey: ModelEntity.objectId) as? String {
                    objectIds.append(id)
                }
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
