//
//  Location.swift
//  PublicArt
//
//  Created by Michael Kinney on 7/22/15.
//  Copyright (c) 2015 makinney. All rights reserved.
//

import Foundation
import CoreData

@objc(Location)

class Location: NSManagedObject {

    @NSManaged var createdAt: NSDate
    @NSManaged var idLocation: String
    @NSManaged var latitude: NSNumber
    @NSManaged var longitude: NSNumber
    @NSManaged var name: String
    @NSManaged var objectId: String
    @NSManaged var updatedAt: NSDate
    @NSManaged var spareOne: String
    @NSManaged var spareTwo: String
    @NSManaged var spareThree: NSNumber
    @NSManaged var artwork: NSSet
    @NSManaged var photo: LocPhoto?

}
