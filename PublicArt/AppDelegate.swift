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
		var welcomeViewController = UIStoryboard(name: "Welcome", bundle: nil).instantiateViewControllerWithIdentifier(WelcomeIdentifier.WelcomeViewController.rawValue) as? WelcomeViewController
		self.window?.rootViewController = welcomeViewController
		self.window?.makeKeyAndVisible()

		
		//
		Parse.enableLocalDatastore()
		ParsePhoto.registerSubclass()
		ParseArtist.registerSubclass()
		ParseArt.registerSubclass()
		ParseLocation.registerSubclass()
		
		Parse.setApplicationId("SL4Z3PKg3yQMNDgiZOWzO6QYdrfSXaiyefVnesqS",
			clientKey: "M2nmbAOma1185BZDslTSqnWGmScwGHXkswt5Ea8e")
		
		artDataManager = ArtDataManager(coreDataStack: CoreDataStack.sharedInstance)
		artDataManager!.refresh()

	
		return true
	}
	
	func useWelcomeAsRoot() {
		
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


}

