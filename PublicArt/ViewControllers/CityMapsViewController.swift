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
	
	fileprivate let annotationViewId = "annotationViewId"
	fileprivate var art: [Art]?
	fileprivate var error:NSError?
	var location: Location?
	fileprivate var moc: NSManagedObjectContext?
	fileprivate var zoomed = false


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
	
	fileprivate var firstViewAppearance = true
	
	var flexibleSpaceBarButtonItem: UIBarButtonItem {
		return UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
	}
	
	var fixedSpaceBarButtonItem: UIBarButtonItem {
		let item = UIBarButtonItem(barButtonSystemItem: .fixedSpace , target: nil, action: nil)
		item.width = 30
		return item
	}
	
	var infoBarButtonItem: UIBarButtonItem {
		let image = UIImage(named: "toolbar-infoButton")
		return UIBarButtonItem(image:image, style: .plain, target:self, action: #selector(CityMapsViewController.onInfoButton(_:)))
	}
	
	var locateMeBarButtonItem: UIBarButtonItem?
	
	func showArtFor(_ location: Location, onlyHavingPhotos: Bool) {
		if self.isViewLoaded {  // TODO?
			updateMapAnnotations()
			mapView.setCenter(mapCoordinates(), animated: true)
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
            self.art = fetchResultsController.fetchedObjects
		} catch let error1 as NSError {
			error = error1
		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		mapView.mapType = getSavedMapType()
		if self.traitCollection.verticalSizeClass == .regular {
			self.toolbar.isHidden = false
		} else {
			self.toolbar.isHidden = true
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
		locateMeBarButtonItem =   UIBarButtonItem(image:image, style: .plain, target:self, action: #selector(CityMapsViewController.onLocateMeButton(_:)))
	
		let items = [locateMeBarButtonItem!, flexibleSpaceBarButtonItem, infoBarButtonItem]
		toolbar.items = items
	}
	
	// MARK: Fetch Results Controller
	//
	lazy var fetchResultsController:NSFetchedResultsController<Art> = { 
		let fetchRequest = NSFetchRequest<Art>(entityName:ModelEntity.art)
		
		if let location = self.location {
			fetchRequest.predicate = NSPredicate(format:"%K == %@", "idLocation", location.idLocation) // TODO: define
		}
		
        let sortDescriptor = [NSSortDescriptor(key:ModelAttributes.artworkTitle, ascending:true, selector: #selector(NSString.localizedStandardCompare(_:)))]
		fetchRequest.sortDescriptors = sortDescriptor
		let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.moc!, sectionNameKeyPath: nil, cacheName: nil)
		return frc
	}()
	
	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
	// TODO	collectionView?.reloadData()
	}

	// view transistioning
	
	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		super.viewWillTransition(to: size, with: coordinator)
		if traitCollection.userInterfaceIdiom == .phone {
			let hidden = self.toolbar?.isHidden ?? true
			self.toolbar?.isHidden = !hidden // prevent flash on size class change
		}
		coordinator.animateAlongsideTransition(in: view, animation: { (context) -> Void in
			}) { (context) -> Void in
				if self.traitCollection.verticalSizeClass == .regular {
					self.toolbar?.isHidden = false
				} else {
					self.toolbar?.isHidden = true
				}
		}
	}


	// MARK: mapping
	
	fileprivate func buildAnnotations() -> [ArtMapAnnotation] {
		var annotations = [ArtMapAnnotation]()
		if let art = self.art {
			for art in art {
				annotations += [ArtMapAnnotation(art: art)]
			}
		}
		return annotations
	}
	
	fileprivate func mapCoordinates() -> CLLocationCoordinate2D {
		var coordinates = CLLocationCoordinate2D(latitude: ArtCityMap.centerLatitude , longitude: ArtCityMap.centerLongitude )
		// TODO tweak location for art city center
		if let location = location {
			let latitude = location.latitude.doubleValue
			let longitude = location.longitude.doubleValue
			coordinates = CLLocationCoordinate2D(latitude:latitude, longitude: longitude)
		}
		return coordinates
	}
	
	fileprivate func updateMapAnnotations() {
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
			mapView.setCenter(coordinates, animated: true)
			let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1) // TODO:
			let region = MKCoordinateRegion(center:coordinates, span:span)
			mapView?.setRegion(region, animated: false)
			zoomed = true;
		}
	}
	
	
	// MARK: actions
	
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
		UserDefaults.standard.set(codedType, forKey: "CityMapsType")
	}
	
	func getSavedMapType() -> MKMapType {
		var mapType: MKMapType = .standard
		let userDefaults = UserDefaults.standard
		if let codedType = userDefaults.object(forKey: "CityMapsType") as? String {
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
	
	
	// MARK: miscellaneous
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		print("\(#file) did receive memory warning")
	}
}

extension CityMapsViewController : MKMapViewDelegate, UIPopoverPresentationControllerDelegate {

	func adaptivePresentationStyle(
		for controller: UIPresentationController) -> UIModalPresentationStyle {
		return UIModalPresentationStyle.none
	}

	func displayArtSummaryViewControllerAt(_ popoverAnchor: UIView, art: Art) {
		let singleArtSummaryViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SingleArtSummaryViewController") as! SingleArtSummaryViewController
		singleArtSummaryViewController.modalPresentationStyle = .popover
		singleArtSummaryViewController.art = art
		if let popoverPresentationController = singleArtSummaryViewController.popoverPresentationController {
			popoverPresentationController.sourceView = popoverAnchor
			popoverPresentationController.sourceRect = popoverAnchor.frame
			popoverPresentationController.permittedArrowDirections = .any
			popoverPresentationController.delegate = self
			present(singleArtSummaryViewController, animated: true, completion: { () -> Void in
				
			})
			
		}
	}

	func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
		if let annotation = view.annotation as? ArtMapAnnotation {
			if let art = annotation.art {
	//			if let rightCalloutAccessoryView = view.rightCalloutAccessoryView {
	//				displayArtSummaryViewControllerAt(view.rightCalloutAccessoryView, art: art)
					let singleArtViewController: SingleArtViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: ViewControllerIdentifier.SingleArtViewController.rawValue) as! SingleArtViewController
					singleArtViewController.update(art, artBackgroundColor: nil)
					show(singleArtViewController, sender: self)
	//			}
			}
		}		
	}
	
	func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
		if  let imageView = view.leftCalloutAccessoryView as? UIImageView,
		    let annotation = view.annotation as? ArtMapAnnotation,
			let art = annotation.art {
			// FIXME: should use this one
			ThumbImages.sharedInstance.getImage(art, complete: { (image, imageFileName) -> () in
					imageView.image = image
			})
		}
	}

	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		if let _  = annotation as? MKUserLocation {
			return nil
		}
		
		if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationViewId) as? MKArtAnnotationView {
			annotationView.annotation = annotation
			annotationView.updateImage()
			return annotationView
		} else {
			let annotationView = MKArtAnnotationView(annotation: annotation, reuseIdentifier: annotationViewId)
			annotationView.canShowCallout = true
			annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
			// TODO: TAP ON IMAGE TO SHOW POPOVER
			annotationView.leftCalloutAccessoryView = UIImageView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width:40, height:40)))
			return annotationView
		}
	}
	
}

extension CityMapsViewController {
		override func collapseSecondaryViewController(_ secondaryViewController: UIViewController, for splitViewController: UISplitViewController) {
//			println("CityMapsViewController collapse")
			super.collapseSecondaryViewController(secondaryViewController, for: splitViewController)
		}
}


