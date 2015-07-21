//
//  ArtistCollectionViewController.Swift
//  PublicArt
//
//  Created by Michael Kinney on 7/13/15.
//  Copyright (c) 2015 makinney. All rights reserved.
//

import UIKit
import CoreData

final class ArtistCollectionViewController: UICollectionViewController {

	// MARK: Properties
	private var artPiecesCollectionViewController: ArtPiecesCollectionViewController?
	private var collapseDetailViewController = true
	private var fetcher: Fetcher!
	private var initialHorizontalSizeClass: UIUserInterfaceSizeClass?
	private var maxCellWidth: CGFloat = 0.0
	private var error:NSError?
	private let moc: NSManagedObjectContext?
	private var artists = [Artist]()
	private var userInterfaceIdion: UIUserInterfaceIdiom = .Phone
	
	override init(collectionViewLayout: UICollectionViewLayout) {
		moc = CoreDataStack.sharedInstance.managedObjectContext
		fetcher = Fetcher(managedObjectContext: moc!)
		super.init(collectionViewLayout: collectionViewLayout)
	}
	
	required init(coder aDecoder: NSCoder) {
		moc = CoreDataStack.sharedInstance.managedObjectContext
		fetcher = Fetcher(managedObjectContext: moc!)
		super.init(coder:aDecoder)
	}
	
	deinit {
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = "Artists" // TITLE
		
		var nibName = UINib(nibName: CellIdentifier.MediaCollectionViewCell.rawValue, bundle: nil) // TODO:
		self.collectionView?.registerNib(nibName, forCellWithReuseIdentifier: CellIdentifier.MediaCollectionViewCell.rawValue)
		setupArtistsFlowLayout()
		
		fetchResultsController.delegate = self
		fetchResultsController.performFetch(&error)
		if let art = fetchResultsController.fetchedObjects as? [Art] {
			self.artists = getArtistsFrom(art)
		}
		collectionView?.reloadData()
		
	}
	
	func getArtistsFrom(artwork: [Art]) -> [Artist] {
		var artists = [Artist]()
		var lastName = String()
		for art in artwork {
			if let artist = art.artist {
				if artist.lastName != lastName {
						artists.append(art.artist!)
						lastName = artist.lastName
				}
			}
		}
		return artists
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
	}
	
