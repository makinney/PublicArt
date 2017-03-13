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
	
	class func create(_ parseThumb: ParseThumb, moc: NSManagedObjectContext) -> Thumb? {
		if let thumb = NSEntityDescription.insertNewObject(forEntityName: ModelEntity.thumb, into:moc) as? Thumb {
			thumb.createdAt = parseThumb.createdAt!
			thumb.objectId = parseThumb.objectId!
			thumb.updatedAt = parseThumb.updatedAt!
			thumb.idArt = parseThumb.idArt ?? ""
            thumb.imageAspectRatio = NSNumber(value: parseThumb.imageAspectRatio)
			
			if let imageFile = parseThumb.imageFile {
	//			thumb.imageFileName = extractImageFileName(imageFile.name)
                thumb.imageFileName = imageFile.name
				thumb.imageFileURL = imageFile.url ?? ""
			}
			
			return thumb
		}
		return nil
	}
	
	
	class func update(_ thumb: Thumb, parseThumb: ParseThumb) {
		thumb.createdAt = parseThumb.createdAt!
		thumb.objectId = parseThumb.objectId!
		thumb.updatedAt = parseThumb.updatedAt!
		thumb.idArt = parseThumb.idArt ?? ""
        thumb.imageAspectRatio = NSNumber(value: parseThumb.imageAspectRatio)
		
		if let imageFile = parseThumb.imageFile {
	//		thumb.imageFileName = extractImageFileName(imageFile.name)
            thumb.imageFileName = imageFile.name
			thumb.imageFileURL = imageFile.url ?? ""
			
		}
	}
	
//	class fileprivate func extractImageFileName(_ source: String) -> String {
//		var imageFileName = ""
//		let delimiter = "-"
//		if let lastDelimiter = source.range(of: delimiter, options: NSString.CompareOptions.backwards) {
//			imageFileName = source[lastDelimiter.upperBound..<source.endIndex]
//		}
//		// println("extracted image file name \(imageFileName)")
//		return imageFileName
//	}

	
}
