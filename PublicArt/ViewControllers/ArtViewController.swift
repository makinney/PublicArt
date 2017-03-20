//
//  ArtViewController.swift
//  PublicArt
//
//  Created by MAKinney on 3/20/17.
//  Copyright © 2017 makinney. All rights reserved.
//

import UIKit





class ArtViewController: UIViewController {
    
    @IBOutlet weak var dLabel1: UILabel!
    @IBOutlet weak var dLabel2: UILabel!
    @IBOutlet weak var dLabel3: UILabel!
    @IBOutlet weak var dLabel4: UILabel!
    @IBOutlet weak var dLabel5: UILabel!
    @IBOutlet weak var artTitle: UILabel!
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    

    var art: Art? {
        didSet {
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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

    
}
