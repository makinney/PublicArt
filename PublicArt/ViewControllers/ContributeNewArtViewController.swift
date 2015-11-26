//
//  ContributeNewArtViewController.swift
//  PublicArt
//
//  Created by Michael Kinney on 7/24/15.
//  Copyright (c) 2015 makinney. All rights reserved.
//

import UIKit
import Parse

class ContributeNewArtViewController: UIViewController {

	var fetcher = Fetcher(managedObjectContext: CoreDataStack.sharedInstance.managedObjectContext!)

	@IBAction func submitTouched(sender: UIButton) {
//		submit()
	}
	
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

	private func submit() {
//		let art = fetcher.fetchArt("50091")!
//		let photos: [Photo] = fetcher.fetchPhotosFor("50091")!
//		let photo = photos.last
//		if let thumb = art.thumb {
//			ImageDownload.downloadPhoto(photo!, complete: { (data, imageFileName) -> () in
//				if let data = data {
//					let imageFile = PFFile(name:"theaterHighRes.jpg", data:data)
//					let userPhoto = ParseUserPhoto()
//					userPhoto.idArt = "50091"
//					userPhoto.imageFile = imageFile
//					userPhoto.saveInBackground()
//				}
//			})
//		
//		}
//	
	}
	
}
