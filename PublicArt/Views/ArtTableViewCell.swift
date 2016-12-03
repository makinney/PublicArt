//
//  ArtTableViewCell.swift
//  City Art San Francisco
//
//  Created by Michael Kinney on 12/2/14.
//  Copyright (c) 2014 mkinney. All rights reserved.
//

import UIKit

class ArtTableViewCell: UITableViewCell {


	@IBOutlet weak var artView: UIImageView!
	
	@IBOutlet weak var label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
		self.backgroundColor = self.contentView.backgroundColor
//		self.contentView.backgroundColor = UIColor.clearColor()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
