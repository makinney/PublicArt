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
	@IBOutlet weak var artTitleLabel: UILabel!
	@IBOutlet weak var artistNameLabel: UILabel!
	@IBOutlet weak var dimensionsLabel: UILabel!
	@IBOutlet weak var locationLabel: UILabel!
	@IBOutlet weak var mediumLabel: UILabel!
		
	var flexibleSpaceBarButtonItem: UIBarButtonItem {
		return UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
	}
	
	var fixedSpaceBarButtonItem: UIBarButtonItem {
		return UIBarButtonItem(barButtonSystemItem: .FixedSpace , target: nil, action: nil)
	}
	
	var mapButton:UIBarButtonItem {
		return UIBarButtonItem(title: "Map", style: .Plain, target: self, action: "mapTapped")
	}
	
	func prepareButtons() {
		self.navigationController?.navigationBar.topItem?.rightBarButtonItems  = [mapButton, flexibleSpaceBarButtonItem]
	}
	
	let mapAnimatedTransistioningDelegate = MapAnimatedTransistioningDelegate()
	let singleArtPhotosAnimatedTransistionDelegate = SingleArtPhotosAnimatedTransistioningDelegate()
	
	private var art: Art?
	private var artBackgroundColor: UIColor?
	private var firstViewAppearance = true
	private var prevailingColors = [String:UIColor]()
	private var promptUserTimer: NSTimer?
	private let promptUserTimerTimeout: NSTimeInterval = 5
	
	
	required init(coder aDecoder: NSCoder) {
		super.init(coder:aDecoder)
	}
	
	deinit {
		NSNotificationCenter.defaultCenter().removeObserver(self)
		promptUserTimer?.invalidate()
	}
	
	// MARK: Lifecycles
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupPhotoImage()
//		prepareButtons()
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "contentSizeCategoryDidChange", name: UIContentSizeCategoryDidChangeNotification, object: nil)
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
//		self.title = // displays on nav bar

		artTitleLabel.text = art?.title
		artistNameLabel.text = art?.artistName
		dimensionsLabel.text = art?.dimensions
		mediumLabel.text = art?.medium
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
	
	func contentSizeCategoryDidChange() {
		var fontStyle2 = UIFontTextStyleBody
		artistNameLabel.font = UIFont.preferredFontForTextStyle(fontStyle2)
		artTitleLabel.font = UIFont.preferredFontForTextStyle(fontStyle2)
		dimensionsLabel.font = UIFont.preferredFontForTextStyle(fontStyle2)
		locationLabel.font = UIFont.preferredFontForTextStyle(fontStyle2)
		mediumLabel.font = UIFont.preferredFontForTextStyle(fontStyle2)
	}
	
	// MARK: seque
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//		var destinationViewController = segue.destinationViewController as! UIViewController
//		if let singleArtMapViewController = destinationViewController as? SingleArtMapViewController {
//			singleArtMapViewController.transitioningDelegate = mapAnimatedTransistioningDelegate
//			singleArtMapViewController.modalPresentationStyle = .Custom
//			singleArtMapViewController.art = art
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


