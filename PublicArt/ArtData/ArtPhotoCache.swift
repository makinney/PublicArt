//
//  ArtPhotoCache.swift
//  City Art San Francisco
//
//  Created by Michael Kinney on 1/13/15.
//  Copyright (c) 2015 mkinney. All rights reserved.
//

import Foundation
import UIKit

class ArtPhotoCache {
	
	let MaxImages = 50 // TODO: better if this was a size
	
	var cache: [String: UIImage] = Dictionary()
	
	init() {
	}
	
	func addImage(image: UIImage, name: String) {
		if cache.count >= MaxImages {
			removeAnImage()
		}
		cache[name] = image
	}
	
	func getImageFor(name: String) -> UIImage? {
		return cache[name]
	}
	
	func removeImageNamed(name: String) {
		cache[name] = nil
	}
	
	func removeAllImages() {
		cache.removeAll(keepCapacity: false)
	}
	
	private func removeAnImage() {
		if cache.count > 0 {
			cache.removeAtIndex(cache.startIndex)
		}
	}
	
}
