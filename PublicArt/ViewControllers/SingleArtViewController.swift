//
//  SingleArtViewController.swift
//  ArtCity
//
//  Created by Michael Kinney on 2/6/15.
//  Copyright (c) 2015 mkinney. All rights reserved.
//

import UIKit
import Social

final class SingleArtViewController: UIViewController {

	
	@IBOutlet weak var artTitleButton: UIButton!
	@IBOutlet weak var artistNameButton: UIButton!
	@IBOutlet weak var locationButton: UIButton!

	@IBOutlet weak var artImageView: UIImageView!
	@IBOutlet weak var artTitleInfoImageView: UIImageView!
	@IBOutlet weak var artistInfoImageView: UIImageView!
	@IBOutlet weak var infoView: UIView!
	@IBOutlet weak var scrollView: UIScrollView!

	@IBOutlet weak var dimensionsLabel: UILabel!
	@IBOutlet weak var mediumLabel: UILabel!
	@IBOutlet weak var touchImagePrompt: UILabel!

	@IBOutlet weak var artImageViewTopToTop: NSLayoutConstraint!
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	@IBOutlet weak var buttonHeight: NSLayoutConstraint!

	let mapAnimatedTransistioningDelegate = MapAnimatedTransistioningDelegate()
	let singleArtPhotosAnimatedTransistionDelegate = SingleArtPhotosAnimatedTransistioningDelegate()
	
	fileprivate var art: Art?
	fileprivate var artBackgroundColor: UIColor?
	fileprivate var firstViewAppearance = true
	fileprivate var mapRouting: MapRouting?
	fileprivate var promptUserTimer: Timer?
	fileprivate let promptUserTimerTimeout: TimeInterval = 5

	// MARK: Lifecycles

	required init?(coder aDecoder: NSCoder) {
		super.init(coder:aDecoder)
	}
	
	deinit {
		promptUserTimer?.invalidate()
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		self.scrollView?.backgroundColor = UIColor.white
		setupPhotoImage()
		prepareNavButtons()
		runAutoPromptTimer()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		hideTouchPrompt()
		update()
	}
	
