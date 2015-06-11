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
	var newArt: [Art]?
	var newLocations: [Location]?
	var newPhotos: [Photo]?
	
//	
//	class var sharedInstance: ArtDataManager {
//		struct Singleton {
//			static let instance = ArtDataManager()
//		}
//		return Singleton.instance
//	}

	
	// TODO: this does not have to be a singleton
	
	 init(coreDataStack: CoreDataStack) {
		self.coreDataStack = coreDataStack
		artDataCreator = ArtDataCreator(managedObjectContext: coreDataStack.managedObjectContext!)
		fetcher = Fetcher(managedObjectContext: coreDataStack.managedObjectContext!)
		importer = Importer(webService: WebService(), managedObjectContext: coreDataStack.managedObjectContext!)
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
		getNewArt({[weak self] () -> () in
			self!.getNewPhotos({() -> () in
				self!.getNewLocations({() -> () in
					
					// 	self.updateArtRelationships(newArt)
					// 	self.updatePhotoRelationships(photos)

					self!.coreDataStack.saveContext()
					// TODO: update refreshed timestamps
					self!.checkForRequiredNotifications()
				})

			})
		})
	}
	
	private func getNewArt(complete:() ->()) {
		importer.getArt{[weak self] (jsonArt) -> ()  in
			if let jsonArt = jsonArt {
				self!.newArt  = self!.artDataCreator.createArt(jsonArt)
			}
			complete()
		}
	}
	
	private func getNewLocations(complete:() ->()) {
		importer.getLocations {[weak self]  (jsonLocations) -> () in
			if let jsonLocation = jsonLocations {
				self!.newLocations = self!.artDataCreator.createLocations(jsonLocation)
				complete()
			} else {
				complete()
			}
		}
	}

	private func getNewPhotos(complete:() ->()) {
		importer.getPhotoInfo { [weak self] (jsonPhotoInfo) -> () in
			if let jsonPhotoInfo = jsonPhotoInfo {
				self!.newPhotos = self!.artDataCreator.createPhotos(jsonPhotoInfo)
				complete()
			} else {
				complete()
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
		if let newPhotos = newPhotos where newPhotos.count > 0 {
			var timeInterval: NSTimeInterval = 1 // TODO: define
			var timer = NSTimer.scheduledTimerWithTimeInterval(timeInterval, target:self, selector: "postNewPhotosNotification", userInfo:nil, repeats:false)
		}
	}
	
	func postNewPhotosNotification() {
		if let newPhotos = newPhotos where newPhotos.count > 0 {
			var dict = ["photos": newPhotos]
			NSNotificationCenter.defaultCenter().postNotificationName(ArtAppNotifications.PhotosDownloaded.rawValue,
																		object: self,
																	  userInfo: dict)
		}
	}
}
