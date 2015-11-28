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
	case Monuments
	case Murals
	case Plagues
	case Sculpture
	case Site
	case Statues
	case StreetArt
}

enum CatagoryMenuOrder: Int {
	case Monuments = 0
	case Murals
	case Plagues
	case Sculpture
	case Site
	case Statues
//	case StreetArt
	case CountRows = 6
}

struct CatagoryMenuItem {
	
	func value(catagoryMenuOrder: CatagoryMenuOrder) -> (title: String, tag: String) {
		var title = ""
		var tag = ""
		switch(catagoryMenuOrder) {
		case .Monuments:
			title = "Monuments"
			tag = "Monument"
		case .Murals:
			title = "Murals"
			tag = "Mural"
		case .Plagues:
			title = "Plagues"
			tag = "Plague"
		case .Sculpture:
			title = "Sculpture"
			tag = "Sculpture"
		case .Site:
			title = "Site Specfic"
			tag = "Site"
		case .Statues:
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
	case Artists
	case Catagory
	case Neighborhoods
	case Titles
	case Medium
	case Favorites
}

enum MainMenuRow: Int {
	case Artists = 4
	case Catagory = 2
	case Neighborhoods = 0
	case Titles = 3
	case Medium = 1
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
			image = UIImage(named: "SunYatSen") ?? image
			title = "Artists"
		case .Catagory:
			image = UIImage(named: "LionClose") ?? image
			title = "Catagories"
		case .Neighborhoods:
			image = UIImage(named: "NorthBeachAlley") ?? image
			title = "Locations"
		case .Titles:
			image = UIImage(named: "SphinxCropped") ?? image
			title = "Titles"
		case .Medium:
			image = UIImage(named: "FlutePlayers") ?? image
			title = "Media"
		case .Favorites:
		//	image = UIImage(named: "SixteenthAveTiledStepsCropped") ?? image
			image = UIImage.imageWithColor(UIColor.blackColor())
			title =  ""
		}
		
		return MainMenuItem(title: title, image: image)
	}
	

	
}

