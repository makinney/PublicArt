//
//  PhotoExtension.swift
//  ArtCity
//
//  Created by Michael Kinney on 1/21/15.
//  Copyright (c) 2015 mkinney. All rights reserved.
//

import Foundation
import CoreData

extension Photo {
	
	class func create(parsePhoto: ParsePhoto, moc: NSManagedObjectContext) -> Photo? {
		if let photo = NSEntityDescription.insertNewObjectForEntityForName(ModelEntity.photo, inManagedObjectContext:moc) as? Photo {
			photo.createdAt = parsePhoto.createdAt!
			photo.objectId = parsePhoto.objectId!
			photo.updatedAt = parsePhoto.updatedAt!
			photo.idArt = parsePhoto.idArt ?? ""
			photo.imageAspectRatio = parsePhoto.imageAspectRatio
			photo.thumbAspectRatio = parsePhoto.thumbAspectRatio

			if let imageFile = parsePhoto.imageFile {
				photo.imageFileName = imageFile.name
				photo.imageFileURL = imageFile.url ?? ""
			}
	
			if let imageFile = parsePhoto.thumbFile {
				photo.thumbFileName = imageFile.name
				photo.thumbFileURL = imageFile.url ?? ""
			}
			
			return photo
		}
		return nil
	}
	
	
	class func update(photo: Photo, parsePhoto: ParsePhoto) {
			photo.createdAt = parsePhoto.createdAt!
			photo.objectId = parsePhoto.objectId!
			photo.updatedAt = parsePhoto.updatedAt!
			photo.idArt = parsePhoto.idArt ?? ""
			photo.imageAspectRatio = parsePhoto.imageAspectRatio
			photo.thumbAspectRatio = parsePhoto.thumbAspectRatio

			if let imageFile = parsePhoto.imageFile {
				photo.imageFileName = imageFile.name
				photo.imageFileURL = imageFile.url ?? ""

			}
		
			if let imageFile = parsePhoto.thumbFile {
				photo.thumbFileName = imageFile.name
				photo.thumbFileURL = imageFile.url ?? ""
			}
		
	}
	
	
//	class func fromJSON(json:JSON,  moc: NSManagedObjectContext) -> (Photo)? {
//		//	println("\(__FUNCTION__) \(json)")
//		if let photo = NSEntityDescription.insertNewObjectForEntityForName(ModelEntity.photo, inManagedObjectContext:moc) as? Photo {
//			photo.createdAt = json["createdAt"].stringValue
//			photo.idArt = json["idArt"].stringValue
//			photo.imageAspectRatio = json["imageAspectRatio"].double ?? 1.0
//			photo.imageFileName = extractImageFileName(json["imageFile"]["name"].stringValue)
//			photo.imageFileURL = json["imageFile"]["url"].stringValue
//			photo.objectId = json["objectId"].stringValue
//			photo.updatedAt = json["updatedAt"].stringValue
//			return photo
//		}
//		return nil
//	}
//	
	class private func extractImageFileName(source: String) -> String {
		var imageFileName = ""
		let delimiter = "-"
		if let lastDelimiter = source.rangeOfString(delimiter, options: NSStringCompareOptions.BackwardsSearch) {
			imageFileName = source[lastDelimiter.endIndex..<source.endIndex]
		}
//		println("image file name \(imageFileName)")
		return imageFileName
	}
}