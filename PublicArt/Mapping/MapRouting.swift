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
	
	
	fileprivate func googleMapsAvailable() -> Bool {
		let can = UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!)
		return can
	}
	
	fileprivate func useAppleMaps() {
		let placemark: MKPlacemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), addressDictionary: [String(kABPersonAddressStreetKey) : artworkName])
		let artworkMapItem = MKMapItem(placemark: placemark)
		MKMapItem.openMaps(with: [artworkMapItem], launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeWalking])
	}
	
	fileprivate func useGoogleMaps() {
		let directionsRequest = "comgooglemaps://?daddr=" + "\(latitude)" + "," + "\(longitude)" + "&directionsmode=walking"
		if let directionsURL = URL(string: directionsRequest) {
			UIApplication.shared.openURL(directionsURL)
		}
	}
	
	
	func showAvailableAppsSheet(_ viewController: UIViewController, barButtonItem: UIBarButtonItem) {
		let appsSheet = UIAlertController(title: "Directions to Art", message: "Select App", preferredStyle: .actionSheet)
		appsSheet.popoverPresentationController?.barButtonItem = barButtonItem
		
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (alert) -> Void in
		}
		appsSheet.addAction(cancelAction)
		
		let routeWithAppleMapsAction = UIAlertAction(title: "Apple Maps", style: .default) {[weak self] (alert) -> Void in
			self?.useAppleMaps()
		}
		appsSheet.addAction(routeWithAppleMapsAction)
	
		if googleMapsAvailable() {
			let routeWithGoogleMapsAction = UIAlertAction(title: "Google Maps", style: .default) {[weak self] (alert) -> Void in
			self?.useGoogleMaps()
		}
			appsSheet.addAction(routeWithGoogleMapsAction)
		}
		
		viewController.present(appsSheet, animated: true) { () -> Void in
		}
	}

	
	
}
