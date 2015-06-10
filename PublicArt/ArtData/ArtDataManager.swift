//
//  ArtDataManager.swift
//  City Art San Francisco
//
//  Created by Michael Kinney on 11/30/14.
//  Copyright (c) 2014 mkinney. All rights reserved.
//
// TODO: Parse - Security - data should be read only..and more...
// TODO: test that this binds new photos
// TODO: test that it works if art has been deleted, without and with photo concurrently added.

import Foundation
import CoreData
import UIKit // TODO: remove

class ArtDataManager : NSObject {

	let artDataCreator: ArtDataCreator
	let coreDataStack: CoreDataStack
	let fetcher: Fetcher
	let importer: Importer
	let moc: NSManagedObjectContext
	var newPhotos = [Photo]()
	
	class var sharedInstance: ArtDataManager {
		struct Singleton {
			static let instance = ArtDataManager()
		}
		return Singleton.instance
	}
	
	override init() {
		coreDataStack = CoreDataStack.sharedInstance // TODO not do this, pass in instead, 
		moc = coreDataStack.managedObjectContext!
		artDataCreator = ArtDataCreator(managedObjectContext: moc)
		fetcher = Fetcher(managedObjectContext: moc)
		importer = Importer(webService: WebService(), coreDataStack:coreDataStack)
		super.init()
	}
	
	deinit {
	}
	
	// MARK: refresh
	
	func refresh() {
		WebService().updateAvailable { (available) -> () in
			if(available) {
				self.startRefresh()
			}
		}
	}
	
	private func startRefresh() {
		refreshArt( { () -> () in // TODO weakself here and everywhere
			self.refreshPhotos({ (success) -> () in
					self.refreshLocations({ (success) -> () in
						self.coreDataStack.saveContext()
						// TODO: update refreshed timestamps
						self.checkForRequiredNotifications()
					})

			})
		})
	}
	
	private func refreshArt(complete:() ->()) {
		importer.getArt{ (jsonArt) -> () in
			if let jsonArt = jsonArt {
				if let newArt  = self.artDataCreator.createArt(jsonArt) {
					self.updateArtRelationships(newArt)
					println("\(__FUNCTION__) created  \(newArt.count) pieces of art")
				}
			}
			complete()
		}
	}
	
	private func refreshLocations(complete:(success:Bool) ->()) {
		importer.getLocations { (jsonLocations) -> () in
			if let jsonLocation = jsonLocations {
				if let newLocations = self.artDataCreator.createLocations(jsonLocation) {
//	this was just location photos				self.updateLocationRelationships(newLocations)
					println("\(__FUNCTION__) created \(newLocations.count) locations")
				} 
				complete(success: true)
			} else {
				complete(success: true)
			}
		}
	}

	private func refreshPhotos(complete:(success:Bool) ->()) {
		importer.getPhotoInfo { (jsonPhotoInfo) -> () in
			if let jsonPhotoInfo = jsonPhotoInfo {
				if let photos = self.artDataCreator.createPhotos(jsonPhotoInfo) {
					self.updatePhotoRelationships(photos)
					println("\(__FUNCTION__) created \(photos.count) photos ")
					if photos.count > 0 {
						self.newPhotos = photos // TODO: test this, creating new array or passing by reference ?  I suspect creating new since it's an array
					}
				}
				complete(success: true)
			} else {
				complete(success: true)
			}
		}
	}
	
	// MARK: Update
	
	private func updateArtRelationships(art:[Art]) {
		for art in art {
			if let photos = self.fetcher.fetchPhotosFor(art.idArt) {
				for photo in photos {
					bind(art,photo:photo)
				}
			}
			if let location = self.fetcher.fetchLocation(art.idLocation) { // TODO: very slow ?
				bind(location, art:[art])
			}
		}
	}
	

//	func printLocationArtCount(location: [Location]) {
//		for location in location {
//			println("location name and art count \(location.name) and count \(location.art.count) \n ")
//		}
//	}
	
	private func updatePhotoRelationships(photos:[Photo]) {
		for photo in photos {
			if let art = self.fetcher.fetchArt(photo.idArt) {
				bind(art, photo:photo)
			}
		}
	}
	

	// MARK: bind
	
	private func bind(art:Art, photo: Photo) -> Bool {
		var bound = false
		if art.idArt == photo.idArt {
			var relationSet: NSMutableSet = art.photos.mutableCopy() as! NSMutableSet
			relationSet.addObject(photo)
			
			art.photos = relationSet.copy() as! NSSet
			bound = true
//			println("\(__FUNCTION__) bound art \(art.photos) to photo info \(photo.idArt)")
		}
		return bound
	}
	
	private func bind(location: Location, art: [Art]) {
		var artSet:NSMutableSet = location.art.mutableCopy() as! NSMutableSet
		for art in art {
			if art.idLocation == location.idLocation {
				art.locationName = location.name
				artSet.addObject(art)
//				println("\(__FUNCTION__) bound art \(art.title) to location \(location.name)")
			}
		}
		location.art = artSet.copy() as! NSSet
	}


	// MARK: notifications
	
	private func checkForRequiredNotifications() {
		if newPhotos.count > 0 {
			var timeInterval: NSTimeInterval = 1 // TODO: define
			var timer = NSTimer.scheduledTimerWithTimeInterval(timeInterval, target:self, selector: "postNewPhotosNotification", userInfo:nil, repeats:false)
		}
	}
	
	func postNewPhotosNotification() {
		if newPhotos.count > 0 {
			var dict = ["photos": newPhotos]
			NSNotificationCenter.defaultCenter().postNotificationName(ArtAppNotifications.PhotosDownloaded.rawValue,
																		object: self,
																	  userInfo: dict)
		}
	}
}
