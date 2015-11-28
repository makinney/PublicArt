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
	private var selectedArtist: Artist?
	private var userInterfaceIdion: UIUserInterfaceIdiom = .Phone
	
	override init(collectionViewLayout: UICollectionViewLayout) {
		moc = CoreDataStack.sharedInstance.managedObjectContext
		fetcher = Fetcher(managedObjectContext: moc!)
		super.init(collectionViewLayout: collectionViewLayout)
	}
	
	required init?(coder aDecoder: NSCoder) {
		moc = CoreDataStack.sharedInstance.managedObjectContext
		fetcher = Fetcher(managedObjectContext: moc!)
		super.init(coder:aDecoder)
	}
	
	deinit {
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = "Artists" // TITLE
		collectionView?.backgroundColor = UIColor.whiteColor()
		
		let nibName = UINib(nibName: CellIdentifier.MediaCollectionViewCell.rawValue, bundle: nil) 
		self.collectionView?.registerNib(nibName, forCellWithReuseIdentifier: CellIdentifier.MediaCollectionViewCell.rawValue)
		setupArtistsFlowLayout()
		
		fetchResultsController.delegate = self
		do {
			try fetchResultsController.performFetch()
		} catch let error1 as NSError {
			error = error1
		}
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
		if UIScreen.mainScreen().traitCollection.horizontalSizeClass == .Regular,
			let selectedArtist = selectedArtist {
				if let navigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ArtPiecesNavControllerID") as? UINavigationController,
					let artPiecesCollectionViewController = navigationController.viewControllers.last as? ArtPiecesCollectionViewController {
						let artistName = artistFullName(selectedArtist)
						let filter = ArtPiecesCollectionViewDataFilter(key: "idArtist", value: selectedArtist.idArtist, title: artistName)
						artPiecesCollectionViewController.fetchFilter(filter)
						showDetailViewController(navigationController, sender: self)
				}
		}
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
		print("\(__FILE__) \(__FUNCTION__)")
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
			let masterViewsWidth = splitViewController?.primaryColumnWidth ?? 100
			collectionViewFlowLayout.headerReferenceSize = CGSize(width: 0, height: 0)
			
			collectionViewFlowLayout.minimumLineSpacing = 1
			var minimumCellsPerLine = 2 // ultimately up to flow layout
			
			userInterfaceIdion = traitCollection.userInterfaceIdiom
			if userInterfaceIdion == .Phone || userInterfaceIdion == .Unspecified {
				let sectionInset: CGFloat = 2
				collectionViewFlowLayout.sectionInset.top = sectionInset
				collectionViewFlowLayout.sectionInset.left = sectionInset
				collectionViewFlowLayout.sectionInset.right = sectionInset
				let itemSpacing: CGFloat = sectionInset / 2.0
				collectionViewFlowLayout.minimumInteritemSpacing = itemSpacing
				
				
				minimumCellsPerLine = 1
				maxCellWidth = cellWidthToUse(masterViewsWidth, cellsPerLine: minimumCellsPerLine, itemSpacing: itemSpacing, flowLayout: collectionViewFlowLayout)
				collectionViewFlowLayout.itemSize = CGSize(width: maxCellWidth, height: maxCellWidth / 8.0) // TODO: hard constant hack for aspect ratio
			} else {
				let sectionInset: CGFloat = 2
				collectionViewFlowLayout.sectionInset.top = sectionInset
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
	
	func showArtistWhenRegularSize(artist: Artist) {
	
	}
	
	// MARK: UICollectionViewDataSource
	
	override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CellIdentifier.MediaCollectionViewCell.rawValue, forIndexPath: indexPath) as! MediaCollectionViewCell
		let artist = self.artists[indexPath.row]
		cell.title.text = artistFullName(artist)
		cell.backgroundColor = UIColor.blackColor()
		cell.title.textColor = UIColor.whiteColor()
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
	
		let artist = self.artists[indexPath.row]
		selectedArtist = artist
		let artistName = artistFullName(artist)
		let filter = ArtPiecesCollectionViewDataFilter(key: "idArtist", value: artist.idArtist, title: artistName)
	
		if UIScreen.mainScreen().traitCollection.horizontalSizeClass == .Compact {
			artPiecesCollectionViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ArtPiecesViewControllerID") as? ArtPiecesCollectionViewController
			if artPiecesCollectionViewController != nil {
				artPiecesCollectionViewController!.fetchFilter(filter)
				showDetailViewController(artPiecesCollectionViewController!, sender: self)
			}
		} else {
			if let navigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ArtPiecesNavControllerID") as? UINavigationController,
				let artPiecesCollectionViewController = navigationController.viewControllers.last as? ArtPiecesCollectionViewController {
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
		let indexPathsVisible = collectionView.indexPathsForVisibleItems()
		for path in indexPathsVisible {
					let cell = collectionView.cellForItemAtIndexPath(path) as? MediaCollectionViewCell
					cell?.backgroundColor = UIColor.blackColor()
					cell?.title.textColor = UIColor.whiteColor()
		}
		
		if UIScreen.mainScreen().traitCollection.horizontalSizeClass == .Regular {
			let cell = collectionView.cellForItemAtIndexPath(indexPath) as? MediaCollectionViewCell
			cell?.backgroundColor = UIColor.sfOrangeColor()
			cell?.title.textColor = UIColor.blackColor()
		}
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


