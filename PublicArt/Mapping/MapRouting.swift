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
import Contacts

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
		let placemark: MKPlacemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), addressDictionary: [String(CNPostalAddressStreetKey) : artworkName])
		let artworkMapItem = MKMapItem(placemark: placemark)
		MKMapItem.openMaps(with: [artworkMapItem], launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeWalking])
	}
	
	fileprivate func useGoogleMaps() {
		let directionsRequest = "comgooglemaps://?daddr=" + "\(latitude)" + "," + "\(longitude)" + "&directionsmode=walking"
		if let directionsURL = URL(string: directionsRequest) {
			UIApplication.shared.openURL(directionsURL)
		}
	}
	
	
	func showRoutingMap() {		
		if googleMapsAvailable() {
            useGoogleMaps()

        } else {
            useAppleMaps()
        }
	}

	
}
