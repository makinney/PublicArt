//
//  MappingIdentifiers.swift
//  ArtCity
//
//  Created by Michael Kinney on 1/22/15.
//  Copyright (c) 2015 mkinney. All rights reserved.
//

import Foundation

/* Valid mapping coordinates
Latitudes range from -90 to 90.
Longitudes range from -180 to 180.
*/
struct ArtCityMap { // anything other than the above
	static let centerLatitude = 37.77
	static let centerLongitude = -122.42
	static let maxlatitude = 37.81303879
	static let minlatitude = 37.70310882
	static let maxlongitude = -122.35507965
	static let minlongitude = -122.51901627
	static let NotOnEarthSphereLatitude = 91.0
	static let NotOnEarthSphereLongitude = -181.0
}

