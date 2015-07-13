//
//  ArtRefresh.swift
//  PublicArt
//
//  Created by Michael Kinney on 6/6/15.
//  Copyright (c) 2015 makinney. All rights reserved.
//

import Foundation
import CoreData

class ArtRefresh {
	
	class func artRefreshFromServerRequired(complete:(required: Bool, clientLastRefreshed: NSDate?, serverLastRefreshed: NSDate?) ->() ) {
		var clientLastRefreshed: NSDate? = ArtRefresh.clientLastRefreshed()
		ParseWebService.getPublicArtRefresh {(parseRefresh) -> Void in
			if let serverLastRefreshed = parseRefresh?.last?.lastRefresh {
				if let clientLastRefreshed = clientLastRefreshed {
					if clientLastRefreshed != serverLastRefreshed{
						complete(required: true, clientLastRefreshed: clientLastRefreshed, serverLastRefreshed: serverLastRefreshed)
					} else {
						complete(required: false, clientLastRefreshed: clientLastRefreshed, serverLastRefreshed: serverLastRefreshed)
					}
				} else {
					// first time app's art has every been refreshed
					complete(required: true, clientLastRefreshed: nil, serverLastRefreshed: serverLastRefreshed)
				}
			} else { // nothing back from query
				complete(required: false, clientLastRefreshed: nil, serverLastRefreshed: nil)
			}
		}
	}
	
	class func clientLastRefreshed() -> NSDate? {
		var lastRefresh: NSDate?
		if let date: NSDate? = NSUserDefaults.standardUserDefaults().valueForKey(UserDefaultKeys.LastPublicArtUpdate.rawValue) as? NSDate {
			lastRefresh = date
		}
		return lastRefresh
	}
	
	class func clientRefreshed(date: NSDate) {
		NSUserDefaults.standardUserDefaults().setValue(date, forKey: UserDefaultKeys.LastPublicArtUpdate.rawValue)
		NSUserDefaults.standardUserDefaults().synchronize()
	}
}