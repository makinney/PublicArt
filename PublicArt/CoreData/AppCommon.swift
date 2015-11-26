//
//  AppCommon.swift
//  PublicArt
//
//  Created by Michael Kinney on 7/22/15.
//  Copyright (c) 2015 makinney. All rights reserved.
//

import Foundation
import CoreData

@objc(AppCommon)

class AppCommon: NSManagedObject {

    @NSManaged var facebookPublicArtPage: String
    @NSManaged var emailSupportAddressOne: String
    @NSManaged var emailSupportAddressTwo: String
    @NSManaged var myWebSite: String
    @NSManaged var twitterHandle: String
    @NSManaged var spareOne: String
    @NSManaged var spareTwo: String
    @NSManaged var spareThree: NSNumber
    @NSManaged var spareFour: NSNumber
    @NSManaged var objectId: String
    @NSManaged var updatedAt: NSDate
    @NSManaged var createdAt: NSDate

}
