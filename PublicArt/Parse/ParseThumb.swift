//
//  ParseThumb.swift
//  PublicArt
//
//  Created by Michael Kinney on 6/23/15.
//  Copyright (c) 2015 makinney. All rights reserved.
//

import Foundation
import Parse

class ParseThumb : PFObject, PFSubclassing {
	override class func initialize() {
		struct Static {
			static var onceToken : dispatch_once_t = 0
		}
		dispatch_once(&Static.onceToken) {
			self.registerSubclass()
		}
	}
	
	static func parseClassName() -> String {
		return "thumb"
	}
	
	@NSManaged var idArt: String?
	@NSManaged var imageFile: PFFile?
	@NSManaged var imageAspectRatio: Double
}