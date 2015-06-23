//
//  Photo.swift
//  PublicArt
//
//  Created by Michael Kinney on 6/17/15.
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
    @NSManaged var updatedAt: NSDate
    @NSManaged var thumbFileName: String
    @NSManaged var thumbFileURL: String
    @NSManaged var thumbAspectRatio: NSNumber
    @NSManaged var artwork: Art

}
