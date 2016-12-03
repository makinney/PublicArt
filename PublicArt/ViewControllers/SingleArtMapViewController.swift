//
//  SingleArtMapViewController
//  City Art San Francisco
//
//  Created by Michael Kinney on 12/29/14.
//  Copyright (c) 2014 mkinney. All rights reserved.
//


import UIKit
import MapKit

final class SingleArtMapViewController : UIViewController {
	
	@IBOutlet weak var bottomToolbar: UIToolbar!
	@IBOutlet weak var containerView: UIView!
	@IBOutlet weak var mapView: MKMapView!
	@IBOutlet weak var topToolbar: UIToolbar!

	fileprivate let annotationViewId = "annotationViewId"
	var art:Art?
	fileprivate var mapRouting: MapRouting?
	
	lazy var artMapAnnotation:ArtMapAnnotation = {
			ArtMapAnnotation(art: self.art!)
		}()
	
	fileprivate lazy var artUserLocation: ArtUserLocation = {
		var userLocation = ArtUserLocation(mapView: self.mapView)
		userLocation.trackingCallback = {(tracking) ->() in
			if tracking {
				let image = UIImage(named: "toolbar-location_arrow_filled")
				self.locateMeBarButtonItem?.image = image
			} else {
				let image = UIImage(named: "toolbar-arrow")
				self.locateMeBarButtonItem?.image = image
			}
		}
		return userLocation
	}()
	
	var doneBarButtonItem: UIBarButtonItem {
		return UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(SingleArtMapViewController.onDoneButton(_:)))
	}
	
	var routeBarButtonItem: UIBarButtonItem {
		let image = UIImage(named: "DirectionsArrow")
		return UIBarButtonItem(image:image, style: .plain, target:self, action: #selector(SingleArtMapViewController.onRouteButton(_:)))

	}
	var flexibleSpaceBarButtonItem: UIBarButtonItem {
		return UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
	}

	var infoBarButtonItem: UIBarButtonItem {
		let image = UIImage(named: "toolbar-infoButton")
		return UIBarButtonItem(image:image, style: .plain, target:self, action: #selector(SingleArtMapViewController.onInfoButton(_:)))
	}
	
	var locateMeBarButtonItem: UIBarButtonItem?



	// MARK: lifecycle

//	override init() {
//		super.init()
//	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		mapView.delegate = self
		mapView.mapType = getSavedMapType()
		containerView.sendSubview(toBack: mapView)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		prepareToolbarItems()
		zoomToRegion()
		mapView.addAnnotation(artMapAnnotation)
	}
	
	func dismiss() {
		self.dismiss(animated: true, completion:nil)
	}
	
	// MARK: preps
	
	func prepareToolbarItems() {
		let image = UIImage(named: "toolbar-arrow")
		locateMeBarButtonItem = UIBarButtonItem(image:image, style: .plain, target:self, action: #selector(SingleArtMapViewController.onLocateMeButton(_:)))
		let bottomItems = [locateMeBarButtonItem!, flexibleSpaceBarButtonItem, infoBarButtonItem]
		bottomToolbar.items = bottomItems
		let topItems = [routeBarButtonItem, flexibleSpaceBarButtonItem, doneBarButtonItem]
		topToolbar.items = topItems
	}

	// MARK: Mapping
	
	fileprivate func mapCoordinates() -> CLLocationCoordinate2D {
		var coordinates = CLLocationCoordinate2D(latitude: ArtCityMap.centerLatitude , longitude: ArtCityMap.centerLongitude )
		if let art = art {
			let latitude = art.latitude.doubleValue
			let longitude = art.longitude.doubleValue
			coordinates = CLLocationCoordinate2D(latitude:latitude, longitude: longitude)
		}
		return coordinates
	}
	
	func zoomToRegion() {
		if let _ = art {
			let span = MKCoordinateSpan(latitudeDelta: 0.010, longitudeDelta: 0.010) // TODO:
			let region = MKCoordinateRegion(center:mapCoordinates(), span:span)
			mapView?.setRegion(region, animated: false)
		}
	}

	// MARK: button actions

	func onDoneButton(_ barbuttonItem: UIBarButtonItem) {
		dismiss()
	}
	
	func onRouteButton(_ barButtonItem: UIBarButtonItem) {
		if let art = self.art {
			mapRouting = MapRouting(art: art)
			mapRouting?.showAvailableAppsSheet(self, barButtonItem: barButtonItem)
		}
	}

	func onLocateMeButton(_ barbuttonItem: UIBarButtonItem ) {
		artUserLocation.toggleShowUserLocation()
	}
	
	func onInfoButton(_ barButtonItem: UIBarButtonItem) {
		showInfoSheet(barButtonItem)
	}
	
	func showInfoSheet(_ barButtonItem: UIBarButtonItem) {
		let infoSheet = UIAlertController(title: "Select Map Type", message: "", preferredStyle: .actionSheet)
		infoSheet.popoverPresentationController?.barButtonItem = barButtonItem
	
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (alert) -> Void in
		}
		let mapStandardAction = UIAlertAction(title: "Standard", style: .default) { (alert) -> Void in
			self.mapView.mapType = .standard
			self.saveMapType(self.mapView.mapType)
		}
		let mapHybridAction = UIAlertAction(title: "Hybrid", style: .default) { (alert) -> Void in
			self.mapView.mapType = .hybrid
			self.saveMapType(self.mapView.mapType)
		}
		let mapSatelliteAction = UIAlertAction(title: "Satellite", style: .default) { (alert) -> Void in
			self.mapView.mapType = .satellite
			self.saveMapType(self.mapView.mapType)
		}
		
		infoSheet.addAction(cancelAction)
		infoSheet.addAction(mapStandardAction)
		infoSheet.addAction(mapHybridAction)
		infoSheet.addAction(mapSatelliteAction)
		
		present(infoSheet, animated: true) { () -> Void in
		}
	}
	
	// MARK: Map Persistance
	
	func saveMapType(_ type: MKMapType) {
		var codedType: String = "Standard"
		switch (type) {
		case .standard:
			codedType = "Standard"
		case .hybrid:
			codedType = "Hybrid"
		case .satellite:
			codedType = "Satellite"
		default:
			codedType = "Standard"
		}
		UserDefaults.standard.set(codedType, forKey: "SingleArtMapType")
	}
	
	func getSavedMapType() -> MKMapType {
		var mapType: MKMapType = .standard
		let userDefaults = UserDefaults.standard
		if let codedType = userDefaults.object(forKey: "SingleArtMapType") as? String {
			switch (codedType) {
			case "Standard":
				mapType = .standard
			case "Hybrid":
				mapType = .hybrid
			case "Satellite":
				mapType = .satellite
			default:
				mapType = .standard
			}
		}
		return mapType
	}
	
}

extension SingleArtMapViewController : MKMapViewDelegate {

	func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
		if let annotation = view.annotation as? ArtMapAnnotation {
			if let art = annotation.art {
				print("art name is \(art.title)")
			}
		}
	}
	
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		if let _ = annotation as? MKUserLocation {
			return nil
		}
	
		if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationViewId) {
			annotationView.annotation = annotation
			return annotationView
		} else {
			let annotationView = MKArtAnnotationView(annotation: annotation, reuseIdentifier: annotationViewId)
			annotationView.canShowCallout = true
			// annotationView.rightCalloutAccessoryView = UIButton.buttonWithType(.DetailDisclosure) as UIButton
			return annotationView
		}
	}
}

