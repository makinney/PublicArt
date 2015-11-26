//
//  Photo.swift
//  PublicArt
//
//  Created by Michael Kinney on 7/22/15.
//  Copyright (c) 2015 makinney. All rights reserved.
//

import Foundation
import CoreData

@objc(Photo)

class Photo: NSManagedObject {

    @NSManaged var createdAt: NSDate
    @NSManaged var idArt: String
    @NSManaged var imageAspectRatio: NSNumber
    @NSManaged var imageFileName: String
    @NSManaged var imageFileURL: String
    @NSManaged var objectId: String
    @NSManaged var tnMatch: NSNumber
    @NSManaged var updatedAt: NSDate
    @NSManaged var spareOne: String
    @NSManaged var spareTwo: NSNumber
    @NSManaged var spareThree: NSNumber
    @NSManaged var artwork: Art

}
