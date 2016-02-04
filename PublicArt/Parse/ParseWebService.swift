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

	class func getAppCommonSince(date: NSDate, complete:(parseAppCommon: ParseAppCommon?) -> Void) -> Void {
		let query = PFQuery(className: ParseAppCommon.parseClassName())
		query.whereKey("updatedAt", greaterThanOrEqualTo: date )
		query.limit = 1 //
		
		query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
			if error == nil {
				if let parseAppCommon: ParseAppCommon = objects?.last as? ParseAppCommon {
					complete(parseAppCommon: parseAppCommon)
				} else {
					complete(parseAppCommon: nil)
				}
			} else {
				print("\(__FILE__) \(__FUNCTION__) \(error?.description)")
				complete(parseAppCommon: ParseAppCommon())
			}
		}
	}
	
	
	class func getAllArtSince(date: NSDate, complete:(parseArt: [ParseArt]?) -> Void) -> Void {
		let query = PFQuery(className: ParseArt.parseClassName())
		query.whereKey("locationVerified", equalTo: NSNumber(bool: true))
		query.whereKey("updatedAt", greaterThanOrEqualTo: date )
		query.limit = 999 // max per parse
		query.findObjectsInBackgroundWithBlock { (objects:[PFObject]?, error: NSError?) -> Void in
			if error == nil {
				if let parseArt: [ParseArt] = objects as? [ParseArt] {
					complete(parseArt: parseArt)
				} else {
					complete(parseArt: nil)
				}
			} else {
				print("\(__FILE__) \(__FUNCTION__) \(error?.description)")
				complete(parseArt: [ParseArt]())
			}
		}
	}
	
	class func getAllPhotosSince(date: NSDate, complete:(parsePhotos: [ParsePhoto]?) -> Void) -> Void {
		let query = PFQuery(className: ParsePhoto.parseClassName())
		query.whereKey("updatedAt", greaterThanOrEqualTo: date )
		query.limit = 999 // max per parse
		query.findObjectsInBackgroundWithBlock { (objects:[PFObject]?, error: NSError?) -> Void in
			if error == nil {
				if let parsePhotos: [ParsePhoto] = objects as? [ParsePhoto] {
					complete(parsePhotos: parsePhotos)
				} else {
					complete(parsePhotos: nil)
				}
			} else {
				print("\(__FILE__) \(__FUNCTION__) \(error?.description)")
				complete(parsePhotos: [ParsePhoto]())
			}
		}
	}
	
	class func getAllThumbsSince(date: NSDate, complete:(parseThumbs: [ParseThumb]?) -> Void) -> Void {
		let query = PFQuery(className: ParseThumb.parseClassName())
		query.whereKey("updatedAt", greaterThanOrEqualTo: date )
		query.limit = 999 // max per parse
		query.findObjectsInBackgroundWithBlock { (objects:[PFObject]?, error: NSError?) -> Void in
			if error == nil {
				if let parseThumbs: [ParseThumb] = objects as? [ParseThumb] {
					complete(parseThumbs: parseThumbs)
				} else {
					complete(parseThumbs: nil)
				}
			} else {
				print("\(__FILE__) \(__FUNCTION__) \(error?.description)")
				complete(parseThumbs: [ParseThumb]())
			}
		}
	}
	
	
	class func getAllLocationsSince(date: NSDate, complete:(parseLocations: [ParseLocation]?) -> Void) -> Void {
		let query = PFQuery(className: ParseLocation.parseClassName())
		query.whereKey("updatedAt", greaterThanOrEqualTo: date )
		query.limit = 999 // max per parse
		query.findObjectsInBackgroundWithBlock { (objects:[PFObject]?, error: NSError?) -> Void in
			if error == nil {
				if let parseLocation: [ParseLocation] = objects as? [ParseLocation] {
					complete(parseLocations: parseLocation)
				} else {
					complete(parseLocations: nil)
				}
			} else {
				print("\(__FILE__) \(__FUNCTION__) \(error?.description)")
				complete(parseLocations: [ParseLocation]())
			}
		}
	}
	
	class func getAllLocPhotosSince(date: NSDate, complete:(parseLocPhotos: [ParseLocPhoto]?) -> Void) -> Void {
		let query = PFQuery(className: ParseLocPhoto.parseClassName())
		query.whereKey("updatedAt", greaterThanOrEqualTo: date )
		query.limit = 999 // max per parse
		query.findObjectsInBackgroundWithBlock { (objects:[PFObject]?, error: NSError?) -> Void in
			if error == nil {
				if let parseLocPhotos: [ParseLocPhoto] = objects as? [ParseLocPhoto] {
					complete(parseLocPhotos: parseLocPhotos)
				} else {
					complete(parseLocPhotos: nil)
				}
			} else {
				print("\(__FILE__) \(__FUNCTION__) \(error?.description)")
				complete(parseLocPhotos: [ParseLocPhoto]())
			}
		}
	}
	
	
	class func getAllArtistSince(date: NSDate, complete:(parseArtist: [ParseArtist]?) -> Void) -> Void {
		let query = PFQuery(className: ParseArtist.parseClassName())
		query.whereKey("updatedAt", greaterThanOrEqualTo: date )
		query.limit = 999 // max per parse
		query.findObjectsInBackgroundWithBlock { (objects:[PFObject]?, error: NSError?) -> Void in
			if error == nil {
				if let parseArtist: [ParseArtist] = objects as? [ParseArtist] {
					complete(parseArtist: parseArtist)
				} else {
					complete(parseArtist: nil)
				}
			} else {
				print("\(__FILE__) \(__FUNCTION__) \(error?.description)")
				complete(parseArtist: [ParseArtist]())
			}
		}
	}
	
	class func getPublicArtRefresh(complete:(parseRefresh: [ParseRefresh]?) -> Void) -> Void {
		let query = PFQuery(className: ParseRefresh.parseClassName())
		query.findObjectsInBackgroundWithBlock { (objects:[PFObject]?, error: NSError?) -> Void in
			if error == nil {
				if let parseRefresh: [ParseRefresh] = objects as? [ParseRefresh] {
					complete(parseRefresh: parseRefresh)
				} else {
					complete(parseRefresh: nil)
				}
			} else {
				print("\(__FILE__) \(__FUNCTION__) \(error?.description)")
				complete(parseRefresh: nil)
			}
		}
	}
	


	
}