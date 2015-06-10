//
//  Photo.swift
//  PublicArt
//
//  Created by Michael Kinney on 6/9/15.
//  Copyright (c) 2015 makinney. All rights reserved.
//

import Foundation
import CoreData

@objc(Photo)

class Photo: NSManagedObject {

    @NSManaged var createdAt: String
    @NSManaged var idArt: String
    @NSManaged var imageFileName: String
    @NSManaged var imageFileURL: String
    @NSManaged var objectId: String
    @NSManaged var updatedAt: String
    @NSManaged var imageAspectRatio: NSNumber
    @NSManaged var art: Art

}
