//
//  Thumb.swift
//  PublicArt
//
//  Created by Michael Kinney on 7/22/15.
//  Copyright (c) 2015 makinney. All rights reserved.
//

import Foundation
import CoreData

@objc(Thumb)

class Thumb: NSManagedObject {

    @NSManaged var createdAt: Date
    @NSManaged var idArt: String
    @NSManaged var imageAspectRatio: NSNumber
    @NSManaged var imageFileName: String
    @NSManaged var imageFileURL: String
    @NSManaged var objectId: String
    @NSManaged var updatedAt: Date
    @NSManaged var spareOne: String
    @NSManaged var spareTwo: NSNumber
    @NSManaged var spareThree: NSNumber
    @NSManaged var artwork: Art

}
