//
//  LocPhoto.swift
//  PublicArt
//
//  Created by Michael Kinney on 6/25/15.
//  Copyright (c) 2015 makinney. All rights reserved.
//

import Foundation
import CoreData
import Parse

@objc(LocPhoto)

class LocPhoto: NSManagedObject {

    @NSManaged var createdAt: NSDate
    @NSManaged var idLocation: String
    @NSManaged var imageAspectRatio: NSNumber
    @NSManaged var imageFileName: String
    @NSManaged var imageFileURL: String
    @NSManaged var objectId: String
    @NSManaged var updatedAt: NSDate
    @NSManaged var location: Location

}
