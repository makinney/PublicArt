//
//  Art.swift
//  PublicArt
//
//  Created by Michael Kinney on 7/7/15.
//  Copyright (c) 2015 makinney. All rights reserved.
//

import Foundation
import CoreData

@objc(Art)

class Art: NSManagedObject {

    @NSManaged var accession: String
    @NSManaged var address: String
    @NSManaged var artistName: String
    @NSManaged var condition: String
    @NSManaged var createdAt: NSDate
    @NSManaged var credit: String
    @NSManaged var descriptionFileName: String
    @NSManaged var descriptionFileURL: String
    @NSManaged var dimensions: String
    @NSManaged var favorite: NSNumber
    @NSManaged var hasThumb: NSNumber
    @NSManaged var idArt: String
    @NSManaged var idLocation: String
    @NSManaged var latitude: NSNumber
    @NSManaged var longitude: NSNumber
    @NSManaged var medium: String
    @NSManaged var missing: NSNumber
    @NSManaged var objectId: String
    @NSManaged var tags: String
    @NSManaged var title: String
    @NSManaged var updatedAt: NSDate
    @NSManaged var artWebLink: String
    @NSManaged var artistWebLink: String
    @NSManaged var artist: Artist
    @NSManaged var location: Location
    @NSManaged var photos: NSSet
    @NSManaged var thumb: Thumb?

}
