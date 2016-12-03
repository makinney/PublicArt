//
//  ParseLocPhoto.swift
//  PublicArt
//
//  Created by Michael Kinney on 6/25/15.
//  Copyright (c) 2015 makinney. All rights reserved.
//

import Foundation
import Parse

class ParseLocPhoto : PFObject, PFSubclassing {
	private static var __once: () = {
// FIXME:			self.registerSubclass()
		}()
	override class func initialize() {
		struct Static {
			static var onceToken : Int = 0
		}
		_ = ParseLocPhoto.__once
	}
	
	static func parseClassName() -> String {
		return "locPhoto"
	}
	
	@NSManaged var idLocation: String?
	@NSManaged var imageFile: PFFile?
	@NSManaged var imageAspectRatio: Double
}
