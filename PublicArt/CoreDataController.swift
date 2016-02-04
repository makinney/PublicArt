//
//  DataController.swift
//  SFFilmLocations
//
//  Created by Michael Kinney on 1/20/16.
//  Copyright © 2016 makinney. All rights reserved.
//

import UIKit
import CoreData
// TODO: use this instead of my approach...
class CoreDataController: NSObject {
	let managedObjectContext: NSManagedObjectContext
	
	override init() {
		guard let modelURL = NSBundle.mainBundle().URLForResource("SFFilmLocations", withExtension:"momd") else {
			fatalError("Error loading model from bundle")
		}
		guard let mom = NSManagedObjectModel(contentsOfURL: modelURL) else {
			fatalError("Error initializing mom from: \(modelURL)")
		}
		
		let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
		self.managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
		self.managedObjectContext.persistentStoreCoordinator = psc
		
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
			let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
			let docURL = urls[urls.endIndex-1]
			let storeURL = docURL.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
			do {
				try psc.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil)
			} catch {
				fatalError("Error migrating store: \(error)")
			}
		}
	}
}
