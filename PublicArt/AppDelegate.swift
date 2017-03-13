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

	let didShowLandingScreenKey = "DidShowWelcomeScreenKey"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
	var artDataManager: ArtDataManager?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		self.window = UIWindow(frame: UIScreen.main.bounds)
		
	//	self.useWelcomeAsRoot()

		if UserDefaults.standard.bool(forKey: didShowLandingScreenKey) {
			self.normalWindowRoot(animate:false)
		} else {
			self.useWelcomeAsRoot()
		}
		self.window?.makeKeyAndVisible()

		setAppearanceProxies()

        let configuration = ParseClientConfiguration {
            $0.applicationId = "com.makinney.PublicArt"
            $0.clientKey = "x4$3BcFjKl_46"
            $0.server = "https://whispering-taiga-34196.herokuapp.com/parse"
            $0.isLocalDatastoreEnabled = true;
        }
        Parse.initialize(with: configuration)
		ParsePhoto.registerSubclass()
		ParseArtist.registerSubclass()
		ParseArt.registerSubclass()
		ParseLocation.registerSubclass()
		
        ArtRefresh.artRefreshFromServerRequired {[weak self] (required, clientLastRefreshed, serverLastRefreshed) -> () in
            if required {
                self?.artDataManager = ArtDataManager(coreDataStack: CoreDataStack.sharedInstance)
                if let clientLastRefreshed = clientLastRefreshed,
                    let serverLastRefreshed = serverLastRefreshed {
                    self?.artDataManager!.refresh(clientLastRefreshed, endingAtDate: serverLastRefreshed)
                } else if let serverLastRefreshed = serverLastRefreshed { // no client refresh, very first data download
                    let initialUpdate: Date = Date.distantPast // make sure to get everything
                    self?.artDataManager!.refresh(initialUpdate, endingAtDate: serverLastRefreshed)
                }
            }
        }
        
		return true
	}
    
  	
	func useWelcomeAsRoot() {
		let welcomeViewController = UIStoryboard(name: "Welcome", bundle: nil).instantiateViewController(withIdentifier: WelcomeIdentifier.WelcomeViewController.rawValue) as? WelcomeViewController
		self.window?.rootViewController = welcomeViewController
	}
	
	func normalWindowRoot(animate: Bool) {
		let mainViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: ViewControllerIdentifier.MainViewController.rawValue) as? UITabBarController
		mainViewController!.view.backgroundColor = UIColor.black
		if animate == false {
			self.window?.rootViewController = mainViewController
		} else {
		
			UIView.transition(with: self.window!,
									  duration: 0.25,
									   options: UIViewAnimationOptions(), // FIXME: Swift 3 .CurveEaseInOut
									animations: { () -> Void in
									
						self.window!.rootViewController!.view.alpha = 0.0
				
				}, completion: { (done) -> Void in
				
					mainViewController!.view.alpha = 0.0
					self.window!.rootViewController = mainViewController!
			
					UIView.transition(with: self.window!,
											duration: 0.5,
											options: UIViewAnimationOptions(),  // FIXME: Swift 3  . CurveEaseInOut
										animations: { () -> Void in
										
					mainViewController!.view.alpha = 1.0
					
					}, completion: { (done) -> Void in
					
				})
			})
		
		}
	}

	func applicationWillResignActive(_ application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}

	func applicationWillEnterForeground(_ application: UIApplication) {
		// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}

	func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}
	
	// MARK: Appearance
	func setAppearanceProxies() {
	
		UICollectionView.appearance().backgroundColor = UIColor.black
	//	UIBarButtonItem.appearance().tintColor = UIColor.blackColor()
	//	UINavigationBar.appearance().backgroundColor = UIColor.blackColor()
  
		UINavigationBar.appearance().tintColor = UIColor.white
		UINavigationBar.appearance().barTintColor = UIColor.black
		UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white,
															NSFontAttributeName: UIFont.systemFont(ofSize: 20)]
		
		UITabBar.appearance().barTintColor = UIColor.black
		UITabBar.appearance().tintColor = UIColor.white
	//	UITabBar.appearance().translucent = true
		
		UIToolbar.appearance().barTintColor = UIColor.black
		UIToolbar.appearance().tintColor = UIColor.white

	//	UIToolbar.appearance().translucent = true
	//	UIToolbar.appearance().setBackgroundImage(toolbarBackgroundImage(), forToolbarPosition: .Any, barMetrics: .Default)
	}
	
	
	fileprivate func toolbarBackgroundImage() -> UIImage {
		var transparentBackground: UIImage!
		UIGraphicsBeginImageContextWithOptions(CGSize(width: 1, height: 1), true, 1.0)
		let context = UIGraphicsGetCurrentContext()
		context?.setFillColor(red: 1, green: 1, blue: 1, alpha: 0)
		UIRectFill(CGRect(x: 0.0, y: 0.0, width: 0.0, height: 0.0))
		transparentBackground = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
		UIGraphicsEndImageContext()
		return transparentBackground
		//		toolBar.setBackgroundImage(transparentBackground, forToolbarPosition: .Any, barMetrics: .Default)
	}
	

}

