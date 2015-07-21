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

	private let annotationViewId = "annotationViewId"
	var art:Art?
	private var mapRouting: MapRouting?
	
	lazy var artMapAnnotation:ArtMapAnnotation = {
			ArtMapAnnotation(art: self.art!)
		}()
	
	private lazy var artUserLocation: ArtUserLocation = {
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
		return UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "onDoneButton:")
	}
	
	var routeBarButtonItem: UIBarButtonItem {
		let image = UIImage(named: "DirectionsArrow")
		return UIBarButtonItem(image:image, style: .Plain, target:self, action: "onRouteButton:")

	}
	var flexibleSpaceBarButtonItem: UIBarButtonItem {
		return UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
	}

	var infoBarButtonItem: UIBarButtonItem {
		let image = UIImage(named: "toolbar-infoButton")
		return UIBarButtonItem(image:image, style: .Plain, target:self, action: "onInfoButton:")
	}
	
	var locateMeBarButtonItem: UIBarButtonItem?



	// MARK: lifecycle

//	override init() {
//		super.init()
//	}
	
	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		mapView.delegate = self
		mapView.mapType = getSavedMapType()
		containerView.sendSubviewToBack(mapView)
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		prepareToolbarItems()
		zoomToRegion()
		mapView.addAnnotation(artMapAnnotation)
	}
	
	func dismiss() {
		dismissViewControllerAnimated(true, completion:nil)
	}
	
	// MARK: preps
	
	func prepareToolbarItems() {
		let image = UIImage(named: "toolbar-arrow")
		locateMeBarButtonItem = UIBarButtonItem(image:image, style: .Plain, target:self, action: "onLocateMeButton:")
		let bottomItems = [locateMeBarButtonItem!, flexibleSpaceBarButtonItem, infoBarButtonItem]
		bottomToolbar.items = bottomItems
		let topItems = [routeBarButtonItem, flexibleSpaceBarButtonItem, doneBarButtonItem]
		topToolbar.items = topItems
	}

	// MARK: Mapping
	
	private func mapCoordinates() -> CLLocationCoordinate2D {
		var coordinates = CLLocationCoordinate2D(latitude: ArtCityMap.centerLatitude , longitude: ArtCityMap.centerLongitude )
		if let art = art {
			var latitude = art.latitude.doubleValue
			var longitude = art.longitude.doubleValue
			coordinates = CLLocationCoordinate2D(latitude:latitude, longitude: longitude)
		}
		return coordinates
	}
	
	func zoomToRegion() {
		if let art = art {
			var span = MKCoordinateSpan(latitudeDelta: 0.010, longitudeDelta: 0.010) // TODO:
			var region = MKCoordinateRegion(center:mapCoordinates(), span:span)
			mapView?.setRegion(region, animated: false)
		}
	}

	// MARK: button actions

	func onDoneButton(barbuttonItem: UIBarButtonItem) {
		dismiss()
	}
	
	func onRouteButton(barButtonItem: UIBarButtonItem) {
		if let art = self.art {
			mapRouting = MapRouting(art: art)
			mapRouting?.showAvailableAppsSheet(self, barButtonItem: barButtonItem)
		}
	}

	func onLocateMeButton(barbuttonItem: UIBarButtonItem ) {
		artUserLocation.toggleShowUserLocation()
	}
	
	func onInfoButton(barButtonItem: UIBarButtonItem) {
		showInfoSheet(barButtonItem)
	}
	
	func showInfoSheet(barButtonItem: UIBarButtonItem) {
		var infoSheet = UIAlertController(title: "Select Map Type", message: "", preferredStyle: .ActionSheet)
		infoSheet.popoverPresentationController?.barButtonItem = barButtonItem
	
		var cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (alert) -> Void in
		}
		var mapStandardAction = UIAlertAction(title: "Standard", style: .Default) { (alert) -> Void in
			self.mapView.mapType = .Standard
			self.saveMapType(self.mapView.mapType)
		}
		var mapHybridAction = UIAlertAction(title: "Hybrid", style: .Default) { (alert) -> Void in
			self.mapView.mapType = .Hybrid
			self.saveMapType(self.mapView.mapType)
		}
		var mapSatelliteAction = UIAlertAction(title: "Satellite", style: .Default) { (alert) -> Void in
			self.mapView.mapType = .Satellite
			self.saveMapType(self.mapView.mapType)
		}
		
		infoSheet.addAction(cancelAction)
		infoSheet.addAction(mapStandardAction)
		infoSheet.addAction(mapHybridAction)
		infoSheet.addAction(mapSatelliteAction)
		
		presentViewController(infoSheet, animated: true) { () -> Void in
		}
	}
	
	// MARK: Map Persistance
	
	func saveMapType(type: MKMapType) {
		var codedType: String = "Standard"
		switch (type) {
		case .Standard:
			codedType = "Standard"
		case .Hybrid:
			codedType = "Hybrid"
		case .Satellite:
			codedType = "Satellite"
		default:
			codedType = "Standard"
		}
		NSUserDefaults.standardUserDefaults().setObject(codedType, forKey: "SingleArtMapType")
	}
	
	func getSavedMapType() -> MKMapType {
		var mapType: MKMapType = .Standard
		var userDefaults = NSUserDefaults.standardUserDefaults
		if let codedType = userDefaults().objectForKey("SingleArtMapType") as? String {
			switch (codedType) {
			case "Standard":
				mapType = .Standard
			case "Hybrid":
				mapType = .Hybrid
			case "Satellite":
				mapType = .Satellite
			default:
				mapType = .Standard
			}
		}
		return mapType
	}
	
}

extension SingleArtMapViewController : MKMapViewDelegate {

	func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
		if let annotation = view.annotation as? ArtMapAnnotation {
			if let art = annotation.art {
				println("art name is \(art.title)")
			}
		}
	}
	
	func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
		if let annotation = annotation as? MKUserLocation {
			return nil
		}
	
		if let annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(annotationViewId) {
			annotationView.annotation = annotation
			return annotationView
		} else {
			var annotationView = MKArtAnnotationView(annotation: annotation, reuseIdentifier: annotationViewId)
			annotationView.canShowCallout = true
			// annotationView.rightCalloutAccessoryView = UIButton.buttonWithType(.DetailDisclosure) as UIButton
			return annotationView
		}
	}
}

