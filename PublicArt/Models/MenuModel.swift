//
//  MenuModel.swift
//  PublicArt
//
//  Created by Michael Kinney on 6/5/15.
//  Copyright (c) 2015 makinney. All rights reserved.
//

import Foundation
import UIKit

// MARK: Catagory

enum CatagoryType {
	case All
	case Monuments
	case Murals
	case Plagues
	case Sculpture
	case Statues
	case StreetArt
}

enum CatagoryMenuOrder: Int {
	case All = 0
	case Monuments = 1
	case Murals = 2
	case Plagues = 3
	case Sculpture = 4
	case Statues = 5
	case StreetArt = 6
	case CountRows = 7
}

struct CatagoryMenuTitles {
	
	func title(catagoryType: CatagoryType) -> String {
		var title = ""
		switch(catagoryType) {
		case .All:
			title = "All"
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

// MARK: Discover

enum MainMenuType {
	case Artists
	case Catagory
	case Neighborhoods
	case Titles
	case Medium
	case Favorites
}

enum MainMenuRow: Int {
	case Artists = 3
	case Catagory = 2
	case Neighborhoods = 1
	case Titles = 0
	case Medium = 4
	case Favorites = 5
	case CountRows = 6
}

struct MainMenuItem {
	var title = ""
	var image = UIImage()
	
}

struct MainMenu {
	
	func item(mainMenuType: MainMenuType) -> MainMenuItem {
		var title = ""
		var image = UIImage()
		switch(mainMenuType) {
		case .Artists:
			image = UIImage(named: "PianoPlayer") ?? image
			title = "Artists"
		case .Catagory:
			image = UIImage(named: "catagories2") ?? image
			title = "Catagories"
		case .Neighborhoods:
			image = UIImage(named: "Locations1") ?? image
			title = "Locations"
		case .Titles:
			image = UIImage(named: "SphinxCropped") ?? image
			title = "All Public Art"
		case .Medium:
			image = UIImage(named: "mediumRedStone") ?? image
			title = "Medium"
		case .Favorites:
			image = UIImage(named: "SixteenthAveTiledStepsCropped") ?? image
			title =  "Favorites"
		default:
			title = ""
		}
		
		return MainMenuItem(title: title, image: image)
	}
	

	
}

