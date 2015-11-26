//
//  WelcomeContributeViewController.swift
//  PublicArt
//
//  Created by Michael Kinney on 6/28/15.
//  Copyright (c) 2015 makinney. All rights reserved.
//

import UIKit

class WelcomeContributeViewController: UIViewController {

	@IBAction func onContinueButton(sender: AnyObject) {
	
	 let app =	UIApplication.sharedApplication().delegate as! AppDelegate
	 app.normalWindowRoot(animate: true)
	 

	
	}
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
