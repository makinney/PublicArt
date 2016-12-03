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
	
	fileprivate init(){
		
	}
	
	func getImage(_ art: Art, complete:@escaping (_ image: UIImage?, _ imageFileName: String?)->()) {
		if let thumb = art.thumb {
			let fileName = thumb.imageFileName
			if let image = getImage(fileName) {
				complete(image, fileName)
			} else {
				ImageDownload.downloadThumb(art, complete: { [weak self] (data, imageFileName) -> () in
					if let data = data,
						let image = UIImage(data: data) {
							self?.addImage(image, name: thumb.imageFileName)
							complete(image, thumb.imageFileName)
					} else {
						complete(nil, thumb.imageFileName)
					}
				})
			}
		} else {
			//let noThumbImage = UIImage(named: ImageFileName.NoThumbImage)
			complete(nil, nil)
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
