//
//  WebService.swift
//  City Art San Francisco
//
//  Created by Michael Kinney on 11/24/14.
//  Copyright (c) 2014 mkinney. All rights reserved.
//
//  TODO: Error handling and recovery
//
import Foundation
//import AlamoFire
//import UIKit

struct WebServices {
	struct EndPoints {
		static let art = "/classes/art"
		static let latestUpdateTime = "/update" 
		static let login = "/login"
		static let locations = "/classes/locations"
		static let locationPhotos = "/classes/locationPhotos"
		static let photos = "/classes/photos"
		static let userMe = "/user/me"
		static let testObject = "/classes/TestObject"
	}
}

class WebService {

	struct WebService {
		static let baseURL = "https:api.parse.com/1"
	}

	struct Headers {
		static let serviceAppIdKey = ""
		static let serviceAppIdValue = ""
		static let serviceRestApiKey = ""
		static let serviceRestApiValue = ""
		static let sessionTokenKey = ""
		static let contentTypeKey =	""
	}
	
	struct Storage {
		static let sessionTokenKey = "sessionTokenKey"
		static let lastUpdateKey = "lastUpdateKey"
	}
	
	struct Pagination {
		static let limit = "500"
		static let skip = "0"
	}
	
	var headers:[String:String]
	var loggedIn:Bool {
		if let token = loadSessionToken() {
			return true;
		} else {
			return false;
		}
	}
	
	init() {
		headers = [Headers.serviceAppIdKey:Headers.serviceAppIdValue, Headers.serviceRestApiKey:Headers.serviceRestApiValue]
		if let token = self.loadSessionToken() {
			setTokenInHeader(token)
		}
//		Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders = headers
	}

	func logInUser(userName:String, password:String, completion:(success:Bool)-> ()) {
//		let URL = WebService.baseURL + WebServices.EndPoints.login + "/?"
//		Alamofire.request(.GET, URL,parameters:["username":userName, "password":password])
//			.responseJSON { (_, _, JSON, error) -> Void in
//				if(error == nil){
//					if let sessionToken = self.getTokenInResponse(JSON)? {
//						self.storeSessionToken(sessionToken)
//						self.setTokenInHeader(sessionToken)
//						Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders = self.headers
//					}
//					completion(success: true)
//				} else {
//					DLog("json processing error on log in \(error)")
//					completion(success: false)
//				}
//		}
	}
	
	func getNSData(url: String, complete:(data:NSData?) -> ()) {
//		Alamofire.request(.GET,url).response() {
//			(_,_,data,_) in
//			complete(data:data as? NSData) // TODO: test if data nil
//		}
	}
	
	func getNSData(photo: Photo,  complete:(photo: Photo, data:NSData?) -> ()) {
//		var url = photo.imageFileURL
//		Alamofire.request(.GET,url).response() {
//			(_,_,data,_) in
//			complete(photo: photo, data: data as? NSData) // TODO: test if data nil
//		}
	}
	
	func getJSON(endPoint: String, paginationLimit: String = Pagination.limit, skip: String = Pagination.skip, result: (json:AnyObject?) -> ()) {
		var url = WebService.baseURL + endPoint
//		Alamofire.request(.GET, url, parameters:["limit":paginationLimit,"skip":skip]) // TODO
//			     .responseJSON {(_, _, JSON, error) -> Void in
//						if(error == nil){
//							//println(JSON)
//							result(json:JSON)
//						} else {
//							DLog("getJSON error \(error)")
//							result(json:nil)
//						}
//					}
	}
	
	func updateAvailable(completion:(available:Bool) -> ()) {
		// TODO:
		completion(available:true)
	}
	
	// MARK: Private methods
	
	
	private func getTokenInResponse(json: AnyObject?) -> String? {
		let sJson = JSON(json!)
		return sJson["sessionToken"].stringValue
	}
	
	private func loadSessionToken() -> String? {
		var theToken:String?
		if let token = NSUserDefaults.standardUserDefaults().objectForKey(Storage.sessionTokenKey) as? String {
			theToken = token
		}
		return theToken
	}

	private func storeSessionToken(sessionToken:String) {
		NSUserDefaults.standardUserDefaults().setObject(sessionToken, forKey:Storage.sessionTokenKey)
	}
		
	private func setTokenInHeader(sessionToken:String) {
		headers[Headers.sessionTokenKey] = sessionToken
		
	}
	
	private func verifyToken(success:(good:Bool) ->()) {
//		Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders = headers
//		Alamofire.request(.GET, WebService.baseURL + WebServices.EndPoints.userMe)
//			.responseJSON { (_, _, JSON, error) -> Void in
//				if(error == nil){
//					success(good:true)
//				} else {
//					DLog("verifyToken error \(error)")
//					success(good:false)
//				}
//		}
//	}
}


//
//	func getJSONThumbs(endPoint: String, result: (json:AnyObject?) -> ()) {
//		var url = WebService.baseURL + endPoint
//		var thumbs = ["Garfield3.jpg","Cervantes3.jpg"]
//		var inThumbs = ["$in":["Garfield3.jpg","Cervantes3.jpg"]]
//		var thumbSearch = ["thumbFile":inThumbs]
//		Alamofire.request(.GET, url, parameters:["where":thumbSearch]) // TODO
//			.responseJSON {(_, _, JSON, error) -> Void in
//				if(error == nil){
//					//println(JSON)
//					result(json:JSON)
//				} else {
//					DLog("getJSON error \(error)")
//					result(json:nil)
//				}
//		}
//	}

// THIS WORKS
// parse format -data-urlencode 'where={"score":{"$in":[1,3,5,7,9]}}'
// working example :
//	func getJSONIn(endPoint: String, result: (json:AnyObject?) -> ()) {
//		var url = WebService.baseURL + endPoint
//		var thumbs = ["Garfield3.jpg","Cervantes3.jpg"]
//		var inThumbs = ["$in":thumbs]
//		var thumbSearch = ["thumbFile":inThumbs]
//		Alamofire.request(.GET, url, parameters:["where":thumbSearch]) // TODO
//			.responseJSON {(_, _, JSON, error) -> Void in
//				if(error == nil){
//					//println(JSON)
//					result(json:JSON)
//				} else {
//					DLog("getJSON error \(error)")
//					result(json:nil)
//				}
//		}
//	}

//	// --data-urlencode 'where={"score":{"$exists":true}}' \
//	// get a parse exception with this errorcode == 1, is a parse server error
//		func getJSONExisting(endPoint: String, result: (json:AnyObject?) -> ()) {
//			var url = WebService.baseURL + endPoint
//			var exists = ["$exists":false]
//			var thumbSearch = ["thumbFile":exists]
//			Alamofire.request(.GET, url, parameters:["where":thumbSearch]) // TODO
//				.responseJSON {(_, _, JSON, error) -> Void in
//					if(error == nil){
//						result(json:JSON) // TODO: may sure content is not actually an parse.com response error !!
//					} else {
//						DLog("getJSON error \(error)")
//						result(json:nil)
//					}
//			}
//		}


// WORKS

//	func getJSONThumbsOneThumb(endPoint: String, result: (json:AnyObject?) -> ()) {
//		var url = WebService.baseURL + endPoint
//		var a = ["thumbFile":"Garfield3.jpg"]
//		Alamofire.request(.GET, url, parameters:["where":a]) // TODO
//			.responseJSON {(_, _, JSON, error) -> Void in
//				if(error == nil){
//					//println(JSON)
//					result(json:JSON)
//				} else {
//					DLog("getJSON error \(error)")
//					result(json:nil)
//				}
//		}
//	}
//

}
