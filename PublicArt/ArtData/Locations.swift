//
//  Locations.swift
//  ArtCity
//
//  Created by Michael Kinney on 2/3/15.
//  Copyright (c) 2015 mkinney. All rights reserved.
//

import Foundation
import CoreData

class Locations {
	
	let locations: [Location]// = [Location]()
	let fetcher: Fetcher
	// TODO do not use shared instance
	let moc = CoreDataStack.sharedInstance.managedObjectContext!
	
	init() {
		fetcher = Fetcher(managedObjectContext:self.moc)
		if let locations = fetcher.fetchAllLocations() {
			self.locations = locations
		} else {
			self.locations = [Location]()
		}
	}
	
	func location(idLocation: String) -> Location? {
		var location: Location?
		var count = locations.count
		for index in 0..<count {
			if locations[index].idLocation == idLocation {
				location = locations[index]
				break
			}
		}
		return location
	}
	
}