//
//  ParseWebService.swift
//  PublicArt
//
//  Created by Michael Kinney on 6/16/15.
//  Copyright (c) 2015 makinney. All rights reserved.
//

import Foundation
import Parse

class ParseWebService {

	class func getAppCommonSince(_ date: Date, complete:@escaping (_ parseAppCommon: ParseAppCommon?) -> Void) -> Void {
		let query = PFQuery(className: ParseAppCommon.parseClassName())
		query.whereKey("updatedAt", greaterThanOrEqualTo: date )
		query.limit = 1 //
		
		query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) -> Void in
			if error == nil {
				if let parseAppCommon: ParseAppCommon = objects?.last as? ParseAppCommon {
					complete(parseAppCommon)
				} else {
					complete(nil)
				}
			} else {
				print("\(#file) \(#function) \(error?.localizedDescription)")
				complete(ParseAppCommon())
			}
		}
	}
	
	
	class func getAllArtSince(_ date: Date, complete:@escaping (_ parseArt: [ParseArt]?) -> Void) -> Void {
		let query = PFQuery(className: ParseArt.parseClassName())
		query.whereKey("locationVerified", equalTo: NSNumber(value: true as Bool))
		query.whereKey("updatedAt", greaterThanOrEqualTo: date )
		query.limit = 999 // max per parse
		query.findObjectsInBackground { (objects:[PFObject]?, error: Error?) -> Void in
			if error == nil {
				if let parseArt: [ParseArt] = objects as? [ParseArt] {
					complete(parseArt)
				} else {
					complete(nil)
				}
			} else {
				print("\(#file) \(#function) \(error?.localizedDescription)")
				complete([ParseArt]())
			}
		}
	}
	
	class func getAllPhotosSince(_ date: Date, complete:@escaping (_ parsePhotos: [ParsePhoto]?) -> Void) -> Void {
		let query = PFQuery(className: ParsePhoto.parseClassName())
		query.whereKey("updatedAt", greaterThanOrEqualTo: date )
		query.limit = 999 // max per parse
		query.findObjectsInBackground { (objects:[PFObject]?, error: Error?) -> Void in
			if error == nil {
				if let parsePhotos: [ParsePhoto] = objects as? [ParsePhoto] {
					complete(parsePhotos)
				} else {
					complete(nil)
				}
			} else {
				print("\(#file) \(#function) \(error?.localizedDescription)")
				complete([ParsePhoto]())
			}
		}
	}
	
	class func getAllThumbsSince(_ date: Date, complete:@escaping (_ parseThumbs: [ParseThumb]?) -> Void) -> Void {
		let query = PFQuery(className: ParseThumb.parseClassName())
		query.whereKey("updatedAt", greaterThanOrEqualTo: date )
		query.limit = 999 // max per parse
		query.findObjectsInBackground { (objects:[PFObject]?, error: Error?) -> Void in
			if error == nil {
				if let parseThumbs: [ParseThumb] = objects as? [ParseThumb] {
					complete(parseThumbs)
				} else {
					complete(nil)
				}
			} else {
				print("\(#file) \(#function) \(error?.localizedDescription)")
				complete([ParseThumb]())
			}
		}
	}
	
	
	class func getAllLocationsSince(_ date: Date, complete:@escaping (_ parseLocations: [ParseLocation]?) -> Void) -> Void {
		let query = PFQuery(className: ParseLocation.parseClassName())
		query.whereKey("updatedAt", greaterThanOrEqualTo: date )
		query.limit = 999 // max per parse
		query.findObjectsInBackground { (objects:[PFObject]?, error: Error?) -> Void in
			if error == nil {
				if let parseLocation: [ParseLocation] = objects as? [ParseLocation] {
					complete(parseLocation)
				} else {
					complete(nil)
				}
			} else {
				print("\(#file) \(#function) \(error?.localizedDescription)")
				complete([ParseLocation]())
			}
		}
	}
	
	class func getAllLocPhotosSince(_ date: Date, complete:@escaping (_ parseLocPhotos: [ParseLocPhoto]?) -> Void) -> Void {
		let query = PFQuery(className: ParseLocPhoto.parseClassName())
		query.whereKey("updatedAt", greaterThanOrEqualTo: date )
		query.limit = 999 // max per parse
		query.findObjectsInBackground { (objects:[PFObject]?, error: Error?) -> Void in
			if error == nil {
				if let parseLocPhotos: [ParseLocPhoto] = objects as? [ParseLocPhoto] {
					complete(parseLocPhotos)
				} else {
					complete(nil)
				}
			} else {
				print("\(#file) \(#function) \(error?.localizedDescription)")
				complete([ParseLocPhoto]())
			}
		}
	}
	
	
	class func getAllArtistSince(_ date: Date, complete:@escaping (_ parseArtist: [ParseArtist]?) -> Void) -> Void {
        let query = PFQuery(className: ParseArtist.parseClassName())
//		query.whereKey("updatedAt", greaterThanOrEqualTo: date )
        query.includeKey("user")
		query.limit = 999 // max per parse
        query.findObjectsInBackground { (objects:[PFObject]?, error) -> Void in
			if error == nil {
				if let parseArtist = objects as? [ParseArtist] {
					complete(parseArtist)
				} else {
					complete(nil)
				}
			} else {
				print("\(#file) \(#function) \(error?.localizedDescription)")
				complete([ParseArtist]())
			}
		}
	}
	
	class func getPublicArtRefresh(_ complete:@escaping (_ parseRefresh: [ParseRefresh]?) -> Void) -> Void {
		let query = PFQuery(className: ParseRefresh.parseClassName())
		query.findObjectsInBackground { (objects:[PFObject]?, error: Error?) -> Void in
			if error == nil {
				if let parseRefresh: [ParseRefresh] = objects as? [ParseRefresh] {
					complete(parseRefresh)
				} else {
					complete(nil)
				}
			} else {
				print("\(#file) \(#function) \(error?.localizedDescription)")
				complete(nil)
			}
		}
	}
}
