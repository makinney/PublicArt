//
//  Art.swift
//  PublicArt
//
//  Created by Michael Kinney on 6/9/15.
//  Copyright (c) 2015 makinney. All rights reserved.
//

import Foundation
import CoreData

@objc(Art)

class Art: NSManagedObject {

    @NSManaged var artistName: String
    @NSManaged var createdAt: String
    @NSManaged var credit: String
    @NSManaged var dimensions: String
    @NSManaged var idArt: String
    @NSManaged var idLocation: String
    @NSManaged var latitude: NSNumber
    @NSManaged var locationName: String
    @NSManaged var locDescription: String
    @NSManaged var longitude: NSNumber
    @NSManaged var medium: String
    @NSManaged var objectId: String
    @NSManaged var imageFileName: String
    @NSManaged var title: String
    @NSManaged var updatedAt: String
    @NSManaged var imageAspectRatio: NSNumber
    @NSManaged var locations: NSSet
    @NSManaged var photos: NSSet

}
