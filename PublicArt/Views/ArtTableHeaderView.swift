//
//  ArtTableHeaderView.swift
//  ArtCity
//
//  Created by Michael Kinney on 2/7/15.
//  Copyright (c) 2015 mkinney. All rights reserved.
//

import UIKit

class ArtTableHeaderView: UITableViewHeaderFooterView {

	@IBOutlet weak var title: UILabel!
	
	   override func awakeFromNib() {
        super.awakeFromNib()
		self.backgroundColor = self.title.backgroundColor
//		self.title.backgroundColor = UIColor.clearColor()
    }
}
