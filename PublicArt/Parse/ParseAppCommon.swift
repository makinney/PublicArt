//
//  ParseAppCommon.swift
//  PublicArt
//
//  Created by Michael Kinney on 7/22/15.
//  Copyright (c) 2015 makinney. All rights reserved.
//

import Foundation
import Parse

class ParseAppCommon : PFObject, PFSubclassing {

	static func parseClassName() -> String {
		return "appCommon"
	}
	
	@NSManaged var facebookPublicArtPage: String?
	
}
