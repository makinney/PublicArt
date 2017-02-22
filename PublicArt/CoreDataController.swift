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
		guard let modelURL = Bundle.main.url(forResource: "SFFilmLocations", withExtension:"momd") else {
			fatalError("Error loading model from bundle")
		}
		guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
			fatalError("Error initializing mom from: \(modelURL)")
		}
		
		let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
		self.managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
		self.managedObjectContext.persistentStoreCoordinator = psc
        
		
		DispatchQueue.global().async {
			let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
			let docURL = urls[urls.endIndex-1]
			let storeURL = docURL.appendingPathComponent("SingleViewCoreData.sqlite")
			do {
				try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
			} catch {
				fatalError("Error migrating store: \(error)")
			}
		}
	}
}
