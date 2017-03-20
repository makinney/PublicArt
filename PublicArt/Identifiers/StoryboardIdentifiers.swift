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
	case CategoryCollectionViewCell = "CategoryCollectionViewCell"
	case MediaCollectionViewCell = "MediaCollectionViewCell"
	case ArtTableViewCellID = "ArtTableViewCell"
	case MapTableViewCellID = "MapTableViewCell"
	case NeighborhoodListCell = "neighborhoodListCell"
	case SingleArtPhotosCollectionViewCell = "SingleArtPhotosCollectionViewCell"
	case TitleListCell = "TitleListCell"
}

enum SegueIdentifier: String {
	case SingleImageToImageCollection = "SingleImageToImageCollectionID"
	case ArtToMap = "idArtToMap"
	case ButtonToMap = "ButtonToMapID"
	case MainMenuToMediaSegue = "MainMenuToMediaSegueID"
    case artPiecesToArtViewSeque = "ArtPiecesToArtViewSeque"
	case ArtListToArtNav = "idArtListToArtNav"
	case ArtTitleToWebView = "ArtTitleToWebViewID"
	case ArtTitleInfoButtonToWebView = "ArtTitleInfoButtonToWebViewID"
	case ArtistToWebView = "ArtistToWebViewID"
	case ArtistInfoButtonToWebView = "ArtistInfoButtonToWebViewID"
	case CityMapsListToCityMap = "idCityMapsListToCityMap"
	case CityMapsListToCityMapNavController = "idCityMapsListToCityMapNavController"
	case SubTopicListToArt = "idSubTopicListToArt"
	case TopicListToArt = "idTopicListToArt"
	case TopicListToSubTopicList = "idTopicListToSubTopicList"
}

enum ViewControllerIdentifier: String { // TODO: make these consistent
	case MainViewController = "MainTabBarControllerID"
    case ArtViewController = "ArtViewController"
	case ArtPiecesViewController = "ArtPiecesViewControllerID"
	case ArtistCollectionViewController = "ArtistCollectionViewControllerID"
	case CityMapsViewController = "CityMapsViewControllerID"
	case LocationCollectionViewController = "LocationCollectionViewControllerID"
	case CatagoryCollectionViewController = "ExploreCollectionViewControllerID"
	case SingleArtViewController = "SingleArtViewControllerID"
	case MediaCollectionViewController = "MediaCollectionViewControllerID"
	case TitlesCollectionViewController = "TitlesCollectionViewControllerID"
}

enum WelcomeIdentifier: String {
	case WelcomeViewController = "WelcomeViewControllerID"
	case PublicViewController = "WelcomePublicViewControllerID"
	case BrowseViewController = "WelcomeBrowseViewControllerID"
	case ExploreViewController = "WelcomeExploreViewControllerID"
	case DiscoverViewController = "WelcomeDiscoverViewControllerID"
	case ContributeViewController = "WelcomeContributeViewControllerID"
}

