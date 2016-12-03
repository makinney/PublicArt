//
//  LocPhotoExtension.swift
//  PublicArt
//
//  Created by Michael Kinney on 6/25/15.
//  Copyright (c) 2015 makinney. All rights reserved.
//

import Foundation

import CoreData
import Parse

extension LocPhoto {
	
	class func create(_ parseLocPhoto: ParseLocPhoto, moc: NSManagedObjectContext) -> LocPhoto? {
		if let locPhoto = NSEntityDescription.insertNewObject(forEntityName: ModelEntity.locPhoto, into:moc) as? LocPhoto {
			locPhoto.createdAt = parseLocPhoto.createdAt!
			locPhoto.objectId = parseLocPhoto.objectId!
			locPhoto.updatedAt = parseLocPhoto.updatedAt!
			locPhoto.idLocation = parseLocPhoto.idLocation ?? ""
            locPhoto.imageAspectRatio = NSNumber(value: parseLocPhoto.imageAspectRatio)
			
			if let imageFile = parseLocPhoto.imageFile {
				locPhoto.imageFileName = imageFile.name
				locPhoto.imageFileURL = imageFile.url ?? ""
			}
			
			return locPhoto
		}
		return nil
	}
	
	class func update(_ locPhoto: LocPhoto, parseLocPhoto: ParseLocPhoto) {
		locPhoto.createdAt = parseLocPhoto.createdAt!
		locPhoto.objectId = parseLocPhoto.objectId!
		locPhoto.updatedAt = parseLocPhoto.updatedAt!
		locPhoto.idLocation = parseLocPhoto.idLocation ?? ""
        locPhoto.imageAspectRatio = NSNumber(value: parseLocPhoto.imageAspectRatio)
		
		if let imageFile = parseLocPhoto.imageFile {
			locPhoto.imageFileName = imageFile.name
			locPhoto.imageFileURL = imageFile.url ?? ""
			
		}
	}
	
}
