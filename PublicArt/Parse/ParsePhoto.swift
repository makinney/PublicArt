//
//  ParsePhoto.swift
//  PublicArt
//
//  Created by Michael Kinney on 6/16/15.
//  Copyright (c) 2015 makinney. All rights reserved.
//

import Foundation
import Parse

final class ParsePhoto : PFObject, PFSubclassing {

    // Required otherwise the application crashes
    override init() {
        super.init()
    }

	static func parseClassName() -> String {
		return "photo"
	}
	
	@NSManaged var idArt: String?
	@NSManaged var imageFile: PFFile?
	@NSManaged var imageAspectRatio: Double
	@NSManaged var tnMatch: Bool
}


