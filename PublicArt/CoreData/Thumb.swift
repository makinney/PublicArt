//
//  Thumb.swift
//  PublicArt
//
//  Created by Michael Kinney on 6/23/15.
//  Copyright (c) 2015 makinney. All rights reserved.
//

import Foundation
import CoreData

@objc(Thumb)

class Thumb: NSManagedObject {

    @NSManaged var createdAt: NSDate
    @NSManaged var updatedAt: NSDate
    @NSManaged var objectId: String
    @NSManaged var imageFileName: String
    @NSManaged var imageFileURL: String
    @NSManaged var idArt: String
    @NSManaged var imageAspectRatio: NSNumber
    @NSManaged var artwork: Art

}
