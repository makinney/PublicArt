//
//  ParseLocation.swift
//  PublicArt
//
//  Created by Michael Kinney on 6/17/15.
//  Copyright (c) 2015 makinney. All rights reserved.
//

import Foundation
import Parse

class ParseLocation : PFObject, PFSubclassing {
	static func parseClassName() -> String {
		return "location"
	}
	
	@NSManaged var idLocation: String?
	@NSManaged var name: String?
	@NSManaged var latitude: String?
	@NSManaged var longitude: String?
	@NSManaged var spanLat: String?
	@NSManaged var spanLon: String?
	@NSManaged var type: String?
	
}
