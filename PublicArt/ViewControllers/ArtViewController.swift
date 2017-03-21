//
//  ArtViewController.swift
//  PublicArt
//
//  Created by MAKinney on 3/20/17.
//  Copyright © 2017 makinney. All rights reserved.
//

import UIKit





class ArtViewController: UIViewController {
    
    @IBOutlet weak var mapContainer: UIView!
    @IBOutlet weak var dLabel1: UILabel!
    @IBOutlet weak var dLabel2: UILabel!
    @IBOutlet weak var dLabel3: UILabel!
    @IBOutlet weak var dLabel4: UILabel!
    @IBOutlet weak var dLabel5: UILabel!
    @IBOutlet weak var artTitle: UILabel!
    @IBOutlet weak var mapToolbar: UIToolbar!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var singleArtMapViewController: SingleArtMapViewController?
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    

    var art: Art? {
        didSet {
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareMapToolbarItems()
        scrollView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateDetails()
    }
    
    func updateDetails() {
        dLabel1.text = "Artist - "
        dLabel2.text = "Medium - "
        dLabel3.text = "Dimensions - "
        dLabel4.text = "Location - "
        dLabel5.text = "Address - "
        if let art = art,
           let artist = art.artist {
            artTitle.text = art.title
            dLabel1.text! += artist.firstName + " " + artist.lastName
            dLabel2.text! += art.medium
            dLabel3.text! += art.dimensions
            dLabel4.text! += art.location.name
            dLabel5.text! += art.address
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let singleArtMapViewController = segue.destination as? SingleArtMapViewController {
            self.singleArtMapViewController = singleArtMapViewController
            self.singleArtMapViewController!.art = art
        } else if let photosPageViewController = segue.destination as? PhotosPageViewController {
            if let art = art,
                let photoSet: Set<Photo> = art.photos as? Set {
                photosPageViewController.photos = convertToSortedArray(photoSet)
            }

        }
    }

}

// Mapping Controls
//
extension ArtViewController {
    
    var routeBarButtonItem: UIBarButtonItem {
        let image = UIImage(named: "DirectionsArrow")
        return UIBarButtonItem(image:image, style: .plain, target:self, action: #selector(ArtViewController.onRouteButton(_:)))
    }
    var flexibleSpaceBarButtonItem: UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    }
    
    var infoBarButtonItem: UIBarButtonItem {
        let image = UIImage(named: "toolbar-infoButton")
        return UIBarButtonItem(image:image, style: .plain, target:self, action: #selector(ArtViewController.onInfoButton(_:)))
    }
    
    var locateMeBarButtonItem: UIBarButtonItem {
        let image = UIImage(named: "toolbar-arrow")
        return UIBarButtonItem(image:image, style: .plain, target:self, action: #selector(ArtViewController.onLocateMeButton(_:)))
    }

    
    func prepareMapToolbarItems() {
        let bottomItems = [routeBarButtonItem,flexibleSpaceBarButtonItem, locateMeBarButtonItem, flexibleSpaceBarButtonItem, infoBarButtonItem]
        mapToolbar.items = bottomItems
    }
    
    func onLocateMeButton(_ barbuttonItem: UIBarButtonItem ) {
        singleArtMapViewController?.onLocateMeButton(barbuttonItem)
    }
    
    func onRouteButton(_ barbuttonItem: UIBarButtonItem ) {
        singleArtMapViewController?.onRouteButton(barbuttonItem)
    }

    func onInfoButton(_ barbuttonItem: UIBarButtonItem ) {
        singleArtMapViewController?.onInfoButton(barbuttonItem)
    }

    
}
