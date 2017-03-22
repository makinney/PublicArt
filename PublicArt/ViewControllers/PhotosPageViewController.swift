//
//  PhotosPageViewController.swift
//  PublicArt
//
//  Created by MAKinney on 3/20/17.
//  Copyright © 2017 makinney. All rights reserved.
//

import UIKit

class PhotosPageViewController: UIPageViewController {

    var photos = [Photo]() {
        didSet {
            pageCount = photos.count
        }
    }
    var pageCount = 0
   
    override func viewDidLoad() {
        super.viewDidLoad()
        if photos.count > 0 {
            setViewControllers([photoViewController(0)], direction: .forward, animated: false, completion: nil)
        } else { // hack solution for no photos, just to get this app out
            pageCount = 1
            setViewControllers([photoViewController(0)], direction: .forward, animated: false, completion: nil)
        }
        dataSource = self
    }
    
    fileprivate func photoViewController(_ inPage: Int) -> PhotoViewController {
        let photoViewController = storyboard!.instantiateViewController(withIdentifier: "PhotoViewController") as! PhotoViewController
        let page = min(max(0, inPage), pageCount-1)
        photoViewController.page = page
        if page < photos.count {
            photoViewController.photo = photos[page]
        } else {
            photoViewController.noPhotoImage = UIImage(named: "noThumb")
        }
        return photoViewController
    }
}

extension PhotosPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let currentPage = viewController as? PhotoViewController {
            if currentPage.page < pageCount - 1 {
                return photoViewController(currentPage.page + 1)
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let currentPage = viewController as? PhotoViewController {
            if currentPage.page > 0 {
                return photoViewController(currentPage.page - 1)
            }
        }
        return nil
    }
}

    

