//
//  CityMapsViewController.swift
//  City Art San Francisco
//
//  Created by Michael Kinney on 12/19/14.
//  Copyright (c) 2014 mkinney. All rights reserved.
//
// TODO: need a debug bit to show all art, regardless of photos

import UIKit
import CoreData
import MapKit

final class CityMapsViewController: UIViewController, NSFetchedResultsControllerDelegate {

	@IBOutlet weak var mapView: MKMapView!
	@IBOutlet weak var toolbar: UIToolbar!
	
	private let annotationViewId = "annotationViewId"
	private var art: [Art]?
	private var error:NSError?
	var location: Location?
	private var moc: NSManagedObjectContext?
	private var zoomed = false

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
	
	private var firstViewAppearance = true
	
	var flexibleSpaceBarButtonItem: UIBarButtonItem {
		return UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
	}
	
	var fixedSpaceBarButtonItem: UIBarButtonItem {
		let item = UIBarButtonItem(barButtonSystemItem: .FixedSpace , target: nil, action: nil)
		item.width = 30
		return item
	}
	
	var infoBarButtonItem: UIBarButtonItem {
		let image = UIImage(named: "toolbar-infoButton")
		return UIBarButtonItem(image:image, style: .Plain, target:self, action: "onInfoButton:")
	}
	
	var locateMeBarButtonItem: UIBarButtonItem?
	
	func showArtFor(location: Location, onlyHavingPhotos: Bool) {
		if self.isViewLoaded() {  // TODO?
			updateMapAnnotations()
			mapView.setCenterCoordinate(mapCoordinates(), animated: true)
		}
	}

	
	required init?(coder aDecoder: NSCoder) {
		moc = CoreDataStack.sharedInstance.managedObjectContext
		super.init(coder: aDecoder)
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		mapView.delegate = self
		mapView.mapType = getSavedMapType()
		prepareToolbarItems()
		
		self.title = "Explore"
		
		fetchResultsController.delegate = self
		do {
			try fetchResultsController.performFetch()
		} catch let error1 as NSError {
			error = error1
		}
		self.art = fetchResultsController.fetchedObjects as? [Art]
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		mapView.mapType = getSavedMapType()
		if self.traitCollection.verticalSizeClass == .Regular {
			self.toolbar.hidden = false
		} else {
			self.toolbar.hidden = true
		}

		if firstViewAppearance { // do not unexpectedly move map when user moves between tabs
			firstViewAppearance = false
			updateMapAnnotations()
			zoomToRegion()
		}
	}
	
	
	// MARK: prep
	
	func prepareToolbarItems() {
		let image = UIImage(named: "toolbar-arrow") // TODO: replace with my own artwork
		locateMeBarButtonItem =   UIBarButtonItem(image:image, style: .Plain, target:self, action: "onLocateMeButton:")
	
		let items = [locateMeBarButtonItem!, flexibleSpaceBarButtonItem, infoBarButtonItem]
		toolbar.items = items
	}
	
	// MARK: Fetch Results Controller
	//
	lazy var fetchResultsController:NSFetchedResultsController = {
		let fetchRequest = NSFetchRequest(entityName:ModelEntity.art)
		
		if let location = self.location {
			fetchRequest.predicate = NSPredicate(format:"%K == %@", "idLocation", location.idLocation) // TODO: define
		}
		
		let sortDescriptor = [NSSortDescriptor(key:ModelAttributes.artworkTitle, ascending:true, selector: "localizedStandardCompare:")]
		fetchRequest.sortDescriptors = sortDescriptor
		let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.moc!, sectionNameKeyPath: nil, cacheName: nil)
		return frc
	}()
	
	func controllerDidChangeContent(controller: NSFetchedResultsController) {
	// TODO	collectionView?.reloadData()
	}

	// view transistioning
	
	override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
		super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
		if traitCollection.userInterfaceIdiom == .Phone {
			let hidden = self.toolbar?.hidden ?? true
			self.toolbar?.hidden = !hidden // prevent flash on size class change
		}
		coordinator.animateAlongsideTransitionInView(view, animation: { (context) -> Void in
			}) { (context) -> Void in
				if self.traitCollection.verticalSizeClass == .Regular {
					self.toolbar?.hidden = false
				} else {
					self.toolbar?.hidden = true
				}
		}
	}


	// MARK: mapping
	
	private func buildAnnotations() -> [ArtMapAnnotation] {
		var annotations = [ArtMapAnnotation]()
		if let art = self.art {
			for art in art {
				annotations += [ArtMapAnnotation(art: art)]
			}
		}
		return annotations
	}
	
	private func mapCoordinates() -> CLLocationCoordinate2D {
		var coordinates = CLLocationCoordinate2D(latitude: ArtCityMap.centerLatitude , longitude: ArtCityMap.centerLongitude )
		// TODO tweak location for art city center
		if let location = location {
			let latitude = location.latitude.doubleValue
			let longitude = location.longitude.doubleValue
			coordinates = CLLocationCoordinate2D(latitude:latitude, longitude: longitude)
		}
		return coordinates
	}
	
	private func updateMapAnnotations() {
		let oldAnnotations = mapView.annotations
		mapView.removeAnnotations(oldAnnotations)
		let newAnnotations = buildAnnotations()
		mapView.addAnnotations(newAnnotations)
	}
	
