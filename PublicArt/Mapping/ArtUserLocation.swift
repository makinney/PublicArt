//
//  ArtUserLocation.swift
//  City Art San Francisco
//
//  Created by Michael Kinney on 1/12/15.
//  Copyright (c) 2015 mkinney. All rights reserved.
//

import Foundation
import MapKit

class ArtUserLocation: NSObject {

	private var checkZoomRequired = true
	private var mapView: MKMapView?
	private var trackingUserLocation = false
	var trackingCallback: ((trackingState: Bool) -> ())?
	
	lazy var locationManager: CLLocationManager = {
		var manager = CLLocationManager()
		manager.desiredAccuracy = kCLLocationAccuracyBest
		manager.distanceFilter = 1.0 // TODO: constant
		return manager
	}()
	
	init(mapView: MKMapView) {
		super.init()
		locationManager.delegate = self
		self.mapView = mapView
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "didEnterBackground", name: UIApplicationDidEnterBackgroundNotification, object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "willEnterForeground", name: UIApplicationWillEnterForegroundNotification, object: nil)
	}
	
	deinit {
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}
	
	func didEnterBackground() {
		if trackingUserLocation {
			locationManager.stopUpdatingLocation()
		}
	}
	
	func willEnterForeground() {
		if trackingUserLocation {
			locationManager.startUpdatingLocation()
		}
	}
	
	func toggleShowUserLocation() {
		
		if !trackingUserLocation {
				self.startUpdating()
			} else {
				self.stopUpdating()
		}
		
		if !havePermission() {
			promptForPermissionPermitted()
			return
		}
	}
	
	func startUpdating() {
		mapView?.showsUserLocation = true
		trackingUserLocation = true
		checkZoomRequired = true
		locationManager.startUpdatingLocation()
		tracking(trackingUserLocation)
	}
	
	func stopUpdating() {
		mapView?.showsUserLocation = false;
		trackingUserLocation = false
		locationManager.stopUpdatingLocation()
		tracking(trackingUserLocation)
	}
	
	func tracking(state: Bool){
		trackingCallback?(trackingState:state)
	}
	
	func havePermission() -> Bool {
		var permission = false
		var status =  CLLocationManager.authorizationStatus()
		if status == .AuthorizedAlways || status == .AuthorizedWhenInUse {
			permission = true
		}
		return permission
	}
	
	func promptForPermissionPermitted()  {
		locationManager.requestWhenInUseAuthorization()
	}
	
	func zoomUser(coordinates: CLLocationCoordinate2D) {
		mapView?.setCenterCoordinate(coordinates, animated: true)
		var span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01) // TODO:
		var region = MKCoordinateRegion(center:coordinates, span:span)
		mapView?.setRegion(region, animated: true)
	}
	
}

extension ArtUserLocation: CLLocationManagerDelegate {

	 func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
		if let userLocation = mapView?.userLocation {
			if userLocation.coordinate.latitude != 0.0 && userLocation.coordinate.longitude != 0.0 {
				if checkZoomRequired { // && mapView?.userLocationVisible == false   {
					zoomUser(userLocation.coordinate)
					checkZoomRequired = false // so map does not keep centering
				}
			}
		}
	}
	
	func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
		if error.domain == kCLErrorDomain {
			if error.code == CLError.Denied.rawValue {
				stopUpdating()
			}
		}
	}
	
}





