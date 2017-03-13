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
	
	class func artRefreshFromServerRequired(_ complete:@escaping (_ required: Bool, _ clientLastRefreshed: Date?, _ serverLastRefreshed: Date?) ->() ) {
        // first time app's art has every been refreshed
        complete(true, nil, Date.init()) // TODO: remove today's date just for debugging
        
//		let clientLastRefreshed: Date? = ArtRefresh.clientLastRefreshed()
//		ParseWebService.getPublicArtRefresh {(parseRefresh) -> Void in
//			if let serverLastRefreshed = parseRefresh?.last?.lastRefresh {
//				if let clientLastRefreshed = clientLastRefreshed {
//					if clientLastRefreshed != serverLastRefreshed as Date{
//						complete(true, clientLastRefreshed, serverLastRefreshed as Date)
//					} else {
//						complete(false, clientLastRefreshed, serverLastRefreshed as Date)
//					}
//				} else {
//					// first time app's art has every been refreshed
//					complete(true, nil, serverLastRefreshed as Date)
//				}
//			} else { // nothing back from query
//				complete(false, nil, nil)
//			}
//		}
	}
	
	class func clientLastRefreshed() -> Date? {
		var lastRefresh: Date?
		if let date = UserDefaults.standard.value(forKey: UserDefaultKeys.LastPublicArtUpdate.rawValue) as? Date {
			lastRefresh = date
		}
		return lastRefresh
	}
	
	class func clientRefreshed(_ date: Date) {
		UserDefaults.standard.setValue(date, forKey: UserDefaultKeys.LastPublicArtUpdate.rawValue)
		UserDefaults.standard.synchronize()
	}
}
