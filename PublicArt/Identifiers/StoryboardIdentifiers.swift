//
//  StoryboardIdentifiers.swift
//  San Francisco Artwork
//
//  Created by Michael Kinney on 11/17/14.
//  Copyright (c) 2014 mkinney. All rights reserved.
//
// TODO: remove any unused ids

import Foundation

enum CellIdentifier: String {
	case ArtworkCollectionViewCell = "ArtworkCollectionViewCell"
	case LocationCollectionViewCell = "LocationCollectionViewCell"
	case ArtTableViewCellID = "ArtTableViewCell"
	case MapTableViewCellID = "MapTableViewCell"
	case NeighborhoodListCell = "neighborhoodListCell"
	case SingleArtPhotosCollectionViewCell = "SingleArtPhotosCollectionViewCell"
	case TitleListCell = "TitleListCell"
}

enum SegueIdentifier: String {
	case ArtToPhoto = "idArtToPhoto"
	case ArtToMap = "idArtToMap"
	case ArtListToArtNav = "idArtListToArtNav"
	case CityMapsListToCityMap = "idCityMapsListToCityMap"
	case CityMapsListToCityMapNavController = "idCityMapsListToCityMapNavController"
	case SubTopicListToArt = "idSubTopicListToArt"
	case TopicListToArt = "idTopicListToArt"
	case TopicListToSubTopicList = "idTopicListToSubTopicList"
}

enum ViewControllerIdentifier: String { // TODO: make these consistent
	case ArtPiecesViewController = "ArtPiecesViewControllerID"
	case LocationCollectionViewController = "LocationCollectionViewControllerID"

/*
	case ArtViewController = "idArtViewController"
	case ArtNavigationController = "idArtNavigationController"
	case CityMapsListViewController = "idCityMapsListViewController"
	case CityMapsViewController = "idCityMapsViewController"
	case CityMapsNavigationController = "idCityMapsNavigationController"
	case GridCollectionViewController = "GridCollectionViewController"
	case MapViewController = "MapViewController"
	case PhotoCollectionViewController = "PhotoCollectionViewController"
	case PhotoViewController = "PhotoViewController"
	case SingleArtViewController = "idSingleArtViewController"
	case SubTopicListViewController = "idSubTopicListViewController"
	case TopicListViewController = "idTopicListViewController"
	*/
}

