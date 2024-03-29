//
//  ArtMapPins.swift
//  ArtCity
//
//  Created by Michael Kinney on 2/28/15.
//  Copyright (c) 2015 mkinney. All rights reserved.
//

import Foundation

class ArtMapPins {
	
	init() {
	
	}
	
	var letterGroups = [["a","k","c"],
				   ["d","e","f"],
				   ["g","h","i"],
				   ["j","b","l"],
				   ["m","n","o"],
				   ["p","q","r"],
				   ["s","t","u"],
				   ["v","w","x","y","z"]]
	
	var imageNames = ["map-letter1",
					  "map-letter2",
					  "map-letter3",
					  "map-letter4",
					  "map-letter5",
					  "map-letter6",
					  "map-letter7",
					  "map-letter8"]
	
	var defaultImageName = "map-letter8"
	
	func imageNameFor(_ text: String) -> String {
		var imageName = defaultImageName
//		var imageIndex = 0
//		let letter = getFirstLetterAsLowerCase(text)
//		for letterGroupIndex in 0..<letterGroups.count {
//			let letterGroup:[String] = letterGroups[letterGroupIndex]
//			for (letterIndex,groupLetter) in letterGroup.enumerate(){
//				if groupLetter == letter {
//					imageIndex = letterIndex
////					println("letter is \(letter)")
//					break
//				}
//			}
//		}
//		if imageIndex < imageNames.count {
//			imageName = imageNames[imageIndex]
////			println("imageName is \(imageName) letter \(letter) text \(text)")
//		} else {
////			println("using default letter")
//		}
		
		imageName = "map-letter3"
		return imageName
	}
	
	func getFirstLetterAsLowerCase(_ text: String) -> String {
		let first: String = String(text[text.startIndex])
		return first.lowercased()
	}
	
	
}
