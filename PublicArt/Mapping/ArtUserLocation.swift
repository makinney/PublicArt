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

	fileprivate var checkZoomRequired = true
	fileprivate var mapView: MKMapView?
	fileprivate var trackingUserLocation = false
	var trackingCallback: ((_ trackingState: Bool) -> ())?
	
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
		NotificationCenter.default.addObserver(self, selector: #selector(ArtUserLocation.didEnterBackground), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(ArtUserLocation.willEnterForeground), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
	}
	
	deinit {
		NotificationCenter.default.removeObserver(self)
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
	
	func tracking(_ state: Bool){
		trackingCallback?(state)
	}
	
	func havePermission() -> Bool {
		var permission = false
		let status =  CLLocationManager.authorizationStatus()
		if status == .authorizedAlways || status == .authorizedWhenInUse {
			permission = true
		}
		return permission
	}
	
	func promptForPermissionPermitted()  {
		locationManager.requestWhenInUseAuthorization()
	}
	
	func zoomUser(_ coordinates: CLLocationCoordinate2D) {
		mapView?.setCenter(coordinates, animated: true)
		let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01) // TODO:
		let region = MKCoordinateRegion(center:coordinates, span:span)
		mapView?.setRegion(region, animated: true)
	}
	
}

extension ArtUserLocation: CLLocationManagerDelegate {

	 func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		if let userLocation = mapView?.userLocation {
			if userLocation.coordinate.latitude != 0.0 && userLocation.coordinate.longitude != 0.0 {
				if checkZoomRequired { // && mapView?.userLocationVisible == false   {
					zoomUser(userLocation.coordinate)
					checkZoomRequired = false // so map does not keep centering
				}
			}
		}
	}
	
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) { // FIXME: how to use error?
        stopUpdating()
    }
   	
}





