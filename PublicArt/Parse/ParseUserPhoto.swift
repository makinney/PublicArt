//
//  ParseUserPhoto.swift
//  PublicArt
//
//  Created by Michael Kinney on 7/24/15.
//  Copyright (c) 2015 makinney. All rights reserved.
//

import Foundation
import Parse

class ParseUserPhoto : PFObject, PFSubclassing {
	override class func initialize() {
		struct Static {
			static var onceToken : dispatch_once_t = 0
		}
		dispatch_once(&Static.onceToken) {
			self.registerSubclass()
		}
	}
	
	static func parseClassName() -> String {
		return "userPhoto"
	}
	
	@NSManaged var idArt: String?
	@NSManaged var imageFile: PFFile?
}