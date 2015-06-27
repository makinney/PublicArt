//
//  MapTableViewCell.swift
//  City Art San Francisco
//
//  Created by Michael Kinney on 1/2/2015
//  Copyright (c) 2014 mkinney. All rights reserved.
//

import UIKit

class MapTableViewCell: UITableViewCell {


//	@IBOutlet weak var mapImageView: UIImageView!

	@IBOutlet weak var locationName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
//		self.backgroundColor = self.contentView.backgroundColor
//		self.contentView.backgroundColor = UIColor.clearColor()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
