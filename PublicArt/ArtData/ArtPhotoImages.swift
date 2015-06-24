//
//  ArtPhotoImages.swift
//  ArtCity
//
//  Created by Michael Kinney on 1/27/15.
//  Copyright (c) 2015 mkinney. All rights reserved.
//

import Foundation
import ImageIO
import UIKit

// TODO: fix this hack
func getThumbNailPhotoInfoFor(art: Art) -> Photo? {
	var thumbNailPhotoInfo: Photo?

	var photos: [Photo] = art.photos.allObjects as! [Photo]
	for photo in photos {
		if count(photo.thumbFileName) > 3 { // 3 is extension size, TODO hack since CD does not use Optionals
	//		println("found thumbfile name \(photo.thumbFileName)")
			thumbNailPhotoInfo = photo
			break
		}
	}
	
	return thumbNailPhotoInfo
}

class ArtPhotoImages {

	let cache: ArtPhotoCache
	let thumbNailCache: ArtPhotoCache

	let fileManager: ArtFileManager

	class var sharedInstance: ArtPhotoImages {
		struct Singleton {
			static let instance = ArtPhotoImages()
		}
		return Singleton.instance
	}
	
	private init() {
		cache = ArtPhotoCache()
		thumbNailCache = ArtPhotoCache()
		fileManager = ArtFileManager.sharedInstance
	}
	
	func defaultImage() -> UIImage? {
		return UIImage(named: "noPhotosImage.png")
	}
	
	func getImage(fileName: String, completion:(image: UIImage?) ->()) {
		if fileName.isEmpty {
			return completion(image: defaultImage())
		}
		if let image = cache.getImageFor(fileName) {
			completion(image: image)
		} else {
			if let image = UIImage(named: fileName) {
				cache.addImage(image, name: fileName)
				completion(image: image)
			} else {
				var nsData = fileManager.readFile(fileName)
				if nsData != nil  {
					var image = UIImage(data:nsData!)
					if image != nil  {
						cache.addImage(image!, name: fileName)
						completion(image: image)
					} else {
						completion(image: defaultImage())
					}
				} else {
					completion(image: defaultImage())
				}
			}
		}
	}
	
	func getImage(fileName: String) -> UIImage? {
		if fileName.isEmpty {
			return defaultImage()
		}
		if let image = cache.getImageFor(fileName) {
			return image
		}
		if let image = UIImage(named: fileName) {
			cache.addImage(image, name: fileName)
			return image
		}
		var nsData = fileManager.readFile(fileName)
		if nsData != nil  {
			var image = UIImage(data:nsData!)
			if image != nil  {
				cache.addImage(image!, name: fileName)
				return image
			}
		}
		return defaultImage()
	}
	
	
	func getThumbNail(fileName: String, size: CGSize, completion:(image: UIImage?) ->()) {
		var thumbNailImage: UIImage?
		if let image = getImage(fileName) {
			thumbNailImage = imageResizeTo(size,image)
			completion(image: thumbNailImage)
		} else {
			completion(image: nil)
		}
	}
	
	func getThumbNail(fileName: String, size: CGSize) -> UIImage? {
		var thumbNailImage: UIImage?
		if let image = getImage(fileName) {
			let scale = size.width / image.size.width
			let width = scale * image.size.width
			let height = scale * image.size.height
			let adjSize = CGSize(width: width, height: height)
			thumbNailImage = imageResizeTo(adjSize,image)

			return thumbNailImage
		}
		return thumbNailImage
	}
	
	// this uses special cache
	func getThumbNailWith(fileName: String, size: CGSize) -> (image: UIImage, fileName: String)? {
//		if let thumbNailImage = thumbNailCache.getImageFor(fileName) {
//			return (thumbNailImage, fileName)
//		}
		if let image = getImage(fileName) {
			let scale = size.width / image.size.width
			let width = scale * image.size.width
			let height = scale * image.size.height
			let adjSize = CGSize(width: width, height: height)
	//		var thumbImage = imageResizeTo(adjSize,image)
			var thumbImage = ImageProcess.fillSize(adjSize, image:image)
			thumbNailCache.addImage(thumbImage, name: fileName)
			return (thumbImage, fileName)
		}
		return nil
	}

	
	
	
	
	
	
	
	
	
	
}