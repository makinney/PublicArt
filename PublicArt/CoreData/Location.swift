//
//  Location.swift
//  PublicArt
//
//  Created by Michael Kinney on 6/6/15.
//  Copyright (c) 2015 makinney. All rights reserved.
//

import Foundation
import CoreData

@objc(Location)

class Location: NSManagedObject {

    @NSManaged var createdAt: String
    @NSManaged var idLocation: String
    @NSManaged var latitude: NSNumber
    @NSManaged var longitude: NSNumber
    @NSManaged var name: String
    @NSManaged var objectId: String
    @NSManaged var type: String
    @NSManaged var updatedAt: String
    @NSManaged var art: NSSet

}
