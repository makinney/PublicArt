//
//  ThumbImage.swift
//  PublicArt
//
//  Created by Michael Kinney on 12/15/15.
//  Copyright © 2015 makinney. All rights reserved.
//

import UIKit

class ThumbImages {
	let MaxImages = 100
	static let sharedInstance = ThumbImages()
	
	private init(){
		
	}
	
	func getImage(art: Art, complete:(image: UIImage?, imageFileName: String?)->()) {
		if let thumb = art.thumb {
			let fileName = thumb.imageFileName
			if let image = getImage(fileName) {
				complete(image: image, imageFileName: fileName)
			} else {
				ImageDownload.downloadThumb(art, complete: { [weak self] (data, imageFileName) -> () in
					if let data = data,
						let image = UIImage(data: data) {
							self?.addImage(image, name: thumb.imageFileName)
							complete(image: image, imageFileName:  thumb.imageFileName)
					} else {
						complete(image: nil, imageFileName: thumb.imageFileName)
					}
				})
			}
		} else {
			//let noThumbImage = UIImage(named: ImageFileName.NoThumbImage)
			complete(image: nil, imageFileName: nil)
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