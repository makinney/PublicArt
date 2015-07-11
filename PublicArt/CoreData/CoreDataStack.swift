//
//  CoreDataStack.swift
//  AppDataModel
//
//  Created by Michael Kinney on 11/18/14.
//  Copyright (c) 2014 mkinney. All rights reserved.
//

import Foundation
import CoreData

public class CoreDataStack {

	init() {
	
	}
	
	public class var sharedInstance: CoreDataStack {
		struct Singleton {
			static let instance = CoreDataStack()
		}
		return Singleton.instance
	}
	
	public func saveContext () ->  Bool {
		if let moc = self.managedObjectContext {
			var error: NSError? = nil
			if moc.hasChanges && !moc.save(&error) {
				NSLog("Unresolved error in cored data save \(error), \(error!.userInfo)")
				return false
			} else {
				return true
			}
		}
		return false
	}
	
	lazy var applicationDocumentsDirectory: NSURL = {
		// The directory the application uses to store the Core Data store file. This code uses a directory named "com.mkinney.City_Art_San_Francisco" in the application's documents Application Support directory.
		let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
		return urls[urls.count-1] as! NSURL
		}()
	
	lazy var managedObjectModel: NSManagedObjectModel = {
		// The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
		let modelURL = NSBundle.mainBundle().URLForResource("PublicArtModel", withExtension: "momd")!
		return NSManagedObjectModel(contentsOfURL: modelURL)!
		}()
	
	lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
		// The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
		
		self.updateStoredSqliteFromBundle() // maximum one time per app update
		
		// Create the coordinator and store
		var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
		let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("PublicArtModel.sqlite")
		
		var error: NSError? = nil
		var failureReason = "There was an error creating or loading the application's saved data."
		if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error: &error) == nil {
			coordinator = nil
			// Report any error we got.
			let dict = NSMutableDictionary()
			dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
			dict[NSLocalizedFailureReasonErrorKey] = failureReason
			dict[NSUnderlyingErrorKey] = error
			error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict as [NSObject : AnyObject])
			// Replace this with code to handle the error appropriately.
			// TODO: abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
			NSLog("Unresolved error \(error), \(error!.userInfo)")
	//		abort() // TODO:
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
			var artCityModelBundledPath = NSBundle.mainBundle().pathForResource("PublicArtModel", ofType: "sqlite")
			if artCityModelBundledPath != nil {
				exists = true
			}
			return exists
		}
	
		func bundledVersionCopied() -> Bool {
			// must test for existed of file !!
			var copied = false
			var bundleVersion = getBundleVersion()
			var userDefaults = NSUserDefaults.standardUserDefaults
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
			var error: NSError?
			let fileManager = NSFileManager.defaultManager()
			
			var artCityModelSourcePath = NSBundle.mainBundle().pathForResource("PublicArtModel", ofType: "sqlite")
			//println("bundle store path \(artCityModelSourcePath)")
			
			var storePath = self.applicationDocumentsDirectory.path
			var fullPath = storePath?.stringByAppendingPathComponent("PublicArtModel.sqlite") // must be named in destination
			//println(" full path \(fullPath)")
			
			fileManager.copyItemAtPath(artCityModelSourcePath!, toPath: fullPath! , error: &error)
			if error == nil {
				success = true
			} else {
				success = false
			}
			return success
		}
	
		func getBundleVersion() -> String {
			var dictionary = NSBundle.mainBundle().infoDictionary
			var infoDictionary = dictionary as Dictionary!
			var bundleVersion = infoDictionary[kCFBundleVersionKey] as! String!
			return bundleVersion
		}
	
		func removeExistingSqliteFromStore() {
			let fileManager = NSFileManager.defaultManager()
			var error: NSError?
			var storeDirectory = self.applicationDocumentsDirectory
			
			var enumerator = fileManager.enumeratorAtURL(storeDirectory, includingPropertiesForKeys: nil, options: .SkipsSubdirectoryDescendants, errorHandler: nil)
			var nextObj: AnyObject? = enumerator?.nextObject()
			while nextObj != nil {
				if let url = nextObj as? NSURL {
					// println("last path \(url.lastPathComponent)")
					var hasPrefix = url.lastPathComponent?.hasPrefix("PublicArtModel") ?? false
					if hasPrefix {
						fileManager.removeItemAtURL(url, error: &error)
					}
				}
				nextObj = enumerator?.nextObject()
			}
		}
		
	
		func updateSeedVersionNumber() {
			var bundleVersion = getBundleVersion()
			var userDefaults = NSUserDefaults.standardUserDefaults
			userDefaults().setObject(bundleVersion, forKey: "PublicArtModelSeedVersion") // TODO: define
		}
	
		// MARK: Notifications
	
		func newDatabaseNotification() {
			NSNotificationCenter.defaultCenter().postNotificationName(ArtAppNotifications.NewArtCityDatabase.rawValue, object: self, userInfo:nil)
		}

	
	}


