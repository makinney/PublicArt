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
	
	 init(coreDataStack: CoreDataStack) {
		self.coreDataStack = coreDataStack
		artDataCreator = ArtDataCreator(managedObjectContext: coreDataStack.managedObjectContext!)
		fetcher = Fetcher(managedObjectContext: coreDataStack.managedObjectContext!)
	}
	
	deinit {
	}
	
	
	func refresh(beginningAtDate: NSDate, endingAtDate: NSDate) {
		refreshFromWeb(beginningAtDate, complete: {[weak self] (art, artists, locations, photos, thumbs, locPhotos) -> () in
			self?.updatePhotoToArtBindings(photos)
			self?.updateArtToLocationBindings(art)
			self?.updateArtToArtistBindings(art)
			self?.updateThumbToArtBindings(thumbs)
			self?.updateLocPhotoToLocationBindings(locPhotos)
			if self?.coreDataStack.saveContext() == true {
				ArtRefresh.clientRefreshed(endingAtDate)
			}
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
			var art = [Art]()
			if let crud = self?.artDataCreator.createOrUpdateArt(parseArt) {
				art = crud.created + crud.updated
			}
			complete(art: art)
		}
	}
	
	private func refreshArtistsFromWeb(date: NSDate, complete:(artists: [Artist]) ->()) {
		ParseWebService.getAllArtistSince(date) {[weak self] (parseArtists) -> Void in
			var artists = [Artist]()
			if let crud = self?.artDataCreator.createOrUpdateArtist(parseArtists) {
				artists = crud.created + crud.updated
			}
			complete(artists: artists)
		}
	}
	
	private func refreshPhotosFromWeb(date: NSDate, complete:(photos: [Photo]) ->()) {
		ParseWebService.getAllPhotosSince(date) {[weak self] (parsePhotos) -> Void in
			var photos = [Photo]()
			if let crud = self?.artDataCreator.createOrUpdatePhotos(parsePhotos) {
				photos = crud.created + crud.updated
			}
			PFObject.pinAllInBackground(parsePhotos) // saving the PFFile image reference
			complete(photos: photos)
		}
	}
	
	private func refreshLocationsFromWeb(date: NSDate, complete:(locations: [Location]) ->()) {
		ParseWebService.getAllLocationsSince(date) {[weak self] (parseLocations) -> Void in
			var locations = [Location]()
			if let crud = self?.artDataCreator.createOrUpdateLocations(parseLocations) {
				locations = crud.created + crud.updated
			}
			complete(locations: locations)
		}
	}
	
	private func refreshThumbsFromWeb(date: NSDate, complete:(thumbs: [Thumb]) ->()) {
		ParseWebService.getAllThumbsSince(date) {[weak self] (parseThumbs) -> Void in
			var thumbs = [Thumb]()
			if let crud = self?.artDataCreator.createOrUpdateThumbs(parseThumbs) {
				thumbs = crud.created + crud.updated
			}
			PFObject.pinAllInBackground(parseThumbs) // saving the PFFile image reference
			complete(thumbs: thumbs)
		}
	}
	
	private func refreshLocPhotosFromWeb(date: NSDate, complete:(locPhotos: [LocPhoto]) ->()) {
		ParseWebService.getAllLocPhotosSince(date) {[weak self] (parseLocPhotos) -> Void in
			var locPhotos = [LocPhoto]()
			if let crud = self?.artDataCreator.createOrUpdateLocPhotos(parseLocPhotos) {
				locPhotos = crud.created + crud.updated
			}
			PFObject.pinAllInBackground(parseLocPhotos) // saving the PFFile image reference
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
	
	private func updateArtToArtistBindings(art:[Art]) {
		for art in art {
			if let artist = self.fetcher.fetchArtist(art.idArtist) {
				var artistArtworkSet:NSMutableSet = artist.artwork.mutableCopy() as! NSMutableSet
				artistArtworkSet.addObject(art)
				artist.artwork = artistArtworkSet.copy() as! NSSet
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

