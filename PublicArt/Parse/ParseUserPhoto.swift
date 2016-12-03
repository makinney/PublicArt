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
	private static var __once: () = {
// FIXME:			self.registerSubclass()
		}()
	override class func initialize() {
		struct Static {
			static var onceToken : Int = 0
		}
		_ = ParseUserPhoto.__once
	}
	
	static func parseClassName() -> String {
		return "userPhoto"
	}
	
	@NSManaged var idArt: String?
	@NSManaged var imageFile: PFFile?
}
