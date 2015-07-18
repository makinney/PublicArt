//
//  ParseArt.swift
//  PublicArt
//
//  Created by Michael Kinney on 6/17/15.
//  Copyright (c) 2015 makinney. All rights reserved.
//

import Foundation
import Parse

class ParseArt : PFObject, PFSubclassing {
	override class func initialize() {
		struct Static {
			static var onceToken : dispatch_once_t = 0
		}
		dispatch_once(&Static.onceToken) {
			self.registerSubclass()
		}
	}
	
	static func parseClassName() -> String {
		return "artwork"
	}
	
	@NSManaged var idArt: String?
	@NSManaged var idArtist: String?
	@NSManaged var idLocation: String?
	@NSManaged var tags: String?
	@NSManaged var title: String?
	@NSManaged var descriptionFile: PFFile?
	@NSManaged var latitude: String?
	@NSManaged var longitude: String?
	@NSManaged var address: String?
	@NSManaged var artWebLink: String?
	@NSManaged var accession: String?
	@NSManaged var credit: String?
	@NSManaged var condition: String?
	@NSManaged var dimensions: String?
	@NSManaged var medium: String?
	@NSManaged var missing: Bool
	@NSManaged var hasThumb: Bool
	
}