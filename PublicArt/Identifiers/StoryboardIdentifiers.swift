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
	case ArtTitleToWebView = "ArtTitleToWebViewID"
	case ArtistToWebView = "ArtistToWebViewID"
	case CityMapsListToCityMap = "idCityMapsListToCityMap"
	case CityMapsListToCityMapNavController = "idCityMapsListToCityMapNavController"
	case SubTopicListToArt = "idSubTopicListToArt"
	case TopicListToArt = "idTopicListToArt"
	case TopicListToSubTopicList = "idTopicListToSubTopicList"
}

enum ViewControllerIdentifier: String { // TODO: make these consistent
	case MainViewController = "MainTabBarControllerID"
	case ArtPiecesViewController = "ArtPiecesViewControllerID"
	case CityMapsViewController = "CityMapsViewControllerID"
	case LocationCollectionViewController = "LocationCollectionViewControllerID"
	case CatagoryCollectionViewController = "ExploreCollectionViewControllerID"
	case ArtViewController = "ArtViewControllerID"
	case SingleArtViewController = "SingleArtViewControllerID"
}

enum WelcomeIdentifier: String {
	case WelcomeViewController = "WelcomeViewControllerID"
	case PublicViewController = "WelcomePublicViewControllerID"
	case BrowseViewController = "WelcomeBrowseViewControllerID"
	case ExploreViewController = "WelcomeExploreViewControllerID"
	case DiscoverViewController = "WelcomeDiscoverViewControllerID"
	case ContributeViewController = "WelcomeContributeViewControllerID"
}

