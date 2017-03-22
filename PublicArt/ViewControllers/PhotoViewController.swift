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
    var noPhotoImage: UIImage?
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let photo = photo {
            activityIndicator.startAnimating()
            PhotoImages.sharedInstance.getImage(photo, complete: {[weak self] (image, imageFileName) -> () in
                self?.activityIndicator.stopAnimating()
                if let image = image, imageFileName == photo.imageFileName {
                    self?.imageView.image = image
                }
            })
        } else {
            imageView.image = noPhotoImage
        }
    }
}