	override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
		setupArtistsFlowLayout()
		collectionView?.reloadData()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		println("\(__FILE__) \(__FUNCTION__)")
	}
	
	// MARK: Fetch Results Controller
	//
	lazy var fetchResultsController:NSFetchedResultsController = {
		let fetchRequest = NSFetchRequest(entityName:ModelEntity.art)
		let sortDescriptor = [NSSortDescriptor(key:"artist.lastName", ascending:true, selector: "localizedStandardCompare:")]
		fetchRequest.sortDescriptors = sortDescriptor
		let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.moc!, sectionNameKeyPath: nil, cacheName: nil)
		return frc
		}()
	
	// MARK: - Navigation
	
	func setupArtistsFlowLayout() {
		if let collectionViewFlowLayout: UICollectionViewFlowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
			collectionViewFlowLayout.scrollDirection = .Vertical
			var masterViewsWidth = splitViewController?.primaryColumnWidth ?? 100
			collectionViewFlowLayout.headerReferenceSize = CGSize(width: 0, height: 0)
			
			collectionViewFlowLayout.minimumLineSpacing = 5
			var minimumCellsPerLine = 2 // ultimately up to flow layout
			
			userInterfaceIdion = traitCollection.userInterfaceIdiom
			if userInterfaceIdion == .Phone || userInterfaceIdion == .Unspecified {
				let sectionInset: CGFloat = 5.0
				collectionViewFlowLayout.sectionInset.left = sectionInset
				collectionViewFlowLayout.sectionInset.right = sectionInset
				let itemSpacing: CGFloat = sectionInset / 2.0
				collectionViewFlowLayout.minimumInteritemSpacing = itemSpacing
				
				
				minimumCellsPerLine = 1
				maxCellWidth = cellWidthToUse(masterViewsWidth, cellsPerLine: minimumCellsPerLine, itemSpacing: itemSpacing, flowLayout: collectionViewFlowLayout)
				collectionViewFlowLayout.itemSize = CGSize(width: maxCellWidth, height: maxCellWidth / 8.0) // TODO: hard constant hack for aspect ratio
			} else {
				let sectionInset: CGFloat = 5.0
				collectionViewFlowLayout.sectionInset.left = sectionInset
				collectionViewFlowLayout.sectionInset.right = sectionInset
				let itemSpacing: CGFloat = sectionInset / 2.0
				collectionViewFlowLayout.minimumInteritemSpacing = itemSpacing
				minimumCellsPerLine = 1
				maxCellWidth = cellWidthToUse(masterViewsWidth, cellsPerLine: minimumCellsPerLine, itemSpacing: itemSpacing, flowLayout: collectionViewFlowLayout)
				collectionViewFlowLayout.itemSize = CGSize(width: maxCellWidth, height: (maxCellWidth / 8.0))
			}
		}
	}
	
	func cellWidthToUse(screenWidth: CGFloat, cellsPerLine: Int, itemSpacing: CGFloat, flowLayout:UICollectionViewFlowLayout ) -> CGFloat {
		let numCells: CGFloat = CGFloat(cellsPerLine)
		var totalInterItemSpacing: CGFloat = 0.0
		var totalInsetSpacing: CGFloat = 0.0
		var totalSpacing: CGFloat = 0.0
		var spaceLeftForCells: CGFloat = 0.0
		var cellWidth: CGFloat = 0.0
		
		totalInterItemSpacing = numCells * itemSpacing
		totalInsetSpacing = flowLayout.sectionInset.left + flowLayout.sectionInset.right
		totalSpacing = totalInterItemSpacing + totalInsetSpacing
		spaceLeftForCells = screenWidth - totalSpacing
		cellWidth = spaceLeftForCells / numCells
		return cellWidth
	}
	
	
	
	// MARK: UICollectionViewDataSource
	
	override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CellIdentifier.MediaCollectionViewCell.rawValue, forIndexPath: indexPath) as! MediaCollectionViewCell
		var artist = self.artists[indexPath.row]
		cell.title.text = artistFullName(artist)
		return cell
	}
	
	override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return 1
	}
	
	override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return artists.count ?? 0
	}
	
	// MARK: UICollectionViewDelegate
	
	override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		if UIScreen.mainScreen().traitCollection.horizontalSizeClass == .Compact {
			artPiecesCollectionViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ArtPiecesViewControllerID") as? ArtPiecesCollectionViewController
			if artPiecesCollectionViewController != nil {
				var artist = self.artists[indexPath.row]
				var artistName = artistFullName(artist)
				let filter = ArtPiecesCollectionViewDataFilter(key: "idArtist", value: artist.idArtist, title: artistName)
				artPiecesCollectionViewController!.fetchFilter(filter)
				showDetailViewController(artPiecesCollectionViewController!, sender: self)
			}
		} else {
	
			if let navigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ArtPiecesNavControllerID") as? UINavigationController,
				let artPiecesCollectionViewController = navigationController.viewControllers.last as? ArtPiecesCollectionViewController {
					var artist = self.artists[indexPath.row]
					var artistName = artistFullName(artist)
					let filter = ArtPiecesCollectionViewDataFilter(key: "idArtist", value: artist.idArtist, title: artistName)
					artPiecesCollectionViewController.fetchFilter(filter)
					showDetailViewController(navigationController, sender: self)
			}
		}
	}
	
	override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
		return true
	}
	
	override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
		return true
	}
	
	override func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
		var indexPathsVisible = collectionView.indexPathsForVisibleItems()
		for path in indexPathsVisible {
			if let visiblePath = path as? NSIndexPath {
					var cell = collectionView.cellForItemAtIndexPath(visiblePath) as? MediaCollectionViewCell
					cell?.backgroundColor = UIColor.whiteColor()
					cell?.title.textColor = UIColor.blackColor()
			}
		}
		
		var cell = collectionView.cellForItemAtIndexPath(indexPath) as? MediaCollectionViewCell
		cell?.backgroundColor = UIColor.selectionBackgroundHighlite()
		cell?.title.textColor = UIColor.whiteColor()
	}
	
}

extension ArtistCollectionViewController : NSFetchedResultsControllerDelegate {
	
	func controllerDidChangeContent(controller: NSFetchedResultsController) {
		if let art = fetchResultsController.fetchedObjects as? [Art] {
			artists = getArtistsFrom(art)
		}
		collectionView?.reloadData()
	}
}

