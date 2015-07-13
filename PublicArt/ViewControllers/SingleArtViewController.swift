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

	@IBOutlet weak var buttonHeight: NSLayoutConstraint!

	let mapAnimatedTransistioningDelegate = MapAnimatedTransistioningDelegate()
	let singleArtPhotosAnimatedTransistionDelegate = SingleArtPhotosAnimatedTransistioningDelegate()
	
	private var art: Art?
	private var artBackgroundColor: UIColor?
	private var firstViewAppearance = true
	private var promptUserTimer: NSTimer?
	private let promptUserTimerTimeout: NSTimeInterval = 5

	// MARK: Lifecycles

	required init(coder aDecoder: NSCoder) {
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
		title = "single"
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		hideTouchPrompt()
		update()
	}
	
	 override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		var navBar = navigationController?.navigationBar
		hideTouchPrompt()
	}
	
	// MARK setups and prepares
	
	var flexibleSpaceBarButtonItem: UIBarButtonItem {
		return UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
	}
	
	var fixedSpaceBarButtonItem: UIBarButtonItem {
		var fixedSpaceBarButtonItem = UIBarButtonItem(barButtonSystemItem: .FixedSpace , target: nil, action: nil)
		fixedSpaceBarButtonItem.width = 20
		return fixedSpaceBarButtonItem
	}
	
	var actionButton: UIBarButtonItem {
		return UIBarButtonItem(barButtonSystemItem: .Action , target: self, action: "actionButtonTouched:")
	}
	
	var favoritesButton: UIBarButtonItem {
		return UIBarButtonItem(barButtonSystemItem: .Bookmarks , target: self, action: "favoriteButtonTouched:")
	}
	
	
	func prepareNavButtons() {
		self.navigationItem.rightBarButtonItems  = [actionButton, fixedSpaceBarButtonItem, favoritesButton, flexibleSpaceBarButtonItem]
	}
	
	func prepareButtons() {
			// doesn't work to increase touch area..		artTitleButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 50)
	}
	
	func setupPhotoImage() {
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
			ImageDownload.downloadThumb(art, complete: {[weak self] (data, imageFileName) -> () in
				if let data = data	{
					var image = UIImage(data: data) ?? UIImage()
					self?.artImageView.image = image
					self?.artImageView.hidden = false
				}
				})
		}
		
		var artistName = art?.artistName ?? ""
		artistNameButton.setTitle(artistName, forState: .Normal)
		if let artistWebLink = art?.artistWebLink
			where count(artistWebLink) > 3 { // guard against blank strings
				var image = UIImage(named: "toolbar-infoButton") ?? UIImage()
				artistInfoImageView.image = image
		}

		var artTitle = art?.title ?? ""
		artTitleButton.setTitle(artTitle, forState: .Normal)
		artTitleButton.invalidateIntrinsicContentSize()

		if let artWebLink = art?.artWebLink
			where count(artWebLink) > 3  { // guard against blank strings
				var image = UIImage(named: "toolbar-infoButton") ?? UIImage()
				artTitleInfoImageView.image = image
		}


		if let dimensions = art?.dimensions {
			if dimensions != "Undefined" {
				dimensionsLabel.text =  dimensions
			} else {
				dimensionsLabel.text = "Dimensions " + "unknown"
			
			}
		}

		locationButton.setTitle(art?.address ?? "", forState: .Normal)
		
		if let medium = art?.medium {
			if medium != "Undefined" {
				mediumLabel.text =  medium
			} else {
				mediumLabel.text = "Medium " + "unknown"
				
			}
		}
		
		//	var leftInset = artTitleButton.titleLabel?.frame.size.width
		//	var label = artTitleButton.titleLabel
		//		var leftInset = artTitleButton.frame.size.width - artTitleButton.imageView!.frame.size.width
		
		//		var rightInset = artTitleButton.titleLabel?.frame.size.width
		//		rightInset! = 0 - rightInset!
		//		rightInset = 0 - leftInset - artTitleButton.imageView!.frame.size.width
		//		artTitleButton.imageEdgeInsets = UIEdgeInsets(top: 0, left:leftInset, bottom: 0, right: rightInset!)
		//
		
	}
	
	// MARK: Dynamic Type
	
	// MARK: seque
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if (segue.identifier == SegueIdentifier.ArtTitleToWebView.rawValue) {
			var destinationViewController = segue.destinationViewController as! WebViewController
			destinationViewController.webViewAddress = art?.artWebLink
		} else if (segue.identifier == SegueIdentifier.ArtistToWebView.rawValue) {
			var destinationViewController = segue.destinationViewController as! WebViewController
			destinationViewController.webViewAddress = art?.artistWebLink
		} else if (segue.identifier == SegueIdentifier.MapButtonToMap.rawValue) || (segue.identifier == SegueIdentifier.LocationButtonToMap.rawValue) {
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
	
	
	
	func routeButtonTouched(sender: UIBarButtonItem) {
		println("route")
	}
	
	func favoriteButtonTouched(sender: UIBarButtonItem) {
		println("favorites")
	}
	
	func actionButtonTouched(sender: UIBarButtonItem) {
		shareArtwork(sender)
	}

	func shareArtwork(barButtonItem: UIBarButtonItem) {
		let msg = (art?.title ?? "" ) + "\n"
		var image = artImageView.image ?? UIImage()
		var url: NSURL = NSURL(string: "https://www.facebook.com/pages/Public-Art-San-Francisco/360818354113241")!
		var activityItems = [image,msg, url]
		var avc = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
		avc.excludedActivityTypes = [UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll, UIActivityTypeAddToReadingList,
			UIActivityTypeAirDrop, UIActivityTypePostToFlickr]
		
		var userInterfaceIdion = traitCollection.userInterfaceIdiom
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
		artImageView.addSubview(touchImagePrompt)
		UIView.animateWithDuration(2.0, animations: { [weak self] () -> Void in
			self?.touchImagePrompt?.alpha = 0.75
			})
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
			var userDefaults = NSUserDefaults.standardUserDefaults
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


