//
//  ArtistHelper.swift
//  PublicArt
//
//  Created by Michael Kinney on 7/21/15.
//  Copyright (c) 2015 makinney. All rights reserved.
//

import Foundation

func artistFullName(artist: Artist) -> String {
	var name = String()
	if count(artist.firstName) > 1 {
		name = artist.firstName + " "
	}
	if count(artist.lastName) > 1 {
		name += artist.lastName
	}
	return name
}