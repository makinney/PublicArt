//
//  ArtDataManager.swift
//  City Art San Francisco
//
//  Created by Michael Kinney on 11/30/14.
//  Copyright (c) 2014 mkinney. All rights reserved.
//
// TODO: Parse - Security - data should be read only..and more...

import Foundation
import CoreData
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
		refreshFromWeb(beginningAtDate, complete: {[weak self] (art, artists, locations, photos, thumbs, locPhotos, appCommon) -> () in
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
	private func refreshFromWeb(beginningDate: NSDate, complete:(art: [Art], artists: [Artist], locations: [Location], photos: [Photo], thumbs: [Thumb], locPhotos: [LocPhoto], appCommon: [AppCommon]) ->()) {
		// get art and create or update
		refreshArtFromWeb(beginningDate, complete: {[weak self] (art) -> () in
			self!.refreshPhotosFromWeb(beginningDate, complete: { (photos) -> () in
				self!.refreshLocationsFromWeb(beginningDate, complete: { (locations) -> () in
					self!.refreshArtistsFromWeb(beginningDate, complete: { (artists) -> () in
						self!.refreshThumbsFromWeb(beginningDate, complete: { (thumbs) -> () in
							self!.refreshLocPhotosFromWeb(beginningDate, complete: { (locPhotos) -> () in
								self!.refreshAppCommonFromWeb(beginningDate, complete: { (appCommon) -> () in
									complete(art: art, artists: artists, locations: locations, photos: photos, thumbs: thumbs, locPhotos: locPhotos, appCommon: appCommon)
								})
							})
						})
					})
				})
			})
		})
	}
	
	// MARK: get latest from web --- refactor to other class ?
	
	private func refreshAppCommonFromWeb(date: NSDate, complete:(appCommon: [AppCommon]) ->()) {
		ParseWebService.getAppCommonSince(date) {[weak self] (parseAppCommon) -> Void in
			var appCommon = [AppCommon]()
			if let parseAppCommon = parseAppCommon,
				let crud = self?.artDataCreator.createOrUpdateAppCommon(parseAppCommon) {
				appCommon = crud.created + crud.updated
			}
			complete(appCommon: appCommon)
		}
	}
	
	private func refreshArtFromWeb(date: NSDate, complete:(art: [Art]) ->()) {
		ParseWebService.getAllArtSince(date) {[weak self] (parseArt) -> Void in
			var art = [Art]()
			if let parseArt = parseArt,
				let crud = self?.artDataCreator.createOrUpdateArt(parseArt) {
					art = crud.created + crud.updated
			}
			complete(art: art)
		}
	}
	
	private func refreshArtistsFromWeb(date: NSDate, complete:(artists: [Artist]) ->()) {
		ParseWebService.getAllArtistSince(date) {[weak self] (parseArtists) -> Void in
			var artists = [Artist]()
			if let parseArtists = parseArtists,
				let crud = self?.artDataCreator.createOrUpdateArtist(parseArtists) {
					artists = crud.created + crud.updated
			}
			complete(artists: artists)
		}
	}
	
	private func refreshPhotosFromWeb(date: NSDate, complete:(photos: [Photo]) ->()) {
		ParseWebService.getAllPhotosSince(date) {[weak self] (parsePhotos) -> Void in
			var photos = [Photo]()
			if let parsePhotos = parsePhotos,
				let crud = self?.artDataCreator.createOrUpdatePhotos(parsePhotos) {
					photos = crud.created + crud.updated
			}
			PFObject.pinAllInBackground(parsePhotos) // saving the PFFile image reference
			complete(photos: photos)
		}
	}
	
	private func refreshLocationsFromWeb(date: NSDate, complete:(locations: [Location]) ->()) {
		ParseWebService.getAllLocationsSince(date) {[weak self] (parseLocations) -> Void in
			var locations = [Location]()
			if let parseLocations = parseLocations,
				let crud = self?.artDataCreator.createOrUpdateLocations(parseLocations) {
					locations = crud.created + crud.updated
			}
			complete(locations: locations)
		}
	}
	
	private func refreshThumbsFromWeb(date: NSDate, complete:(thumbs: [Thumb]) ->()) {
		ParseWebService.getAllThumbsSince(date) {[weak self] (parseThumbs) -> Void in
			var thumbs = [Thumb]()
			if let parseThumbs = parseThumbs,
				let crud = self?.artDataCreator.createOrUpdateThumbs(parseThumbs) {
					thumbs = crud.created + crud.updated
			}
			PFObject.pinAllInBackground(parseThumbs) // saving the PFFile image reference
			complete(thumbs: thumbs)
		}
	}
	
	private func refreshLocPhotosFromWeb(date: NSDate, complete:(locPhotos: [LocPhoto]) ->()) {
		ParseWebService.getAllLocPhotosSince(date) {[weak self] (parseLocPhotos) -> Void in
			var locPhotos = [LocPhoto]()
			if let parseLocPhotos = parseLocPhotos,
				let crud = self?.artDataCreator.createOrUpdateLocPhotos(parseLocPhotos) {
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
				let artSet:NSMutableSet = location.artwork.mutableCopy() as! NSMutableSet
				artSet.addObject(art)
				location.artwork = artSet.copy() as! NSSet
			}
		}
	}
	
	private func updateArtToArtistBindings(art:[Art]) {
		for art in art {
			if let artist = self.fetcher.fetchArtist(art.idArtist) {
				let artistArtworkSet:NSMutableSet = artist.artwork.mutableCopy() as! NSMutableSet
				artistArtworkSet.addObject(art)
				artist.artwork = artistArtworkSet.copy() as! NSSet
			}
		}
	}

	private func updatePhotoToArtBindings(photos:[Photo]) {
		for photo in photos {
			if let art = self.fetcher.fetchArt(photo.idArt) {
				let relationSet: NSMutableSet = art.photos.mutableCopy() as! NSMutableSet
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
//			var timeInterval: NSTimeInterval = 1 // : define
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

