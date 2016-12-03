//
//  ArtistHelper.swift
//  PublicArt
//
//  Created by Michael Kinney on 7/21/15.
//  Copyright (c) 2015 makinney. All rights reserved.
//

import Foundation

func artistFullName(_ artist: Artist) -> String {
	var name = String()
	if artist.firstName.characters.count > 1 {
		name = artist.firstName + " "
	}
	if artist.lastName.characters.count > 1 {
		name += artist.lastName
	}
	return name
}
