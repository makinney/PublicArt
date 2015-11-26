//
//  ImageDownload.swift
//  PublicArt
//
//  Created by Michael Kinney on 6/24/15.
//  Copyright (c) 2015 makinney. All rights reserved.
//

import Foundation
import UIKit
import Parse

class ImageDownload {
	
	class func downloadThumb(art: Art, complete:(data: NSData?, imageFileName: String)->()) {
		if let thumb = art.thumb {
			let query = PFQuery(className: ParseThumb.parseClassName())
			query.fromLocalDatastore()
			query.getObjectInBackgroundWithId(thumb.objectId, block: { (pfObject, error) -> Void in
				if let pfObject = pfObject {
					let file = pfObject["imageFile"] as! PFFile
					file.getDataInBackgroundWithBlock({ (data, error) -> Void in
						if error == nil {
							complete(data:data, imageFileName: thumb.imageFileName)
						} else {
							print("\(__FILE__) \(__FUNCTION__) error \(error?.description)")
							complete(data:nil, imageFileName: thumb.imageFileName)
							
						}
					})
				}
			})
		} else {
			complete(data: nil, imageFileName: String())
		}
	}

	class func downloadPhoto(photo: Photo, complete:(data: NSData?, imageFileName: String)->()) {
			let query = PFQuery(className: ParsePhoto.parseClassName())
			query.fromLocalDatastore()
			query.getObjectInBackgroundWithId(photo.objectId, block: { (pfObject, error) -> Void in
				if let pfObject = pfObject {
					let file = pfObject["imageFile"] as! PFFile
					file.getDataInBackgroundWithBlock({ (data, error) -> Void in
						if error == nil {
							complete(data:data, imageFileName: photo.imageFileName)
						} else {
							print("\(__FILE__) \(__FUNCTION__) error \(error?.description)")
							complete(data:nil, imageFileName: photo.imageFileName)
							
						}
					})
				}
			})
	
	}
	

//	class func downloadLocPhoto(location: Location, complete:(data: NSData?, imageFileName: String)->()) {
//		if let locPhoto = location.photo {
//			locPhoto.imageFile?.getDataInBackgroundWithBlock({ (data, error) -> Void in
//				if error == nil {
//					complete(data:data, imageFileName: locPhoto.imageFileName)
//				} else {
//					println("\(__FILE__) \(__FUNCTION__) error \(error?.description)")
//					complete(data:nil, imageFileName: locPhoto.imageFileName)
//				}
//			})
//		} else {
//			complete(data: nil, imageFileName: String())
//		}
//	}
	
}