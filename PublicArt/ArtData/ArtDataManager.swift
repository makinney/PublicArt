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
	var updatedArt: [Art]?
	var updatedArtist: [Artist]?
	var updatedLocations: [Location]?
	var updatedPhotos: [Photo]?
	
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
		
			getLatestFromWeb(lastUpdate, complete: {[weak self] (art, artist, location, photo) -> () in
			
			println("\(__FILE__) \(__FUNCTION__) got art count is \(art.count)")
			
	//		println("\(__FILE__) \(__FUNCTION__) got artist count is \(artist.count)")
	//		println("\(__FILE__) \(__FUNCTION__) got location count is \(location.count)")
			println("\(__FILE__) \(__FUNCTION__) got photos count is \(photo.count) \n")
			
				for piece in art {
					println("before bind art name \(piece.title) and photo count \(piece.photos.count)")
					
					var thumbPhoto = getThumbNailPhotoInfoFor(piece)
					println("thumb file name is \(thumbPhoto?.thumbFileName) \n")

				}
			
			// bind everything up
			self!.updatePhotoArtRelationships(photo) // TODO .. test for nil self ?
			self!.updateArtLocationRelationships(art)
			
				for piece in art {
					println("after bind art name \(piece.title) and photo count \(piece.photos.count)")
					var thumbPhoto = getThumbNailPhotoInfoFor(piece)
					println("thumb file name is \(thumbPhoto?.thumbFileName) \n")

				}
				

			// save it
			self!.coreDataStack.saveContext()
			
				for piece in art {
					println("after save art name \(piece.title) and photo count \(piece.photos.count)")
					var thumbPhoto = getThumbNailPhotoInfoFor(piece)
					println("thumb file name is \(thumbPhoto?.thumbFileName) \n")
				}
		
			self!.checkForRequiredNotifications()
	
		
		})
	}
	
	
	private func getLatestFromWeb(beginningDate: NSDate, complete:(art: [Art], artist: [Artist], location: [Location], photo: [Photo] ) ->()) {
		// get art and create or update
		latestArtFromWeb(beginningDate, complete: {[weak self] (art) -> () in
			self!.updatedArt = art
			self!.latestPhotosFromWeb(beginningDate, complete: { (photo) -> () in
				self!.updatedPhotos = photo
				self!.latestLocationsFromWeb(beginningDate, complete: { (location) -> () in
					self!.updatedLocations = location
					self!.latestArtistsFromWeb(beginningDate, complete: { (artist) -> () in
						self!.updatedArtist = artist
						complete(art: art, artist: artist, location: location, photo: photo)
					})
				})
			})
		})
		
	}
	
	
	private func latestArtFromWeb(date: NSDate, complete:(art: [Art]) ->()) {
		ParseWebService.getAllArtSince(date) {[weak self] (parseArt) -> Void in
			var crud = self!.artDataCreator.createOrUpdateArt(parseArt)
			var art = crud.created + crud.updated
			complete(art: art)
		}
	}
	
	private func latestArtistsFromWeb(date: NSDate, complete:(artist: [Artist]) ->()) {
		ParseWebService.getAllArtistSince(date) {[weak self] (parseArtist) -> Void in
			var crud = self!.artDataCreator.createOrUpdateArtist(parseArtist)
			var artist = crud.created + crud.updated
			complete(artist: artist)
		}
	}

	
	private func latestPhotosFromWeb(date: NSDate, complete:(photo: [Photo]) ->()) {
		ParseWebService.getAllPhotosSince(date) {[weak self] (parsePhoto) -> Void in
			var crud = self!.artDataCreator.createOrUpdatePhotos(parsePhoto)
			var photo = crud.created + crud.updated
			complete(photo: photo)
		}
	}
	
	private func latestLocationsFromWeb(date: NSDate, complete:(location: [Location]) ->()) {
		ParseWebService.getAllLocationsSince(date) {[weak self] (parseLocation) -> Void in
			var crud = self!.artDataCreator.createOrUpdateLocations(parseLocation)
			var location = crud.created + crud.updated
			complete(location: location)
		}
	}

	
	private func updateArtLocationRelationships(art:[Art]) {
		for art in art {
			if let location = self.fetcher.fetchLocation(art.idLocation) {
				var artSet:NSMutableSet = location.artwork.mutableCopy() as! NSMutableSet
				artSet.addObject(art)
				location.artwork = artSet.copy() as! NSSet
			}
		}
	}

	private func updatePhotoArtRelationships(photos:[Photo]) {
		for photo in photos {
			if let art = self.fetcher.fetchArt(photo.idArt) {
		//		println("art hasthumbnail \(art.hasThumbPhoto)")
				var relationSet: NSMutableSet = art.photos.mutableCopy() as! NSMutableSet
				relationSet.addObject(photo)
				art.photos = relationSet.copy() as! NSSet
			
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

/*


for piece in art {
if piece.descriptionFile != "" {
// get pffile, if not in local store, then parse should get if from server
let query = PFQuery(className: "descriptionFile")
//			query.fromLocalDatastore()
query.getObjectInBackgroundWithId(piece.descriptionFile, block: { (pfObject, error) -> Void in
var pffile: PFFile = pfObject?.valueForKey("file") as! PFFile
var data = pffile.getData()
self.testImage = UIImage(data: data!)
var view = UIImageView(frame:CGRect(x:0,y:0,width:50, height:50))
view.image = self.testImage!

})
}
}
*/
