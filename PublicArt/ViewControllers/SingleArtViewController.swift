//
//  SingleArtViewController.swift
//  ArtCity
//
//  Created by Michael Kinney on 2/6/15.
//  Copyright (c) 2015 mkinney. All rights reserved.
//

import UIKit

class SingleArtViewController: UIViewController {
	@IBOutlet weak var infoView: UIView!
	@IBOutlet weak var artImageView: UIImageView!
	@IBOutlet weak var touchImagePrompt: UILabel!
	@IBOutlet weak var scrollView: UIScrollView!

	@IBOutlet weak var dimensionsLabel: UILabel!
	@IBOutlet weak var locationLabel: UILabel!
	@IBOutlet weak var mediumLabel: UILabel!
	
	@IBOutlet weak var artTitleButton: UIButton!
	@IBOutlet weak var artistNameButton: UIButton!
	
	@IBOutlet weak var artTitleInfoImageView: UIImageView!
	@IBOutlet weak var artistInfoImageView: UIImageView!
	@IBOutlet weak var buttonHeight: NSLayoutConstraint!
	
	@IBAction func onTouchMapButton(sender: AnyObject) {
	}
	
	let mapAnimatedTransistioningDelegate = MapAnimatedTransistioningDelegate()
	let singleArtPhotosAnimatedTransistionDelegate = SingleArtPhotosAnimatedTransistioningDelegate()
	
	private var art: Art?
	private var artBackgroundColor: UIColor?
	private var firstViewAppearance = true
	private var prevailingColors = [String:UIColor]()
	private var promptUserTimer: NSTimer?
	private let promptUserTimerTimeout: NSTimeInterval = 5

	var flexibleSpaceBarButtonItem: UIBarButtonItem {
		return UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
	}
	
	var fixedSpaceBarButtonItem: UIBarButtonItem {
		return UIBarButtonItem(barButtonSystemItem: .FixedSpace , target: nil, action: nil)
	}
	
//	var mapButton:UIBarButtonItem {
//		return UIBarButtonItem(title: "Map", style: .Plain, target: self, action: "mapTapped")
//	}
	

	required init(coder aDecoder: NSCoder) {
		super.init(coder:aDecoder)
	}
	
	deinit {
		promptUserTimer?.invalidate()
	}
	
