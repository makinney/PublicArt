//
//  ParseArtist.swift
//  PublicArt
//
//  Created by Michael Kinney on 6/17/15.
//  Copyright (c) 2015 makinney. All rights reserved.
//

import Foundation
import Parse


final class ParseArtist: PFObject, PFSubclassing {

	@NSManaged var firstName: String?
	@NSManaged var lastName: String?
	@NSManaged var idArtist: String?
	@NSManaged var webLink: String?
    
    // MARK: - Overridden
//    override class func query() -> PFQuery<PFObject>? {
//        let query = PFQuery(className: ParseArtist.parseClassName())
//        query.includeKey("user")
//        query.order(byDescending: "createdAt")
//        return query
//    }

}

extension ParseArtist {
    static func parseClassName() -> String {
        return "artist"
    }
}

