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

    static func parseClassName() -> String {
		return "locPhoto"
	}
	
	@NSManaged var idLocation: String?
	@NSManaged var imageFile: PFFile?
	@NSManaged var imageAspectRatio: Double
}
