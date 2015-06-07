//
//  PhotoFileNames.swift
//  ArtCity
//
//  Created by Michael Kinney on 1/27/15.
//  Copyright (c) 2015 mkinney. All rights reserved.
//

import Foundation

class PhotoFileNames {
	
	private var fileNames = [String]()
	private var excludePlaceholderImages = false
	
	init(art: Art ) {
		fileNames = self.getFileNames(art, excludePlaceholderImages: false)
	}
	
	init(art: Art, excludePlaceholderImages: Bool) {
		fileNames = self.getFileNames(art, excludePlaceholderImages: excludePlaceholderImages )
	}
	
	func names() -> [String]? {
		if fileNames.count > 0 {
			return fileNames
		}
		return nil
	}
	
	func fileCount() -> Int {
			return fileNames.count
	}
	
	func getFileName(index: Int) -> String? {
		var fileName: String?
		if index < fileCount() {
			return fileNames[index]
		}
		
		return fileName
	}
	
	private func getFileNames(art: Art, excludePlaceholderImages: Bool) -> [String] {
		var fileNames: [String] = []
		if !art.thumbFile.isEmpty  {
			var filename = art.thumbFile
			if excludePlaceholderImages == true {
				if filename != "copyrightedImage.png" && filename != "noPhotosImage.png" { // TODO: define
					fileNames.append(filename)
				}
			} else {
				fileNames.append(filename)
			}
		}
		var enumerator = art.photos.objectEnumerator()
		var nextObj: AnyObject? = enumerator.nextObject()
		while nextObj != nil {
			if let photo = nextObj as? Photo {
				if !photo.imageFileName.isEmpty {
					fileNames.append(photo.imageFileName)
				}
			}
			nextObj = enumerator.nextObject()
		}
		return fileNames
	}
}