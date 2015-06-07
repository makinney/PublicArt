//
//  ArtFileManager.swift
//  City Art San Francisco
//
//  Created by Michael Kinney on 1/16/15.
//  Copyright (c) 2015 mkinney. All rights reserved.
//

import Foundation
//import ImageIO

class ArtFileManager {
	
	let fileManager: NSFileManager
	var directory: NSURL?
	
	class var sharedInstance: ArtFileManager {
		struct Singleton {
			static let instance = ArtFileManager()
		}
		return Singleton.instance
	}
	
	private init() {
		fileManager = NSFileManager.defaultManager()
		var currentWorkingDirectory = fileManager.currentDirectoryPath
		directory = appDataDirectory()!
	}
	
	private func appDataDirectory() -> NSURL?  {
		var bundleId = NSBundle.mainBundle().bundleIdentifier!
		var directory: NSURL?
		var appSupportDirectory: NSURL
		var appSupportDir = NSFileManager.defaultManager().URLsForDirectory(.ApplicationSupportDirectory, inDomains:.UserDomainMask)
		if appSupportDir.count > 0 {
			directory = appSupportDir[0].URLByAppendingPathComponent(bundleId)
			if directory != nil {
				if !fileManager.createDirectoryAtURL(directory!, withIntermediateDirectories: true, attributes: nil, error: nil) {
					directory = nil
				}
			}
		}
		return directory
	}
	
	func createFile(fileName: String, data: NSData) {
		var dirPath = directory!.path
		var fullPath = dirPath?.stringByAppendingPathComponent(fileName)
		if fullPath != nil {
//			println("create full path \(fullPath!)")
			fileManager.createFileAtPath(fullPath!, contents: data, attributes: nil)
		}
		
	}
	
//	func imageSource(fileName: String) -> CGImageSource? {
//		var imageSource: CGImageSourceRef?
////		var dirPath = directory.path
////		var fullPath = dirPath?.stringByAppendingPathComponent(fileName)
//		var url = directory.URLByAppendingPathComponent(fileName)
////		if fullPath != nil { // TODO:
//			imageSource = CGImageSourceCreateWithURL(url, nil)
////		}
//		return imageSource
//	}
	
	func readFile(fileName: String) -> NSData? {
		var data: NSData?
		var dirPath = directory!.path
		var fullPath = dirPath?.stringByAppendingPathComponent(fileName)
		if fullPath != nil {
//			println("read full path \(fullPath!)")
			data = fileManager.contentsAtPath(fullPath!)
		}

		return data
	}
	
}
