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

	init(){
		
	}
	
	func getImage(photo: Photo, complete:(image: UIImage?, imageFileName: String?)->()) {
			if let image = getImage(photo.imageFileName) {
				complete(image: image, imageFileName: photo.imageFileName)
			} else {
				ImageDownload.downloadPhoto(photo, complete: { [weak self] (data, imageFileName) -> () in
					if let data = data,
						let image = UIImage(data: data) {
							self?.addImage(image, name: imageFileName)
							complete(image: image, imageFileName:  imageFileName)
					} else {
						complete(image: nil, imageFileName: imageFileName)
					}
				})
			}
	}
	
	private
	
	var cache: [String : UIImage] = Dictionary()
	
	func addImage(image: UIImage, name: String) {
		if cache.count >= MaxImages {
			removeAnImage()
		}
		cache[name] = image
	}
	
	func getImage(name: String) -> UIImage? {
		return cache[name]
	}
	
	private func removeAnImage() {
		if cache.count > 0 {
			cache.removeAtIndex(cache.startIndex)
		}
	}
}