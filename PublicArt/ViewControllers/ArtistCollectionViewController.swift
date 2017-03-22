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
	fileprivate var artPiecesCollectionViewController: ArtPiecesCollectionViewController?
	fileprivate var collapseDetailViewController = true
	fileprivate var fetcher: Fetcher!
	fileprivate var initialHorizontalSizeClass: UIUserInterfaceSizeClass?
	fileprivate var maxCellWidth: CGFloat = 0.0
	fileprivate var error:NSError?
	fileprivate let moc: NSManagedObjectContext?
	fileprivate var artists = [Artist]()
	fileprivate var selectedArtist: Artist?
	fileprivate var userInterfaceIdion: UIUserInterfaceIdiom = .phone
	
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
				
		collectionView?.backgroundColor = UIColor.black
        if #available(iOS 10.0, *) {
            collectionView?.isPrefetchingEnabled = false
        } else {
            // Fallback on earlier versions
        }

		setupArtistsFlowLayout()
		
		fetchResultsController.delegate = self
		do {
			try fetchResultsController.performFetch()
		} catch let error1 as NSError {
			error = error1
		}
		if let art = fetchResultsController.fetchedObjects {
			self.artists = getArtistsFrom(art)
		}
		collectionView?.reloadData()
		
	}
	
	func getArtistsFrom(_ artwork: [Art]) -> [Artist] {
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
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
//		if UIScreen.main.traitCollection.horizontalSizeClass == .regular,
//			let selectedArtist = selectedArtist {
//				if let navigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ArtPiecesNavControllerID") as? UINavigationController,
//					let artPiecesCollectionViewController = navigationController.viewControllers.last as? ArtPiecesCollectionViewController {
//						let artistName = artistFullName(selectedArtist)
//						let filter = ArtPiecesCollectionViewDataFilter(key: "idArtist", value: selectedArtist.idArtist, title: artistName)
//						artPiecesCollectionViewController.fetchFilter(filter)
//						showDetailViewController(navigationController, sender: self)
//				}
//		}
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
	}
	
	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		setupArtistsFlowLayout()
		collectionView?.reloadData()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		print("\(#file) \(#function)")
	}
	
	// MARK: Fetch Results Controller
	// // FIXME: Swift 3  what is this <<error type>> ?
	lazy var fetchResultsController:NSFetchedResultsController<Art> = {
		let fetchRequest = NSFetchRequest<Art>(entityName:ModelEntity.art)
		let sortDescriptor = [NSSortDescriptor(key:"artist.lastName", ascending:true, selector: #selector(NSString.localizedStandardCompare(_:)))]
		fetchRequest.sortDescriptors = sortDescriptor
		let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.moc!, sectionNameKeyPath: nil, cacheName: nil)
		return frc
		}()
	
	// MARK: - Navigation
	
	func setupArtistsFlowLayout() {
		if let collectionViewFlowLayout: UICollectionViewFlowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
			collectionViewFlowLayout.scrollDirection = .vertical
			let masterViewsWidth = UIScreen.main.bounds.width
			collectionViewFlowLayout.headerReferenceSize = CGSize(width: 0, height: 0)
			
			collectionViewFlowLayout.minimumLineSpacing = 4
			var minimumCellsPerLine = 1 // ultimately up to flow layout
			
			userInterfaceIdion = traitCollection.userInterfaceIdiom
			if userInterfaceIdion == .phone || userInterfaceIdion == .unspecified {
				let sectionInset: CGFloat = 1
				collectionViewFlowLayout.sectionInset.top = sectionInset
				collectionViewFlowLayout.sectionInset.left = sectionInset
				collectionViewFlowLayout.sectionInset.right = sectionInset
				let itemSpacing: CGFloat = 8
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
	
	func cellWidthToUse(_ screenWidth: CGFloat, cellsPerLine: Int, itemSpacing: CGFloat, flowLayout:UICollectionViewFlowLayout ) -> CGFloat {
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
	
	func showArtistWhenRegularSize(_ artist: Artist) {
	
	}
	
	// MARK: UICollectionViewDataSource
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let artistCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.ArtistCollectionViewCell.rawValue, for: indexPath ) as! ArtistCollectionViewCell
		let artist = self.artists[indexPath.row]
		artistCollectionViewCell.artistName.text = artistFullName(artist)
		artistCollectionViewCell.backgroundColor = UIColor.white
		artistCollectionViewCell.artistName.textColor = UIColor.black
        artistCollectionViewCell.disclosureImage.image = UIImage(named: "disclosureIndicator")
        return artistCollectionViewCell
	}
	
	override func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return artists.count
	}
	
	// MARK: UICollectionViewDelegate
	
	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
	
		let artist = self.artists[indexPath.row]
        if let webViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: ViewControllerIdentifier.WebViewController.rawValue ) as? WebViewController {
            webViewController.webViewAddress = artist.webLink
            show(webViewController, sender: self)
        }
	}
	

	override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
		return true
	}
	
	override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
		return true
	}
	
	override func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
		let indexPathsVisible = collectionView.indexPathsForVisibleItems
		for path in indexPathsVisible {
					let cell = collectionView.cellForItem(at: path) as? MediaCollectionViewCell
					cell?.backgroundColor = UIColor.white
					cell?.title.textColor = UIColor.black
		}
		
		if UIScreen.main.traitCollection.horizontalSizeClass == .regular {
			let cell = collectionView.cellForItem(at: indexPath) as? MediaCollectionViewCell
			cell?.backgroundColor = UIColor.black
			cell?.title.textColor = UIColor.white
		}
	}
	
}

extension ArtistCollectionViewController : NSFetchedResultsControllerDelegate {
	
	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		if let art = fetchResultsController.fetchedObjects {
			artists = getArtistsFrom(art)
		}
		collectionView?.reloadData()
	}
}


