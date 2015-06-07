//
//  ArtPhotoDownloader.swift
//  City Art San Francisco
//
//  Created by Michael Kinney on 1/15/15.
//  Copyright (c) 2015 mkinney. All rights reserved.
//

import Foundation
import UIKit

class ArtPhotoDownloader {

	let artFileManager: ArtFileManager
	
	init() {
		artFileManager = ArtFileManager.sharedInstance
	}
	
	deinit {
	}
	
	func process(photos: [Photo]) {
		let webService = WebService()
		download(photos, webService: webService)
	}
	
	private func download(photos: [Photo], webService: WebService) -> (){
		for photo in photos {
			if !photo.imageFileURL.isEmpty && !photo.imageFileName.isEmpty {
				webService.getNSData(photo, complete: { (photo, data) -> () in
					if let data = data  {
						self.downloadedPhoto(photo, photoData: data)
					} else {
						self.downloadFailure(photo)
					}
				})
			}
		}
	}
	
	private func downloadedPhoto(photo: Photo, photoData: NSData) {
		if !photo.imageFileName.isEmpty {
			artFileManager.createFile(photo.imageFileName, data: photoData)
//			println("(\(__FUNCTION__) created photo with file name  \(photo.imageFileName)") // TODO: remove or use DLog
		} else {
			println("(\(__FUNCTION__) attemted download for photo without a file name") // TODO: remove or use DLog
		}
	}
	
	private func downloadFailure(photo: Photo) {
		println("(\(__FUNCTION__) failed to downloaded photo with file name  \(photo.imageFileName)") // TODO: remove or use DLog
	}

}

