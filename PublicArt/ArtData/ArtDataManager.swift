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
import Parse

class ArtDataManager : NSObject {

	let artDataCreator: ArtDataCreator
	let coreDataStack: CoreDataStack
	let fetcher: Fetcher
	let importer: Importer
	
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
		var lastUpdate = NSDate() // TODO has to come from parse server
		
			refreshFromWeb(lastUpdate, complete: {[weak self] (art, artists, locations, photos, thumbs, locPhotos) -> () in
			
	//		println("\(__FILE__) \(__FUNCTION__) got art count is \(art.count)")
	//			println("\(__FILE__) \(__FUNCTION__) got thumb count is \(thumbs.count)")

	//		println("\(__FILE__) \(__FUNCTION__) got artist count is \(artist.count)")
	//		println("\(__FILE__) \(__FUNCTION__) got location count is \(location.count)")
	//		println("\(__FILE__) \(__FUNCTION__) got photos count is \(photos.count) \n")
			
	
			// bind everything up
			self!.updatePhotoToArtBindings(photos) // TODO .. test for nil self ?
			self!.updateArtToLocationBindings(art)
			self!.updateThumbToArtBindings(thumbs)
			self!.updateLocPhotoToLocationBindings(locPhotos)

			// save it
			self!.coreDataStack.saveContext()
			
//			self!.checkForRequiredNotifications()
	
		
		})
	}
	
	// TODO: needs error handling !!!
	//
	private func refreshFromWeb(beginningDate: NSDate, complete:(art: [Art], artists: [Artist], locations: [Location], photos: [Photo], thumbs: [Thumb], locPhotos: [LocPhoto]) ->()) {
		// get art and create or update
		refreshArtFromWeb(beginningDate, complete: {[weak self] (art) -> () in
			self!.refreshPhotosFromWeb(beginningDate, complete: { (photos) -> () in
				self!.refreshLocationsFromWeb(beginningDate, complete: { (locations) -> () in
					self!.refreshArtistsFromWeb(beginningDate, complete: { (artists) -> () in
						self!.refreshThumbsFromWeb(beginningDate, complete: { (thumbs) -> () in
							self!.refreshLocPhotosFromWeb(beginningDate, complete: { (locPhotos) -> () in
								complete(art: art, artists: artists, locations: locations, photos: photos, thumbs: thumbs, locPhotos: locPhotos)
							})
						})
					})
				})
			})
		})
	}
	
	// MARK: get latest from web --- refactor to other class ?
	
	private func refreshArtFromWeb(date: NSDate, complete:(art: [Art]) ->()) {
		ParseWebService.getAllArtSince(date) {[weak self] (parseArt) -> Void in
			var crud = self!.artDataCreator.createOrUpdateArt(parseArt)
			var art = crud.created + crud.updated
			complete(art: art)
		}
	}
	
	private func refreshArtistsFromWeb(date: NSDate, complete:(artists: [Artist]) ->()) {
		ParseWebService.getAllArtistSince(date) {[weak self] (parseArtists) -> Void in
			var crud = self!.artDataCreator.createOrUpdateArtist(parseArtists)
			var artists = crud.created + crud.updated
			complete(artists: artists)
		}
	}

	
	private func refreshPhotosFromWeb(date: NSDate, complete:(photos: [Photo]) ->()) {
		ParseWebService.getAllPhotosSince(date) {[weak self] (parsePhotos) -> Void in
			var crud = self!.artDataCreator.createOrUpdatePhotos(parsePhotos)
			var photos = crud.created + crud.updated
			complete(photos: photos)
		}
	}
	
	private func refreshLocationsFromWeb(date: NSDate, complete:(locations: [Location]) ->()) {
		ParseWebService.getAllLocationsSince(date) {[weak self] (parseLocations) -> Void in
			var crud = self!.artDataCreator.createOrUpdateLocations(parseLocations)
			var locations = crud.created + crud.updated
			complete(locations: locations)
		}
	}
	
	private func refreshThumbsFromWeb(date: NSDate, complete:(thumbs: [Thumb]) ->()) {
		ParseWebService.getAllThumbsSince(date) {[weak self] (parseThumbs) -> Void in
			var crud = self!.artDataCreator.createOrUpdateThumbs(parseThumbs)
			var thumbs = crud.created + crud.updated
			complete(thumbs: thumbs)
		}
	}
	
	private func refreshLocPhotosFromWeb(date: NSDate, complete:(locPhotos: [LocPhoto]) ->()) {
		ParseWebService.getAllLocPhotosSince(date) {[weak self] (parseLocPhotos) -> Void in
			var crud = self!.artDataCreator.createOrUpdateLocPhotos(parseLocPhotos)
			var locPhotos = crud.created + crud.updated
			complete(locPhotos: locPhotos)
		}
	}
	
	// MARK: Update bindings
	
	private func updateArtToLocationBindings(art:[Art]) {
		for art in art {
			if let location = self.fetcher.fetchLocation(art.idLocation) {
				var artSet:NSMutableSet = location.artwork.mutableCopy() as! NSMutableSet
				artSet.addObject(art)
				location.artwork = artSet.copy() as! NSSet
			}
		}
	}

	private func updatePhotoToArtBindings(photos:[Photo]) {
		for photo in photos {
			if let art = self.fetcher.fetchArt(photo.idArt) {
				var relationSet: NSMutableSet = art.photos.mutableCopy() as! NSMutableSet
				relationSet.addObject(photo)
				art.photos = relationSet.copy() as! NSSet
			
			}
		}
	}
	
	private func updateThumbToArtBindings(thumbs:[Thumb]) {
		for thumb in thumbs {
			if let art = self.fetcher.fetchArt(thumb.idArt) {
				art.thumb = thumb
			}
		}
	}
	
	private func updateLocPhotoToLocationBindings(locPhotos:[LocPhoto]) {
		for locPhoto in locPhotos {
			if let location = self.fetcher.fetchLocation(locPhoto.idLocation) {
				location.photo = locPhoto
			}
		}
	}
	
	
	// MARK: notifications
	
	private func checkForRequiredNotifications() {
//		if let newPhotos = newPhotos where newPhotos.count > 0 {
//			var timeInterval: NSTimeInterval = 1 // TODO: define
//			var timer = NSTimer.scheduledTimerWithTimeInterval(timeInterval, target:self, selector: "postNewPhotosNotification", userInfo:nil, repeats:false)
//		}
	}
	
	func postNewPhotosNotification() {
//		if let newPhotos = newPhotos where newPhotos.count > 0 {
//			var dict = ["photos": newPhotos]
//			NSNotificationCenter.defaultCenter().postNotificationName(ArtAppNotifications.PhotosDownloaded.rawValue,
//																		object: self,
//																	  userInfo: dict)
//		}
	}
}

