//
//  Artist.swift
//  PublicArt
//
//  Created by Michael Kinney on 7/17/15.
//  Copyright (c) 2015 makinney. All rights reserved.
//

import Foundation
import CoreData

@objc(Artist)

class Artist: NSManagedObject {

    @NSManaged var createdAt: NSDate
    @NSManaged var idArtist: String
    @NSManaged var name: String
    @NSManaged var objectId: String
    @NSManaged var updatedAt: NSDate
    @NSManaged var webLink: String
    @NSManaged var artwork: NSSet

}
