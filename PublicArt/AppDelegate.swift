//
//  AppDelegate.swift
//  PublicArt
//
//  Created by Michael Kinney on 6/5/15.
//  Copyright (c) 2015 makinney. All rights reserved.
//

import UIKit
import Parse
import Bolts



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
	var artDataManager: ArtDataManager?

	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		// Override point for customization after application launch.
		self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
		self.normalWindowRoot(animate:false)
//		self.useWelcomeAsRoot()
		self.window?.makeKeyAndVisible()

		setAppearanceProxies()
		//
		Parse.enableLocalDatastore()
		ParsePhoto.registerSubclass()
		ParseArtist.registerSubclass()
		ParseArt.registerSubclass()
		ParseLocation.registerSubclass()
		
		Parse.setApplicationId("SL4Z3PKg3yQMNDgiZOWzO6QYdrfSXaiyefVnesqS",
			         clientKey: "M2nmbAOma1185BZDslTSqnWGmScwGHXkswt5Ea8e")
		
		ArtRefresh.artRefreshFromServerRequired {[weak self] (required, clientLastRefreshed, serverLastRefreshed) -> () in
			if required {
				self?.artDataManager = ArtDataManager(coreDataStack: CoreDataStack.sharedInstance)
				if let clientLastRefreshed = clientLastRefreshed,
					let serverLastRefreshed = serverLastRefreshed {
					 self?.artDataManager!.refresh(clientLastRefreshed, endingAtDate: serverLastRefreshed)
				} else if let serverLastRefreshed = serverLastRefreshed {
					var initialUpdate: NSDate = NSDate.distantPast() as! NSDate // make sure to get everything
					self?.artDataManager!.refresh(initialUpdate, endingAtDate: serverLastRefreshed)
				}
			}
		}
		return true
	}
	
	func useWelcomeAsRoot() {
		var welcomeViewController = UIStoryboard(name: "Welcome", bundle: nil).instantiateViewControllerWithIdentifier(WelcomeIdentifier.WelcomeViewController.rawValue) as? WelcomeViewController
		self.window?.rootViewController = welcomeViewController
	}
	
	func normalWindowRoot(#animate: Bool) {
		let mainViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(ViewControllerIdentifier.MainViewController.rawValue) as? UITabBarController
		if animate == false {
			self.window?.rootViewController = mainViewController
		} else {
		
			UIView.transitionWithView(self.window!,
									  duration: 0.25,
									   options: UIViewAnimationOptions.CurveEaseInOut,
									animations: { () -> Void in
									
						self.window!.rootViewController!.view.alpha = 0.0
				
				}, completion: { (done) -> Void in
				
					mainViewController!.view.alpha = 0.0
					self.window!.rootViewController = mainViewController!
			
					UIView.transitionWithView(self.window!,
											duration: 0.5,
											options: UIViewAnimationOptions.CurveEaseInOut,
										animations: { () -> Void in
										
					mainViewController!.view.alpha = 1.0
					
					}, completion: { (done) -> Void in
					
				})
			})
		
		}
	}

	func applicationWillResignActive(application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}

	func applicationWillEnterForeground(application: UIApplication) {
		// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}

	func applicationWillTerminate(application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}

	// MARK: Appearance
	func setAppearanceProxies() {
	//	UIBarButtonItem.appearance().tintColor = UIColor.blackColor()
	//	UINavigationBar.appearance().backgroundColor = UIColor.blackColor()
		UINavigationBar.appearance().tintColor = UIColor.whiteColor()
		UINavigationBar.appearance().barTintColor = UIColor.blackColor()
		UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
		
		UITabBar.appearance().barTintColor = UIColor.blackColor()
		UITabBar.appearance().tintColor = UIColor.whiteColor()
		UITabBar.appearance().translucent = true
		
		UIToolbar.appearance().barTintColor = UIColor.blackColor()
		UIToolbar.appearance().tintColor = UIColor.whiteColor()

		UIToolbar.appearance().translucent = true
	//	UIToolbar.appearance().setBackgroundImage(toolbarBackgroundImage(), forToolbarPosition: .Any, barMetrics: .Default)
	}
	
	
	private func toolbarBackgroundImage() -> UIImage {
		var transparentBackground: UIImage!
		UIGraphicsBeginImageContextWithOptions(CGSize(width: 1, height: 1), true, 1.0)
		var context = UIGraphicsGetCurrentContext()
		CGContextSetRGBFillColor(context, 1, 1, 1, 0)
		UIRectFill(CGRect(x: 0.0, y: 0.0, width: 0.0, height: 0.0))
		transparentBackground = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
		UIGraphicsEndImageContext()
		return transparentBackground
		//		toolBar.setBackgroundImage(transparentBackground, forToolbarPosition: .Any, barMetrics: .Default)
	}
	

}