	 override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		_ = navigationController?.navigationBar
		hideTouchPrompt()
	}
	
	// MARK setups and prepares
	
	var flexibleSpaceBarButtonItem: UIBarButtonItem {
		return UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
	}
	
	var fixedSpaceBarButtonItem: UIBarButtonItem {
		let fixedSpaceBarButtonItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace , target: nil, action: nil)
		fixedSpaceBarButtonItem.width = 0
		return fixedSpaceBarButtonItem
	}
	
	var actionButton: UIBarButtonItem {
		return UIBarButtonItem(barButtonSystemItem: .action , target: self, action: #selector(SingleArtViewController.actionButtonTouched(_:)))
	}
	
	var directionsButton: UIBarButtonItem {
		let image = UIImage(named: "DirectionsArrow")
		return UIBarButtonItem(image:image, style: .plain, target:self, action:#selector(SingleArtViewController.directionsButtonTouched(_:)))
	}
	
	var favoritesButton: UIBarButtonItem {
		return UIBarButtonItem(barButtonSystemItem: .bookmarks , target: self, action: #selector(SingleArtViewController.favoriteButtonTouched(_:)))
	}
	
	var mapButton: UIBarButtonItem {
		let image = UIImage(named: "tool-map")

		return UIBarButtonItem(image:image, style: .plain, target:self, action:#selector(SingleArtViewController.mapButtonTouched(_:)))
	}
	

	
	func prepareNavButtons() {
		self.navigationItem.rightBarButtonItems  = [actionButton, fixedSpaceBarButtonItem, mapButton, fixedSpaceBarButtonItem, directionsButton, flexibleSpaceBarButtonItem ]
	}
	
	func prepareButtons() {
			// doesn't work to increase touch area..		artTitleButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 50)
	}
	
	func setupPhotoImage() {
		if traitCollection.userInterfaceIdiom == .phone {
			artImageViewTopToTop.constant = 4
		} else {
			artImageViewTopToTop.constant = 4
			
		}
		let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(SingleArtViewController.artImageTapped(_:)))
		artImageView.addGestureRecognizer(tapRecognizer)
	}
	
	// MARK: update
	
	func update(_ art: Art, artBackgroundColor: UIColor?) {
		hideTouchPrompt() // split view expanded
		self.art = art
		self.artBackgroundColor = artBackgroundColor
		if self.isViewLoaded {
			update()
		}
	}
	

	
	fileprivate func update() {
		
		if let art = art {
			if let highResPhoto = thumbNailsHighResolutionVersionIn(art) {
				activityIndicator.startAnimating()
				PhotoImages.sharedInstance.getImage(highResPhoto, complete: {[weak self] (image, imageFileName) -> () in
					self?.artImageView.image = image
					self?.artImageView.isHidden = false
					self?.activityIndicator.stopAnimating()
				})
			} else {
			
				ThumbImages.sharedInstance.getImage(art, complete: { [weak self] (image, imageFileName) -> ()  in
					self?.artImageView.image = image
					self?.artImageView.isHidden = false
				})
			}

			// art title
			let artTitle = art.title
			artTitleButton.setTitle(artTitle, for: UIControlState())
			if art.artWebLink.characters.count > 3  {
				let image = UIImage(named: "disclosureIndicator") ?? UIImage()
				artTitleButton.setImage(image, for: UIControlState())
				artTitleButton?.imageView?.contentMode = .scaleAspectFit // has to come before setting position
				setImagePostion(artTitleButton)
				artTitleButton.isEnabled = true
			} else {
				artTitleButton.isEnabled = false
			}

			// artist
			var artistName = ""
			if let artist = art.artist {
				artistName = artistFullName(artist)
			}
			artistNameButton.setTitle(artistName, for: UIControlState())
			if let artist = art.artist, artist.webLink.characters.count > 3  { // guard against blank strings
				let image = UIImage(named: "disclosureIndicator") ?? UIImage()
				artistNameButton.setImage(image, for: UIControlState())
				artistNameButton?.imageView?.contentMode = .scaleAspectFit // has to come before setting position
				setImagePostion(artistNameButton)
				artistNameButton.isEnabled = true
			} else {
				artistNameButton.isEnabled = false

			}
			
			// dimensions
			if art.dimensions != "Undefined" {
				dimensionsLabel.text =  art.dimensions
			} else {
				dimensionsLabel.text = "Dimensions " + "unknown"
			}

			// location
			locationButton.setTitle(art.address, for: UIControlState())
			
			// medium
			if art.medium != "Undefined" {
				mediumLabel.text =  art.medium
			} else {
				mediumLabel.text = "Medium " + "unknown"
			}
		
		}
	}
	
	fileprivate func setImagePostion(_ button: UIButton) {
		var buttonWidth = button.frame.width
		let imageViewWidth = button.imageView?.frame.width ?? 0.0
		let imageInset = (buttonWidth - imageViewWidth)
		button.imageEdgeInsets = UIEdgeInsets(top: 0, left: imageInset, bottom: 0, right: -imageInset)
		button.titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageViewWidth, bottom: 0, right: imageViewWidth)
		buttonWidth = button.frame.width
	}
	
	// MARK: Dynamic Type
	
	// MARK: seque
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if (segue.identifier == SegueIdentifier.ArtTitleToWebView.rawValue) {
			let destinationViewController = segue.destination as! WebViewController
			destinationViewController.webViewAddress = art?.artWebLink
		} else if (segue.identifier == SegueIdentifier.ArtistToWebView.rawValue) {
			let destinationViewController = segue.destination as! WebViewController
			destinationViewController.webViewAddress = art?.artist?.webLink
		} else if (segue.identifier == SegueIdentifier.ButtonToMap.rawValue) {
			if let singleArtMapViewController = segue.destination as? SingleArtMapViewController {
				singleArtMapViewController.transitioningDelegate = mapAnimatedTransistioningDelegate
				singleArtMapViewController.modalPresentationStyle = .custom
				singleArtMapViewController.art = art
			}
		} else if (segue.identifier == SegueIdentifier.SingleImageToImageCollection.rawValue) {
			if let singleArtPhotosCollectionViewController = segue.destination as? SingleArtPhotosCollectionViewController {
				singleArtPhotosCollectionViewController.transitioningDelegate = singleArtPhotosAnimatedTransistionDelegate
				singleArtPhotosCollectionViewController.modalPresentationStyle = .custom
				singleArtPhotosCollectionViewController.art = art
			}
		}
	}
	
	// MARK: Share
	func actionButtonTouched(_ sender: UIBarButtonItem) {
		shareArtwork(sender)
	}
	
	func directionsButtonTouched(_ sender: UIBarButtonItem) {
		if let art = self.art {
			mapRouting = MapRouting(art: art)
			mapRouting?.showAvailableAppsSheet(self, barButtonItem: sender)
		}
	}

	
	func favoriteButtonTouched(_ sender: UIBarButtonItem) {
		print("favorites")
	}
	
	func mapButtonTouched(_ sender: UIBarButtonItem) {
		performSegue(withIdentifier: SegueIdentifier.ButtonToMap.rawValue, sender: nil)
	}
	
	
	

	func shareArtwork(_ barButtonItem: UIBarButtonItem) {
		let moc = CoreDataStack.sharedInstance.managedObjectContext
		let fetcher = Fetcher(managedObjectContext: moc!)
		let msg = (art?.title ?? "" ) + "\n"
		let image = artImageView.image ?? UIImage()
		var activityItems = [image,msg] as [Any]
		if let appCommon = fetcher.fetchAppCommon() {
			let facebookPage = appCommon.facebookPublicArtPage
			if let facebookPageURL = URL(string: facebookPage) {
				activityItems.append(facebookPageURL)
			}
		}
		let avc = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
		avc.excludedActivityTypes = [UIActivityType.print, UIActivityType.copyToPasteboard, UIActivityType.assignToContact, UIActivityType.saveToCameraRoll, UIActivityType.addToReadingList,
			UIActivityType.airDrop, UIActivityType.postToFlickr]
		
	//	let vc = SLComposeViewController(forServiceType: SLServiceTypeFacebook) {
		
			let vc = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
			vc?.setInitialText(msg)
			vc?.add(image)
		
		if let appCommon = fetcher.fetchAppCommon() {
			let facebookPage = appCommon.facebookPublicArtPage
			if let _ = URL(string: facebookPage) {
		//		activityItems.append(facebookPageURL)
		//		vc.addURL(facebookPageURL)
			}
		}
		
		
		let userInterfaceIdion = traitCollection.userInterfaceIdiom
		if userInterfaceIdion == .phone {
			vc?.modalTransitionStyle = .coverVertical
			present(vc!, animated: true, completion: nil)
		} else {
			vc?.modalPresentationStyle = .popover
			vc?.popoverPresentationController?.barButtonItem = barButtonItem
			present(vc!, animated: true, completion: nil)
		}
	}
	
	
	// MARK: Help

	func artImageTapped(_ tapRecognizer: UITapGestureRecognizer) {
		performSegue(withIdentifier: SegueIdentifier.SingleImageToImageCollection.rawValue, sender: nil)
		if !photoTouchedAtLeastOnce {
			photoTouchedAtLeastOnce = true
			hideTouchPrompt() // just in case
		}
	}
	
	func showTouchPrompt() {
		if !photoTouchedAtLeastOnce {
			artImageView.addSubview(touchImagePrompt)
			UIView.animate(withDuration: 2.0, animations: { [weak self] () -> Void in
				self?.touchImagePrompt?.alpha = 0.75
			})
		}
	}
	
	fileprivate func hideTouchPrompt() {
		touchImagePrompt?.alpha = 0.0
	}

	
	fileprivate func runAutoPromptTimer() {
		if !photoTouchedAtLeastOnce {
			promptUserTimer?.invalidate()
			promptUserTimer = Timer.scheduledTimer(timeInterval: promptUserTimerTimeout,
								target: self,
							  selector: #selector(SingleArtViewController.showTouchPrompt),
							  userInfo: nil,
							   repeats: false)
		} else {
			// has touched one time at least so nothing to do
		}
	}
	
	var photoTouchedAtLeastOnce: Bool {
		get {
			let userDefaults = UserDefaults.standard
			if let touched = userDefaults.object(forKey: UserDefaultKeys.SingleArtViewPhotoTouchedAtLeastOnce.rawValue) as? Bool { // TODO: define key
				if touched {
					return true
				} else {
					return false
				}
			} else {
				return false
			}
		}
		
		set(newValue) {
			UserDefaults.standard.set(newValue, forKey: UserDefaultKeys.SingleArtViewPhotoTouchedAtLeastOnce.rawValue) // TODO define key
		}
	}
	
}


