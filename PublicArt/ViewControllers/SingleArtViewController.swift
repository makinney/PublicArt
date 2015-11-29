//
//  SingleArtViewController.swift
//  ArtCity
//
//  Created by Michael Kinney on 2/6/15.
//  Copyright (c) 2015 mkinney. All rights reserved.
//

import UIKit

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
	
	private var art: Art?
	private var artBackgroundColor: UIColor?
	private var firstViewAppearance = true
	private var mapRouting: MapRouting?
	private var promptUserTimer: NSTimer?
	private let promptUserTimerTimeout: NSTimeInterval = 5

	// MARK: Lifecycles

	required init?(coder aDecoder: NSCoder) {
		super.init(coder:aDecoder)
	}
	
	deinit {
		promptUserTimer?.invalidate()
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		self.scrollView?.backgroundColor = UIColor.whiteColor()
		setupPhotoImage()
		prepareNavButtons()
		runAutoPromptTimer()
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		hideTouchPrompt()
		update()
	}
	
	 override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		_ = navigationController?.navigationBar
		hideTouchPrompt()
	}
	
	// MARK setups and prepares
	
	var flexibleSpaceBarButtonItem: UIBarButtonItem {
		return UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
	}
	
	var fixedSpaceBarButtonItem: UIBarButtonItem {
		let fixedSpaceBarButtonItem = UIBarButtonItem(barButtonSystemItem: .FixedSpace , target: nil, action: nil)
		fixedSpaceBarButtonItem.width = 0
		return fixedSpaceBarButtonItem
	}
	
	var actionButton: UIBarButtonItem {
		return UIBarButtonItem(barButtonSystemItem: .Action , target: self, action: "actionButtonTouched:")
	}
	
	var directionsButton: UIBarButtonItem {
		let image = UIImage(named: "DirectionsArrow")
		return UIBarButtonItem(image:image, style: .Plain, target:self, action:"directionsButtonTouched:")
	}
	
	var favoritesButton: UIBarButtonItem {
		return UIBarButtonItem(barButtonSystemItem: .Bookmarks , target: self, action: "favoriteButtonTouched:")
	}
	
	var mapButton: UIBarButtonItem {
		let image = UIImage(named: "tool-map")

		return UIBarButtonItem(image:image, style: .Plain, target:self, action:"mapButtonTouched:")
	}
	

	
	func prepareNavButtons() {
		self.navigationItem.rightBarButtonItems  = [actionButton, fixedSpaceBarButtonItem, mapButton, fixedSpaceBarButtonItem, directionsButton, flexibleSpaceBarButtonItem ]
	}
	
	func prepareButtons() {
			// doesn't work to increase touch area..		artTitleButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 50)
	}
	
	func setupPhotoImage() {
		if traitCollection.userInterfaceIdiom == .Phone {
			artImageViewTopToTop.constant = 4
		} else {
			artImageViewTopToTop.constant = 4
			
		}
		let tapRecognizer = UITapGestureRecognizer(target: self, action: "artImageTapped:")
		artImageView.addGestureRecognizer(tapRecognizer)
	}
	
	// MARK: update
	
	func update(art: Art, artBackgroundColor: UIColor?) {
		hideTouchPrompt() // split view expanded
		self.art = art
		self.artBackgroundColor = artBackgroundColor
		if self.isViewLoaded() {
			update()
		}
	}
	

	
	private func update() {
		
		if let art = art {
			if let highResPhoto = thumbNailsHighResolutionVersionIn(art) {
				activityIndicator.startAnimating()
				ImageDownload.downloadPhoto(highResPhoto, complete: {[weak self] (data, imageFileName) -> () in
					if let data = data	{
						let image = UIImage(data: data) ?? UIImage()
						self?.artImageView.image = image
						self?.artImageView.hidden = false
					}
					self?.activityIndicator.stopAnimating()
				})
			} else {
				activityIndicator.startAnimating()
				ImageDownload.downloadThumb(art, complete: {[weak self] (data, imageFileName) -> () in
				if let data = data	{
					let image = UIImage(data: data) ?? UIImage()
					self?.artImageView.image = image
					self?.artImageView.hidden = false
				}
					self?.activityIndicator.stopAnimating()
				})
			}

			// art title
			let artTitle = art.title ?? ""
			artTitleButton.setTitle(artTitle, forState: .Normal)
			if art.artWebLink.characters.count > 3  {
				let image = UIImage(named: "disclosureIndicator") ?? UIImage()
				artTitleButton.setImage(image, forState: UIControlState.Normal)
				artTitleButton?.imageView?.contentMode = .ScaleAspectFit // has to come before setting position
				setImagePostion(artTitleButton)
				artTitleButton.enabled = true
			} else {
				artTitleButton.enabled = false
			}

			// artist
			var artistName = ""
			if let artist = art.artist {
				artistName = artistFullName(artist)
			}
			artistNameButton.setTitle(artistName, forState: .Normal)
			if let artist = art.artist
			   where artist.webLink.characters.count > 3  { // guard against blank strings
				let image = UIImage(named: "disclosureIndicator") ?? UIImage()
				artistNameButton.setImage(image, forState: UIControlState.Normal)
				artistNameButton?.imageView?.contentMode = .ScaleAspectFit // has to come before setting position
				setImagePostion(artistNameButton)
				artistNameButton.enabled = true
			} else {
				artistNameButton.enabled = false

			}
			
			// dimensions
			if art.dimensions != "Undefined" {
				dimensionsLabel.text =  art.dimensions
			} else {
				dimensionsLabel.text = "Dimensions " + "unknown"
			}

			// location
			locationButton.setTitle(art.address ?? "", forState: .Normal)
			
			// medium
			if art.medium != "Undefined" {
				mediumLabel.text =  art.medium
			} else {
				mediumLabel.text = "Medium " + "unknown"
			}
		
		}
	}
	
	private func setImagePostion(button: UIButton) {
		var buttonWidth = button.frame.width
		let imageViewWidth = button.imageView?.frame.width ?? 0.0
		let imageInset = (buttonWidth - imageViewWidth)
		button.imageEdgeInsets = UIEdgeInsets(top: 0, left: imageInset, bottom: 0, right: -imageInset)
		button.titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageViewWidth, bottom: 0, right: imageViewWidth)
		buttonWidth = button.frame.width
	}
	
	// MARK: Dynamic Type
	
	// MARK: seque
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if (segue.identifier == SegueIdentifier.ArtTitleToWebView.rawValue) {
			let destinationViewController = segue.destinationViewController as! WebViewController
			destinationViewController.webViewAddress = art?.artWebLink
		} else if (segue.identifier == SegueIdentifier.ArtistToWebView.rawValue) {
			let destinationViewController = segue.destinationViewController as! WebViewController
			destinationViewController.webViewAddress = art?.artist?.webLink
		} else if (segue.identifier == SegueIdentifier.ButtonToMap.rawValue) {
			if let singleArtMapViewController = segue.destinationViewController as? SingleArtMapViewController {
				singleArtMapViewController.transitioningDelegate = mapAnimatedTransistioningDelegate
				singleArtMapViewController.modalPresentationStyle = .Custom
				singleArtMapViewController.art = art
			}
		} else if (segue.identifier == SegueIdentifier.SingleImageToImageCollection.rawValue) {
			if let singleArtPhotosCollectionViewController = segue.destinationViewController as? SingleArtPhotosCollectionViewController {
				singleArtPhotosCollectionViewController.transitioningDelegate = singleArtPhotosAnimatedTransistionDelegate
				singleArtPhotosCollectionViewController.modalPresentationStyle = .Custom
				singleArtPhotosCollectionViewController.art = art
			}
		}
	}
	
	// MARK: Share
	func actionButtonTouched(sender: UIBarButtonItem) {
		shareArtwork(sender)
	}
	
	func directionsButtonTouched(sender: UIBarButtonItem) {
		if let art = self.art {
			mapRouting = MapRouting(art: art)
			mapRouting?.showAvailableAppsSheet(self, barButtonItem: sender)
		}
	}

	
	func favoriteButtonTouched(sender: UIBarButtonItem) {
		print("favorites")
	}
	
	func mapButtonTouched(sender: UIBarButtonItem) {
		performSegueWithIdentifier(SegueIdentifier.ButtonToMap.rawValue, sender: nil)
	}
	
	
	

	func shareArtwork(barButtonItem: UIBarButtonItem) {
		let moc = CoreDataStack.sharedInstance.managedObjectContext
		let fetcher = Fetcher(managedObjectContext: moc!)
		let msg = (art?.title ?? "" ) + "\n"
		let image = artImageView.image ?? UIImage()
		var activityItems = [image,msg]
		if let appCommon = fetcher.fetchAppCommon() {
			let facebookPage = appCommon.facebookPublicArtPage
			if let facebookPageURL = NSURL(string: facebookPage) {
				activityItems.append(facebookPageURL)
			}
		}
		let avc = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
		avc.excludedActivityTypes = [UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll, UIActivityTypeAddToReadingList,
			UIActivityTypeAirDrop, UIActivityTypePostToFlickr]
		
		let userInterfaceIdion = traitCollection.userInterfaceIdiom
		if userInterfaceIdion == .Phone {
			avc.modalTransitionStyle = .CoverVertical
			presentViewController(avc, animated: true, completion: nil)
		} else {
			avc.modalPresentationStyle = .Popover
			avc.popoverPresentationController?.barButtonItem = barButtonItem
			presentViewController(avc, animated: true, completion: nil)
		}
	}
	
	
	// MARK: Help

	func artImageTapped(tapRecognizer: UITapGestureRecognizer) {
		performSegueWithIdentifier(SegueIdentifier.SingleImageToImageCollection.rawValue, sender: nil)
		if !photoTouchedAtLeastOnce {
			photoTouchedAtLeastOnce = true
			hideTouchPrompt() // just in case
		}
	}
	
	func showTouchPrompt() {
		if !photoTouchedAtLeastOnce {
			artImageView.addSubview(touchImagePrompt)
			UIView.animateWithDuration(2.0, animations: { [weak self] () -> Void in
				self?.touchImagePrompt?.alpha = 0.75
			})
		}
	}
	
	private func hideTouchPrompt() {
		touchImagePrompt?.alpha = 0.0
	}

	
	private func runAutoPromptTimer() {
		if !photoTouchedAtLeastOnce {
			promptUserTimer?.invalidate()
			promptUserTimer = NSTimer.scheduledTimerWithTimeInterval(promptUserTimerTimeout,
								target: self,
							  selector: "showTouchPrompt",
							  userInfo: nil,
							   repeats: false)
		} else {
			// has touched one time at least so nothing to do
		}
	}
	
	var photoTouchedAtLeastOnce: Bool {
		get {
			let userDefaults = NSUserDefaults.standardUserDefaults
			if let touched = userDefaults().objectForKey(UserDefaultKeys.SingleArtViewPhotoTouchedAtLeastOnce.rawValue) as? Bool { // TODO: define key
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
			NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: UserDefaultKeys.SingleArtViewPhotoTouchedAtLeastOnce.rawValue) // TODO define key
		}
	}
	
}


