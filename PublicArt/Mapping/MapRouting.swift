//
//  MapRouting.swift
//  PublicArt
//
//  Created by Michael Kinney on 7/20/15.
//  Copyright (c) 2015 makinney. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import AddressBook

final class MapRouting {

	let latitude: Double
	let longitude: Double
	let artworkName: String
	
	init(art: Art) {
		latitude = art.latitude.doubleValue
		longitude = art.longitude.doubleValue
		artworkName = art.title
	}
	
	
	private func googleMapsAvailable() -> Bool {
		return UIApplication.sharedApplication().canOpenURL(NSURL(string: "comgooglemaps://")!)
	}
	
	private func useAppleMaps() {
		let placemark: MKPlacemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), addressDictionary: [String(kABPersonAddressStreetKey) : artworkName])
		let artworkMapItem = MKMapItem(placemark: placemark)
		MKMapItem.openMapsWithItems([artworkMapItem], launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeWalking])
	}
	
	private func useGoogleMaps() {
		let directionsRequest = "comgooglemaps://?daddr=" + "\(latitude)" + "," + "\(longitude)" + "&directionsmode=walking"
		if let directionsURL = NSURL(string: directionsRequest) {
			UIApplication.sharedApplication().openURL(directionsURL)
		}
	}
	
	
	func showAvailableAppsSheet(viewController: UIViewController, barButtonItem: UIBarButtonItem) {
		let appsSheet = UIAlertController(title: "Directions to Art", message: "Select App", preferredStyle: .ActionSheet)
		appsSheet.popoverPresentationController?.barButtonItem = barButtonItem
		
		let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (alert) -> Void in
		}
		appsSheet.addAction(cancelAction)
		
		let routeWithAppleMapsAction = UIAlertAction(title: "Apple Maps", style: .Default) {[weak self] (alert) -> Void in
			self?.useAppleMaps()
		}
		appsSheet.addAction(routeWithAppleMapsAction)
	
		if googleMapsAvailable() {
			let routeWithGoogleMapsAction = UIAlertAction(title: "Google Maps", style: .Default) {[weak self] (alert) -> Void in
			self?.useGoogleMaps()
		}
		
		appsSheet.addAction(routeWithGoogleMapsAction)
		
		}
		
		viewController.presentViewController(appsSheet, animated: true) { () -> Void in
		}
	}

	
	
}
