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
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scrollView.zoomScale = 1.0
        scrollView.contentSize = imageView.bounds.size

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

extension PhotoViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
