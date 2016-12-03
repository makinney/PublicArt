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
	private static var __once: () = {
// FIXME:			self.registerSubclass()
		}()
	override class func initialize() {
		struct Static {
			static var onceToken : Int = 0
		}
		_ = ParsePhoto.__once
	}
	
	static func parseClassName() -> String {
		return "photo"
	}
	
	@NSManaged var idArt: String?
	@NSManaged var imageFile: PFFile?
	@NSManaged var imageAspectRatio: Double
	@NSManaged var tnMatch: Bool
}
