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
	
	class func downloadThumb(_ art: Art, complete:@escaping (_ data: Data?, _ imageFileName: String)->()) {
		if let thumb = art.thumb, art.hasThumb == true {
			let query = PFQuery(className: ParseThumb.parseClassName())
			query.fromLocalDatastore()
			query.getObjectInBackground(withId: thumb.objectId, block: { (pfObject, error) -> Void in
				if let pfObject = pfObject {
					let file = pfObject["imageFile"] as! PFFile
					file.getDataInBackground(block: { (data, error) -> Void in
						if error == nil {
							complete(data, thumb.imageFileName)
						} else {
							print("\(#file) \(#function) error \(error?.localizedDescription)")
							complete(nil, thumb.imageFileName)
							
						}
					})
				}
			})
		} else {
			complete(nil, String())
		}
	}

	class func downloadPhoto(_ photo: Photo, complete:@escaping (_ data: Data?, _ imageFileName: String)->()) {
			let query = PFQuery(className: ParsePhoto.parseClassName())
			query.fromLocalDatastore()
			query.getObjectInBackground(withId: photo.objectId, block: { (pfObject, error) -> Void in
				if let pfObject = pfObject {
					let file = pfObject["imageFile"] as! PFFile
					file.getDataInBackground(block: { (data, error) -> Void in
						if error == nil {
							complete(data, photo.imageFileName)
						} else {
							print("\(#file) \(#function) error \(error?.localizedDescription)")
							complete(nil, photo.imageFileName)
							
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
