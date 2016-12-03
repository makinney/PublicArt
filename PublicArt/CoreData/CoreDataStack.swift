//
//  CoreDataStack.swift
//  AppDataModel
//
//  Created by Michael Kinney on 11/18/14.
//  Copyright (c) 2014 mkinney. All rights reserved.
//

import Foundation
import CoreData

open class CoreDataStack {

	init() {
	
	}
	
	open class var sharedInstance: CoreDataStack {
		struct Singleton {
			static let instance = CoreDataStack()
		}
		return Singleton.instance
	}
	
	open func saveContext () ->  Bool {
	    var success = true
		if let moc = self.managedObjectContext {
			if moc.hasChanges {
				do {
					try moc.save()
				} catch  {
					success = false
				}
			}
		}
		return success
	}
	
	lazy var applicationDocumentsDirectory: URL = {
		// The directory the application uses to store the Core Data store file. This code uses a directory named "com.mkinney.City_Art_San_Francisco" in the application's documents Application Support directory.
		let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		return urls[urls.count-1] 
		}()
	
	lazy var managedObjectModel: NSManagedObjectModel = {
		// The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
		let modelURL = Bundle.main.url(forResource: "PublicArtModel", withExtension: "momd")!
		return NSManagedObjectModel(contentsOf: modelURL)!
		}()
	
	lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
		// The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
		
//		self.updateStoredSqliteFromBundle() // maximum one time per app update
		
		// Create the coordinator and store
		var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
		let url = self.applicationDocumentsDirectory.appendingPathComponent("PublicArtModel.sqlite")
		
		var failureReason = "There was an error creating or loading the application's saved data."
		do {
			try coordinator!.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
		} catch let error as NSError {
			NSLog("Unresolved error \(error), \(error.userInfo)")
	//		abort() // TODO:
		} catch {
			fatalError()
		}
		
		return coordinator
		}()
	
		lazy var managedObjectContext: NSManagedObjectContext? = {
		// Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
		let coordinator = self.persistentStoreCoordinator
		if coordinator == nil {
			return nil
		}
		
		var managedObjectContext = NSManagedObjectContext()
		managedObjectContext.persistentStoreCoordinator = coordinator
		return managedObjectContext
		}()
	
		// MARK: Bundled Sqlite
/*
		func updateStoredSqliteFromBundle() {
			if bundledSqliteExists() {
				if self.bundledVersionCopied() == false {
					self.removeExistingSqliteFromStore()
					if self.copySqliteFromBundleToStore() {
						self.updateSeedVersionNumber()
						self.newDatabaseNotification()
					}
				}
			}
		}
	
	
		func bundledSqliteExists() -> Bool {
			var exists = false
			let artCityModelBundledPath = NSBundle.mainBundle().pathForResource("PublicArtModel", ofType: "sqlite")
			if artCityModelBundledPath != nil {
				exists = true
			}
			return exists
		}
	
		func bundledVersionCopied() -> Bool {
			// must test for existed of file !!
			var copied = false
			let bundleVersion = getBundleVersion()
			let userDefaults = NSUserDefaults.standardUserDefaults
			if let seedVersion = userDefaults().objectForKey("ArtCityModelSeedVersion") as? String {
				if seedVersion == bundleVersion {
					copied = true
				}
			}
			
			return copied
		}
	
		// TODO: copy needs to force a reload of art list views, art maps, photos....
		func copySqliteFromBundleToStore() -> Bool {
			var success = false
			let fileManager = NSFileManager.defaultManager()
			
			let artCityModelSourcePath = NSBundle.mainBundle().pathForResource("PublicArtModel", ofType: "sqlite")
			//println("bundle store path \(artCityModelSourcePath)")
			
			let storePath = self.applicationDocumentsDirectory
			let fullPath = storePath.URLByAppendingPathComponent("PublicArtModel.sqlite")
			do {
				try fileManager.copyItemAtPath(artCityModelSourcePath!, toPath: fullPath.path! )
			} catch  {
				success = false
			}
			return success
		}
	
		func getBundleVersion() -> String {
			let dictionary = NSBundle.mainBundle().infoDictionary
			var infoDictionary = dictionary as Dictionary!
			let bundleVersion = infoDictionary[String(kCFBundleVersionKey)] as! String!
			return bundleVersion
		}
	
		func removeExistingSqliteFromStore() {
			let fileManager = NSFileManager.defaultManager()
			let storeDirectory = self.applicationDocumentsDirectory
			
			let enumerator = fileManager.enumeratorAtURL(storeDirectory, includingPropertiesForKeys: nil, options: .SkipsSubdirectoryDescendants, errorHandler: nil)
			var nextObj: AnyObject? = enumerator?.nextObject()
			while nextObj != nil {
				if let url = nextObj as? NSURL {
					// println("last path \(url.lastPathComponent)")
					let hasPrefix = url.lastPathComponent?.hasPrefix("PublicArtModel") ?? false
					if hasPrefix {
						do {
							try fileManager.removeItemAtURL(url)
						} catch let error1 as NSError {
							error = error1
						}
					}
				}
				nextObj = enumerator?.nextObject()
			}
		}
		
	
		func updateSeedVersionNumber() {
			let bundleVersion = getBundleVersion()
			let userDefaults = NSUserDefaults.standardUserDefaults
			userDefaults().setObject(bundleVersion, forKey: "PublicArtModelSeedVersion") // TODO: define
		}
	
		// MARK: Notifications
	
		func newDatabaseNotification() {
			NSNotificationCenter.defaultCenter().postNotificationName(ArtAppNotifications.NewArtCityDatabase.rawValue, object: self, userInfo:nil)
		}

		*/
	}


