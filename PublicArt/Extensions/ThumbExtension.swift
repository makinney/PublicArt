//
//  ThumbExtension.swift
//  PublicArt
//
//  Created by Michael Kinney on 6/23/15.
//  Copyright (c) 2015 makinney. All rights reserved.
//

import Foundation
import CoreData
import Parse

extension Thumb {
	
	class func create(parseThumb: ParseThumb, moc: NSManagedObjectContext) -> Thumb? {
		if let thumb = NSEntityDescription.insertNewObjectForEntityForName(ModelEntity.thumb, inManagedObjectContext:moc) as? Thumb {
			thumb.createdAt = parseThumb.createdAt!
			thumb.objectId = parseThumb.objectId!
			thumb.updatedAt = parseThumb.updatedAt!
			thumb.idArt = parseThumb.idArt ?? ""
			thumb.imageAspectRatio = parseThumb.imageAspectRatio
			
			if let imageFile = parseThumb.imageFile {
				thumb.imageFile = imageFile
				thumb.imageFileName = imageFile.name
				thumb.imageFileURL = imageFile.url ?? ""
			}
			
			return thumb
		}
		return nil
	}
	
	
	class func update(thumb: Thumb, parseThumb: ParseThumb) {
		thumb.createdAt = parseThumb.createdAt!
		thumb.objectId = parseThumb.objectId!
		thumb.updatedAt = parseThumb.updatedAt!
		thumb.idArt = parseThumb.idArt ?? ""
		thumb.imageAspectRatio = parseThumb.imageAspectRatio
		
		if let imageFile = parseThumb.imageFile {
			thumb.imageFile = imageFile
			thumb.imageFileName = imageFile.name
			thumb.imageFileURL = imageFile.url ?? ""
			
		}
	}
	
}