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

	static func parseClassName() -> String {
		return "userPhoto"
	}
	
	@NSManaged var idArt: String?
	@NSManaged var imageFile: PFFile?
}
