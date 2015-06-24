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

	
	
	class func getAllArtSince(date: NSDate, complete:(parseArt: [ParseArt]) -> Void) -> Void {
		var query = PFQuery(className: ParseArt.parseClassName())
		query.whereKey("hasThumb", equalTo: NSNumber(bool: true))
//		query.whereKey("updatedAt", greaterThanOrEqualTo: date )
		query.limit = 999 // max per parse
		query.findObjectsInBackgroundWithBlock { (objects:[AnyObject]?, error: NSError?) -> Void in
			if error == nil {
				if let parseArt: [ParseArt] = objects as? [ParseArt] {
					complete(parseArt: parseArt)
				} else {
					complete(parseArt: [ParseArt]())
				}
			} else {
				println("\(__FILE__) \(__FUNCTION__) \(error?.description)")
				complete(parseArt: [ParseArt]())
			}
		}
	}
	
	class func getAllPhotosSince(date: NSDate, complete:(parsePhotos: [ParsePhoto]) -> Void) -> Void {
		var query = PFQuery(className: ParsePhoto.parseClassName())
		//		query.whereKey("updatedAt", greaterThanOrEqualTo: date )
		query.limit = 999 // max per parse
		query.findObjectsInBackgroundWithBlock { (objects:[AnyObject]?, error: NSError?) -> Void in
			if error == nil {
				if let parsePhotos: [ParsePhoto] = objects as? [ParsePhoto] {
					complete(parsePhotos: parsePhotos)
				} else {
					complete(parsePhotos: [ParsePhoto]())
				}
			} else {
				println("\(__FILE__) \(__FUNCTION__) \(error?.description)")
				complete(parsePhotos: [ParsePhoto]())
			}
		}
	}
	
	class func getAllThumbsSince(date: NSDate, complete:(parseThumbs: [ParseThumb]) -> Void) -> Void {
		var query = PFQuery(className: ParseThumb.parseClassName())
		//		query.whereKey("updatedAt", greaterThanOrEqualTo: date )
		query.limit = 999 // max per parse
		query.findObjectsInBackgroundWithBlock { (objects:[AnyObject]?, error: NSError?) -> Void in
			if error == nil {
				if let parseThumbs: [ParseThumb] = objects as? [ParseThumb] {
					complete(parseThumbs: parseThumbs)
				} else {
					complete(parseThumbs: [ParseThumb]())
				}
			} else {
				println("\(__FILE__) \(__FUNCTION__) \(error?.description)")
				complete(parseThumbs: [ParseThumb]())
			}
		}
	}
	
	
	class func getAllLocationsSince(date: NSDate, complete:(parseLocations: [ParseLocation]) -> Void) -> Void {
		var query = PFQuery(className: ParseLocation.parseClassName())
		//		query.whereKey("updatedAt", greaterThanOrEqualTo: date )
		query.limit = 999 // max per parse
		query.findObjectsInBackgroundWithBlock { (objects:[AnyObject]?, error: NSError?) -> Void in
			if error == nil {
				if let parseLocation: [ParseLocation] = objects as? [ParseLocation] {
					complete(parseLocations: parseLocation)
				} else {
					complete(parseLocations: [ParseLocation]())
				}
			} else {
				println("\(__FILE__) \(__FUNCTION__) \(error?.description)")
				complete(parseLocations: [ParseLocation]())
			}
		}
	}
	

	
	class func getAllArtistSince(date: NSDate, complete:(parseArtist: [ParseArtist]) -> Void) -> Void {
		var query = PFQuery(className: ParseArtist.parseClassName())
		//		query.whereKey("updatedAt", greaterThanOrEqualTo: date )

		query.limit = 999 // max per parse
		query.findObjectsInBackgroundWithBlock { (objects:[AnyObject]?, error: NSError?) -> Void in
			if error == nil {
				if let parseArtist: [ParseArtist] = objects as? [ParseArtist] {
					complete(parseArtist: parseArtist)
				} else {
					complete(parseArtist: [ParseArtist]())
				}
			} else {
				println("\(__FILE__) \(__FUNCTION__) \(error?.description)")
				complete(parseArtist: [ParseArtist]())
			}
		}
	}

	
}