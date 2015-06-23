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
		query.whereKey("hasThumbPhoto", equalTo: 1)
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
		var query = PFQuery(className: "photo")
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
	
	class func getAllLocationsSince(date: NSDate, complete:(parseLocation: [ParseLocation]) -> Void) -> Void {
		var query = PFQuery(className: "location")
		//		query.whereKey("updatedAt", greaterThanOrEqualTo: date )
		query.limit = 999 // max per parse
		query.findObjectsInBackgroundWithBlock { (objects:[AnyObject]?, error: NSError?) -> Void in
			if error == nil {
				if let parseLocation: [ParseLocation] = objects as? [ParseLocation] {
					complete(parseLocation: parseLocation)
				} else {
					complete(parseLocation: [ParseLocation]())
				}
			} else {
				println("\(__FILE__) \(__FUNCTION__) \(error?.description)")
				complete(parseLocation: [ParseLocation]())
			}
		}
	}
	

	
	class func getAllArtistSince(date: NSDate, complete:(parseArtist: [ParseArtist]) -> Void) -> Void {
		var query = PFQuery(className: "artist")
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