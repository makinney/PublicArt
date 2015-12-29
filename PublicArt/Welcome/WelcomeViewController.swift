//
//  WelcomeViewController.swift
//  PublicArt
//
//  Created by Michael Kinney on 6/28/15.
//  Copyright (c) 2015 makinney. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController, UIScrollViewDelegate {

	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var pageControl: UIPageControl!

	var pageWidth = CGFloat(0.0)
	var pageCount = 0
	
    override func viewDidLoad() {
        super.viewDidLoad()
    }
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder:aDecoder)
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		self.scrollView.delegate = self
		setupChildren()
		pageControl.numberOfPages = pageCount
		pageControl.currentPageIndicatorTintColor = UIColor.sfOrangeColor()
		view.alpha = 1.0
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		view.alpha = 0.0
	}
	
	override func shouldAutorotate() -> Bool {
		return false
	}
	
	func setupChildren() {
		let publicViewController: WelcomePublicViewController = UIStoryboard(name: "Welcome", bundle: nil).instantiateViewControllerWithIdentifier(WelcomeIdentifier.PublicViewController.rawValue) as! WelcomePublicViewController
//		let browseViewController: WelcomeBrowseViewController = UIStoryboard(name: "Welcome", bundle: nil).instantiateViewControllerWithIdentifier(WelcomeIdentifier.BrowseViewController.rawValue) as! WelcomeBrowseViewController
		let exploreViewController: WelcomeExploreViewController = UIStoryboard(name: "Welcome", bundle: nil).instantiateViewControllerWithIdentifier(WelcomeIdentifier.ExploreViewController.rawValue) as! WelcomeExploreViewController
		let discoverViewController: WelcomeDiscoverViewController = UIStoryboard(name: "Welcome", bundle: nil).instantiateViewControllerWithIdentifier(WelcomeIdentifier.DiscoverViewController.rawValue) as! WelcomeDiscoverViewController
		let contributeViewController: WelcomeContributeViewController = UIStoryboard(name: "Welcome", bundle: nil).instantiateViewControllerWithIdentifier(WelcomeIdentifier.ContributeViewController.rawValue) as! WelcomeContributeViewController
		
		let mainViewController: UITabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(ViewControllerIdentifier.MainViewController.rawValue) as! UITabBarController


		let viewControllers: [UIViewController] = [publicViewController, discoverViewController, exploreViewController, contributeViewController, mainViewController]
		pageCount = viewControllers.count
		
		pageWidth = publicViewController.view.frame.width
		scrollView!.contentSize = CGSize(width: (CGFloat(pageCount) * pageWidth), height: view.frame.height)
		
		var idx:Int = 0
		
		for viewController in viewControllers {
			addChildViewController(viewController)
			let x = CGFloat(idx) * scrollView!.frame.width
			viewController.view.frame  = CGRect(x: x, y: 0, width: viewController.view.frame.size.width, height: viewController.view.frame.size.height)
			scrollView!.addSubview(viewController.view)
			viewController.didMoveToParentViewController(self)
			idx++;
		}
		
		scrollView!.addSubview(pageControl)
	}
	

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func scrollViewDidScroll(scrollView: UIScrollView) {
		let fractionalPage = self.scrollView.contentOffset.x / pageWidth
		let page: Int = Int(fractionalPage)
		self.pageControl.currentPage = page
		if page == pageCount - 1  {
			self.pageControl.hidden = true
			NSUserDefaults.standardUserDefaults().setBool(true, forKey: didShowLandingScreenKey)
			NSUserDefaults.standardUserDefaults().synchronize()
		} else {
			self.pageControl.hidden = false
		}
	}
	
}
