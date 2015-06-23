//
//  ParseArtist.swift
//  PublicArt
//
//  Created by Michael Kinney on 6/17/15.
//  Copyright (c) 2015 makinney. All rights reserved.
//

import Foundation
import Parse


class ParseArtist : PFObject, PFSubclassing {
	override class func initialize() {
		struct Static {
			static var onceToken : dispatch_once_t = 0
		}
		dispatch_once(&Static.onceToken) {
			self.registerSubclass()
		}
	}
	
	static func parseClassName() -> String {
		return "artist"
	}
	
	@NSManaged var name: String?
	@NSManaged var idArtist: String?
	@NSManaged var webLink1: PFFile?
	
}