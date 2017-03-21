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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateDetails()
    }
    
    func updateDetails() {
        if let art = art,
           let artist = art.artist {
            artTitle.text = art.title
            dLabel1.text = "Artist : " + artist.firstName + " " + artist.lastName
            dLabel2.text = "Medium : " + art.medium
            dLabel3.text = "Dimensions : " + art.dimensions
            dLabel4.text = "Location : " + art.location.name
            dLabel5.text = "Address : " + art.address
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let singleArtMapViewController = segue.destination as? SingleArtMapViewController {
            self.singleArtMapViewController = singleArtMapViewController
            self.singleArtMapViewController!.art = art
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
