//
//  PhotoImages.swift
//  PublicArt
//
//  Created by Michael Kinney on 12/15/15.
//  Copyright © 2015 makinney. All rights reserved.
//

import UIKit

class PhotoImages {
	let MaxImages = 30
	static let sharedInstance = PhotoImages()
	fileprivate init(){
		
	}
	
	func getImage(_ photo: Photo, complete:@escaping (_ image: UIImage?, _ imageFileName: String?)->()) {
			if let image = getImage(photo.imageFileName) {
				complete(image, photo.imageFileName)
			} else {
				ImageDownload.downloadPhoto(photo, complete: { [weak self] (data, imageFileName) -> () in
					if let data = data,
						let image = UIImage(data: data) {
							self?.addImage(image, name: imageFileName)
							complete(image, imageFileName)
					} else {
						complete(nil, imageFileName)
					}
				})
			}
	}
	
	fileprivate
	
	var cache: [String : UIImage] = Dictionary()
	
	func addImage(_ image: UIImage, name: String) {
		if cache.count >= MaxImages {
			removeAnImage()
		}
		cache[name] = image
	}
	
	func getImage(_ name: String) -> UIImage? {
		return cache[name]
	}
	
	fileprivate func removeAnImage() {
		if cache.count > 0 {
			cache.remove(at: cache.startIndex)
		}
	}
}
