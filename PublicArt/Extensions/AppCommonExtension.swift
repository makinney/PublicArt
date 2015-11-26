//
//  AppCommonExtension.swift
//  PublicArt
//
//  Created by Michael Kinney on 7/22/15.
//  Copyright (c) 2015 makinney. All rights reserved.
//

import Foundation
import CoreData

extension AppCommon {
	
	class func create(parseAppCommon: ParseAppCommon, moc: NSManagedObjectContext) -> AppCommon? {
		if let appCommon = NSEntityDescription.insertNewObjectForEntityForName(ModelEntity.appCommon, inManagedObjectContext:moc) as? AppCommon {
			appCommon.objectId = parseAppCommon.objectId!
			appCommon.createdAt = parseAppCommon.createdAt!
			appCommon.updatedAt = parseAppCommon.updatedAt!
			appCommon.facebookPublicArtPage = parseAppCommon.facebookPublicArtPage ?? ""
			return appCommon
		}
		return nil
	}
	
	class func update(appCommon: AppCommon, parseAppCommon: ParseAppCommon) {
		appCommon.objectId = parseAppCommon.objectId!
		appCommon.createdAt = parseAppCommon.createdAt!
		appCommon.updatedAt = parseAppCommon.updatedAt!
		appCommon.facebookPublicArtPage = parseAppCommon.facebookPublicArtPage ?? ""
	}
	
}