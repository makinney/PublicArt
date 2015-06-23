//
//  MainMenuSplitViewController.swift
//  PublicArt
//
//  Created by Michael Kinney on 6/5/15.
//  Copyright (c) 2015 makinney. All rights reserved.
//

import UIKit

class MainMenuSplitViewController: UISplitViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
		self.delegate = self
		preferredDisplayMode = .AllVisible

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
}

extension MainMenuSplitViewController : UISplitViewControllerDelegate {
	
	//	func primaryViewControllerForCollapsingSplitViewController(splitViewController: UISplitViewController) -> UIViewController? {
	//		println("delegate primary view for collapsing, returning nil")
	//		return nil // means just do what you would normally do
	//	}
	//
	//	func primaryViewControllerForExpandingSplitViewController(splitViewController: UISplitViewController) -> UIViewController? {
	//		println("delegate primary view for expanding, returning nil")
	//		return nil // means just do what you would normally do
	//	}
	
	
	//		func targetDisplayModeForActionInSplitViewController(svc: UISplitViewController) -> UISplitViewControllerDisplayMode {
	//			return .Automatic
	//		}
	//	//
	//	func splitViewController(svc: UISplitViewController, willChangeToDisplayMode displayMode: UISplitViewControllerDisplayMode) {
	//		println("changing to mode: \(displayMode.rawValue)")
	//	}
	
	
	func splitViewController(splitViewController: UISplitViewController,
		collapseSecondaryViewController secondaryViewController: UIViewController!,
		ontoPrimaryViewController primaryViewController: UIViewController!) -> Bool {
			return true
	}
	//
}