//	private func updateMapLocation() {
////		zoomToRegion(latitude: 0.010, longitude: 0.010)
//		zoomToRegion()
////		mapView.setCenterCoordinate(mapCoordinates(), animated: true)
//	}

	func zoomToRegion() {
		if !zoomed {
			let coordinates = mapCoordinates()
			mapView.setCenterCoordinate(coordinates, animated: true)
			let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1) // TODO:
			let region = MKCoordinateRegion(center:coordinates, span:span)
			mapView?.setRegion(region, animated: false)
			zoomed = true;
		}
	}
	
	
	// MARK: actions
	
	func onLocateMeButton(barbuttonItem: UIBarButtonItem ) {
		artUserLocation.toggleShowUserLocation()
	}
	
	func onInfoButton(barButtonItem: UIBarButtonItem) {
		showInfoSheet(barButtonItem)
	}
	
	func showInfoSheet(barButtonItem: UIBarButtonItem) {
		let infoSheet = UIAlertController(title: "Select Map Type", message: "", preferredStyle: .ActionSheet)
		infoSheet.popoverPresentationController?.barButtonItem = barButtonItem
		
		let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (alert) -> Void in
		}
		let mapStandardAction = UIAlertAction(title: "Standard", style: .Default) { (alert) -> Void in
			self.mapView.mapType = .Standard
			self.saveMapType(self.mapView.mapType)
		}
		let mapHybridAction = UIAlertAction(title: "Hybrid", style: .Default) { (alert) -> Void in
			self.mapView.mapType = .Hybrid
			self.saveMapType(self.mapView.mapType)
		}
		let mapSatelliteAction = UIAlertAction(title: "Satellite", style: .Default) { (alert) -> Void in
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
		NSUserDefaults.standardUserDefaults().setObject(codedType, forKey: "CityMapsType")
	}
	
	func getSavedMapType() -> MKMapType {
		var mapType: MKMapType = .Standard
		let userDefaults = NSUserDefaults.standardUserDefaults
		if let codedType = userDefaults().objectForKey("CityMapsType") as? String {
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
	
	
	// MARK: miscellaneous
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		print("\(__FILE__) did receive memory warning")
	}
}

extension CityMapsViewController : MKMapViewDelegate, UIPopoverPresentationControllerDelegate {

	func adaptivePresentationStyleForPresentationController(
		controller: UIPresentationController) -> UIModalPresentationStyle {
		return UIModalPresentationStyle.None
	}

	func displayArtSummaryViewControllerAt(popoverAnchor: UIView, art: Art) {
		let singleArtSummaryViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SingleArtSummaryViewController") as! SingleArtSummaryViewController
		singleArtSummaryViewController.modalPresentationStyle = .Popover
		singleArtSummaryViewController.art = art
		if let popoverPresentationController = singleArtSummaryViewController.popoverPresentationController {
			popoverPresentationController.sourceView = popoverAnchor
			popoverPresentationController.sourceRect = popoverAnchor.frame
			popoverPresentationController.permittedArrowDirections = .Any
			popoverPresentationController.delegate = self
			presentViewController(singleArtSummaryViewController, animated: true, completion: { () -> Void in
				
			})
			
		}
	}

	func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
		if let annotation = view.annotation as? ArtMapAnnotation {
			if let art = annotation.art {
	//			if let rightCalloutAccessoryView = view.rightCalloutAccessoryView {
	//				displayArtSummaryViewControllerAt(view.rightCalloutAccessoryView, art: art)
					let singleArtViewController: SingleArtViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(ViewControllerIdentifier.SingleArtViewController.rawValue) as! SingleArtViewController
					singleArtViewController.update(art, artBackgroundColor: nil)
					showViewController(singleArtViewController, sender: self)
	//			}
			}
		}		
	}
	
	func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
		if  let imageView = view.leftCalloutAccessoryView as? UIImageView,
		    let annotation = view.annotation as? ArtMapAnnotation,
			let art = annotation.art {
			ImageDownload.downloadThumb(art, complete: { (data, imageFileName) -> () in
				if let data = data	{
						imageView.image = UIImage(data: data) ?? UIImage()
				}
			})
		}
	}

	func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
		if let _  = annotation as? MKUserLocation {
			return nil
		}
		
		if let annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(annotationViewId) as? MKArtAnnotationView {
			annotationView.annotation = annotation
			annotationView.updateImage()
			return annotationView
		} else {
			let annotationView = MKArtAnnotationView(annotation: annotation, reuseIdentifier: annotationViewId)
			annotationView.canShowCallout = true
			annotationView.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
			// TODO: TAP ON IMAGE TO SHOW POPOVER
			annotationView.leftCalloutAccessoryView = UIImageView(frame: CGRect(origin: CGPointZero, size: CGSize(width:40, height:40)))
			return annotationView
		}
	}
	
}

extension CityMapsViewController {
		override func collapseSecondaryViewController(secondaryViewController: UIViewController, forSplitViewController splitViewController: UISplitViewController) {
//			println("CityMapsViewController collapse")
			super.collapseSecondaryViewController(secondaryViewController, forSplitViewController: splitViewController)
		}
}


