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
	private static var __once: () = {
// FIXME:			self.registerSubclass()
		}()
	override class func initialize() {
		struct Static {
			static var onceToken : Int = 0
		}
		_ = ParseArtist.__once
	}
	
	static func parseClassName() -> String {
		return "artist"
	}
	
	@NSManaged var firstName: String?
	@NSManaged var lastName: String?
	@NSManaged var idArtist: String?
	@NSManaged var webLink: String?
	
}
