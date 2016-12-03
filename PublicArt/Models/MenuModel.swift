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
	case monuments
	case murals
	case plaques
	case sculpture
	case steel
	case statues
	case streetArt
}

enum CatagoryMenuOrder: Int {
	case monuments = 0
	case murals
	case plaques
	case sculpture
	case steel
	case statues
//	case StreetArt
	case countRows = 6
}

struct CatagoryMenuItem {
	
	func value(_ catagoryMenuOrder: CatagoryMenuOrder) -> (title: String, tag: String) {
		var title = ""
		var tag = ""
		switch(catagoryMenuOrder) {
		case .monuments:
			title = "Monuments"
			tag = "Monument"
		case .murals:
			title = "Murals"
			tag = "Mural"
		case .plaques:
			title = "Plaques"
			tag = "Plaque"
		case .sculpture:
			title = "Sculpture"
			tag = "Sculpture"
		case .steel:
			title = "Steel"
			tag = "Steel"
		case .statues:
			title = "Statues"
			tag = "Statue"
//		case .StreetArt:
//			title = "StreetArt"
//			tag = "StreetArt"
		default:
			title = ""
			tag = ""
		}
		return (title, tag)
	}
	
}



// MARK: Discover

enum MainMenuType {
	case artists
	case catagory
	case neighborhoods
	case titles
	case medium
	case favorites
}

enum MainMenuRow: Int {
	case artists = 1
	case catagory = 4
	case neighborhoods = 2
	case titles = 0
	case medium = 3
	case favorites = 5
	case countRows = 6
}

struct MainMenuItem {
	var title = ""
	var image = UIImage()
	
}

struct MainMenu {
	
	func item(_ mainMenuType: MainMenuType) -> MainMenuItem {
		var title = ""
		var image = UIImage()
		switch(mainMenuType) {
		case .artists:
			image = UIImage(named: "FlutePlayers") ?? image
			title = "Artists"
		case .catagory:
			image = UIImage(named: "LionClose") ?? image
			title = "Catagories"
		case .neighborhoods:
			image = UIImage(named: "IMG_0951") ?? image
			title = "Locations"
		case .titles:
			image = UIImage(named: "IMG_5037") ?? image
			title = "Titles"
		case .medium:
			image = UIImage(named: "IMG_5838") ?? image
			title = "Media"
		case .favorites:
		//	image = UIImage(named: "SixteenthAveTiledStepsCropped") ?? image
			image = UIImage.imageWithColor(UIColor.black)
			title =  ""
		}
		
		return MainMenuItem(title: title, image: image)
	}
	

	
}

