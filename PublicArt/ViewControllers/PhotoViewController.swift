//
//  PhotoViewController.swift
//  PublicArt
//
//  Created by MAKinney on 3/21/17.
//  Copyright © 2017 makinney. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var photo: Photo?
    var page: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let photo = photo {
            PhotoImages.sharedInstance.getImage(photo, complete: {[weak self] (image, imageFileName) -> () in
                if let image = image, imageFileName == photo.imageFileName {
                    self?.imageView.image = image
                }
            })
        }
    }
}