	// MARK: Lifecycles
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupPhotoImage()
//		prepareNavButtons()
		prepareButtons()
		runAutoPromptTimer()
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		hideTouchPrompt()
		updateArt()
	}
	
	 override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		hideTouchPrompt()
	}
	
	func prepareNavButtons() {
//		self.navigationController?.navigationBar.topItem?.rightBarButtonItems  = [mapButton, flexibleSpaceBarButtonItem]
	}
	
	func prepareButtons() {
// doesn't work to increase touch area..		artTitleButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 50)
	}
	
	func updateArt(art: Art, artBackgroundColor: UIColor?) {
		hideTouchPrompt() // split view expanded
		self.art = art
		self.artBackgroundColor = artBackgroundColor
		if self.isViewLoaded() {
			updateArt()
		}
	}
	
	private func updateArt() {
		
		self.scrollView?.backgroundColor = UIColor.whiteColor()
		
		var artTitle = art?.title ?? ""
//		artTitle = "A very long title to test word wrapping and button height growth for sure"
//	artTitle = "A very long title to test word"
		artTitleButton.setTitle(artTitle, forState: .Normal)
		artTitleButton.invalidateIntrinsicContentSize()

	//	var leftInset = artTitleButton.titleLabel?.frame.size.width
//	var label = artTitleButton.titleLabel
//		var leftInset = artTitleButton.frame.size.width - artTitleButton.imageView!.frame.size.width

//		var rightInset = artTitleButton.titleLabel?.frame.size.width
//		rightInset! = 0 - rightInset!
//		rightInset = 0 - leftInset - artTitleButton.imageView!.frame.size.width
//		artTitleButton.imageEdgeInsets = UIEdgeInsets(top: 0, left:leftInset, bottom: 0, right: rightInset!)
//		
		
		if let artWebLink = art?.artWebLink
			where count(artWebLink) > 3  { // guard against blank strings
			var image = UIImage(named: "toolbar-infoButton") ?? UIImage()
			artTitleInfoImageView.image = image
		}
		
		var artistName = art?.artistName ?? ""
		artistNameButton.setTitle(artistName, forState: .Normal)
		if let artistWebLink = art?.artistWebLink
			where count(artistWebLink) > 3 { // guard against blank strings
			var image = UIImage(named: "toolbar-infoButton") ?? UIImage()
			artistInfoImageView.image = image
		}


		if let dimensions = art?.dimensions {
			if dimensions != "Undefined" {
				dimensionsLabel.text =  dimensions
			} else {
				dimensionsLabel.text = "Dimensions " + "unknown"
			
			}
		}

		if let medium = art?.medium {
			if medium != "Undefined" {
				mediumLabel.text =  medium
			} else {
				mediumLabel.text = "Medium " + "unknown"

			}
		}
		
		locationLabel.text = art?.address
		
		if let art = art {
			ImageDownload.downloadThumb(art, complete: {[weak self] (data, imageFileName) -> () in
				if let data = data	{
						var image = UIImage(data: data) ?? UIImage()
					self?.artImageView.image = image
					self?.artImageView.hidden = false
				}
			})
		
		}

	}
	
	func setupPhotoImage() {
		let tapRecognizer = UITapGestureRecognizer(target: self, action: "artImageTapped:")
		artImageView.addGestureRecognizer(tapRecognizer)
	}
	
	// MARK: Dynamic Type
	
	// MARK: seque
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
	
		if (segue.identifier == SegueIdentifier.ArtTitleToWebView.rawValue) {
			var destinationViewController = segue.destinationViewController as! WebViewController
			destinationViewController.webViewAddress = art?.artWebLink
		} else 	if (segue.identifier == SegueIdentifier.ArtistToWebView.rawValue) {
			var destinationViewController = segue.destinationViewController as! WebViewController
			destinationViewController.webViewAddress = art?.artistWebLink
		} else 	if (segue.identifier == SegueIdentifier.ArtToMap.rawValue) {
			if let singleArtMapViewController = segue.destinationViewController as? SingleArtMapViewController {
				singleArtMapViewController.transitioningDelegate = mapAnimatedTransistioningDelegate
				singleArtMapViewController.modalPresentationStyle = .Custom
				singleArtMapViewController.art = art
			}
		}
		
		
//		} else if let singleArtPhotosCollectionViewController = destinationViewController as? SingleArtPhotosCollectionViewController {
//			singleArtPhotosCollectionViewController.transitioningDelegate = singleArtPhotosAnimatedTransistionDelegate
//			singleArtPhotosCollectionViewController.modalPresentationStyle = .Custom
//			singleArtPhotosCollectionViewController.art = art
//		}
	}
	
	// MARK: Actions
	
	func artImageTapped(tapRecognizer: UITapGestureRecognizer) {
//		performSegueWithIdentifier(SegueIdentifier.ArtToPhoto.rawValue, sender: nil)
//		if !photoTouchedAtLeastOnce {
//			photoTouchedAtLeastOnce = true
//			hideTouchPrompt() // just in case
//		}
	}
	
	func mapTapped() {
		performSegueWithIdentifier(SegueIdentifier.ArtToMap.rawValue, sender: nil)
	}
	
	// MARK: image tapp prompting
	
	func showTouchPrompt() {
//		artImageView.addSubview(touchImagePrompt)
//		UIView.animateWithDuration(2.0, animations: { [weak self] () -> Void in
//			self?.touchImagePrompt?.alpha = 0.75
//		})
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
			if let touched = userDefaults().objectForKey("KeySingleArtViewPhotoTouchedAtLeastOnce") as? Bool { // TODO: define key
				if touched {
					return true
				} else {
					return false
				}
			} else {
				return false
			}
		}
		
		set(newUserTouchedImage) { // not a 'new' user, but 'new' as newValue per Swift
			NSUserDefaults.standardUserDefaults().setObject(newUserTouchedImage, forKey: "KeySingleArtViewPhotoTouchedAtLeastOnce") // TODO define key
		}
	}
	
}


