//
//  ArtRefresh.swift
//  PublicArt
//
//  Created by Michael Kinney on 6/6/15.
//  Copyright (c) 2015 makinney. All rights reserved.
//

import Foundation
import CoreData

var artDataManager: ArtDataManager?

func artRefreshFromWeb() {
	let webService:WebService = WebService()
	// TODO: logging in this way just for development
	if webService.loggedIn {
		artDataManager = ArtDataManager(coreDataStack: CoreDataStack.sharedInstance)
		artDataManager!.refresh()
	} else {
		webService.logInUser("mike", password:"12345678" , completion: { (success) -> () in
			if success == true {
				artDataManager = ArtDataManager(coreDataStack: CoreDataStack.sharedInstance)
				artDataManager!.refresh()
			}
		})
	}
}

