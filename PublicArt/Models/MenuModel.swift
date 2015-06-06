//
//  MenuModel.swift
//  PublicArt
//
//  Created by Michael Kinney on 6/5/15.
//  Copyright (c) 2015 makinney. All rights reserved.
//

import Foundation

enum ExploreCatagoryType {
	case Artists
	case Monuments
	case Murals
	case Plagues
	case Sculpture
	case Statues
	case StreetArt
}

enum ExploreCatagoryMenuRow: Int {
	case Artists = 0
	case Monuments = 1
	case Murals = 2
	case Plagues = 3
	case Sculpture = 4
	case Statues = 5
	case StreetArt = 6
	case CountRows = 7
}


struct ExploreCatagoryTitles {
	
	func title(exploreCatagoryType: ExploreCatagoryType) -> String {
		var title = ""
		switch(exploreCatagoryType) {
		case .Artists:
			title = "Artists"
		case .Monuments:
			title = "Monuments"
		case .Murals:
			title = "Murals"
		case .Plagues:
			title = "Plagues"
		case .Sculpture:
			title = "Sculpture"
		case .Statues:
			title = "Statues"
		case .StreetArt:
			title = "StreetArt"
		default:
			title = ""
		}
		
		return title
	}
	
}