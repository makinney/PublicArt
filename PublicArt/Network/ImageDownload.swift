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
			thumb.imageFile?.getDataInBackgroundWithBlock({ (data, error) -> Void in
				if error == nil {
					complete(data:data, imageFileName: thumb.imageFileName)
				} else {
					println("\(__FILE__) \(__FUNCTION__) error \(error?.description)")
					complete(data:nil, imageFileName: thumb.imageFileName)

				}
			})
		} else {
			complete(data: nil, imageFileName: String())
		}
	}
	
	class func downloadLocPhoto(location: Location, complete:(data: NSData?, imageFileName: String)->()) {
		if let locPhoto = location.photo {
			locPhoto.imageFile?.getDataInBackgroundWithBlock({ (data, error) -> Void in
				if error == nil {
					complete(data:data, imageFileName: locPhoto.imageFileName)
				} else {
					println("\(__FILE__) \(__FUNCTION__) error \(error?.description)")
					complete(data:nil, imageFileName: locPhoto.imageFileName)
				}
			})
		} else {
			complete(data: nil, imageFileName: String())
		}
	}
	
}