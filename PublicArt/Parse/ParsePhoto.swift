//
//  ParsePhoto.swift
//  PublicArt
//
//  Created by Michael Kinney on 6/16/15.
//  Copyright (c) 2015 makinney. All rights reserved.
//

import Foundation
import Parse

class ParsePhoto : PFObject, PFSubclassing {
	override class func initialize() {
		struct Static {
			static var onceToken : dispatch_once_t = 0
		}
		dispatch_once(&Static.onceToken) {
			self.registerSubclass()
		}
	}
	
	static func parseClassName() -> String {
		return "photo"
	}
	
	@NSManaged var idArt: String?
	@NSManaged var imageFile: PFFile?
	@NSManaged var imageAspectRatio: Double
	@NSManaged var tnMarch: Bool
}