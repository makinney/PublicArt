//
//  ParseRefresh.swift
//  PublicArt
//
//  Created by Michael Kinney on 7/10/15.
//  Copyright (c) 2015 makinney. All rights reserved.
//

import Foundation

import Parse

class ParseRefresh : PFObject, PFSubclassing {
	private static var __once: () = {
// FIXME:            self.registerSubclass
		}()
	override class func initialize() {
		struct Static {
			static var onceToken : Int = 0
		}
		_ = ParseRefresh.__once
	}
	
	static func parseClassName() -> String {
		return "refresh"
	}
	
	@NSManaged var lastRefresh: Date?
	
}
