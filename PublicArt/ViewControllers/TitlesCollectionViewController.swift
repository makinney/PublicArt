//
//  TitlesCollectionViewController.swift
//  PublicArt
//
//  Created by Michael Kinney on 7/13/15.
//  Copyright (c) 2015 makinney. All rights reserved.
//

import UIKit
import CoreData

final class TitlesCollectionViewController: UICollectionViewController {

	// MARK: Properties
	fileprivate var collapseDetailViewController = true
	fileprivate var initialHorizontalSizeClass: UIUserInterfaceSizeClass?
	fileprivate var maxCellWidth: CGFloat = 0.0
	fileprivate var error:NSError?
	fileprivate let moc: NSManagedObjectContext?
	fileprivate var selectedArt: Art?
	fileprivate var userInterfaceIdion: UIUserInterfaceIdiom = .phone
	
	override init(collectionViewLayout: UICollectionViewLayout) {
		moc = CoreDataStack.sharedInstance.managedObjectContext
		super.init(collectionViewLayout: collectionViewLayout)
	}
	
	required init?(coder aDecoder: NSCoder) {
		moc = CoreDataStack.sharedInstance.managedObjectContext
		super.init(coder:aDecoder)
	}
	
	deinit {
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let nibName = UINib(nibName: CellIdentifier.MediaCollectionViewCell.rawValue, bundle: nil) // TODO: view for titles
		self.collectionView?.register(nibName, forCellWithReuseIdentifier: CellIdentifier.MediaCollectionViewCell.rawValue)
		
		title = "Titles"
		
		setupArtTitlesFlowLayout()
		
		collectionView?.backgroundColor = UIColor.white
		
		fetchResultsController.delegate = self
		do {
			try fetchResultsController.performFetch()
		} catch let error1 as NSError {
			error = error1
		}
		collectionView?.reloadData()
		
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		if UIScreen.main.traitCollection.horizontalSizeClass == .regular,
			let selectedArt = selectedArt {
			if let navigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ArtPiecesNavControllerID") as? UINavigationController {
				let singleArtViewController: SingleArtViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: ViewControllerIdentifier.SingleArtViewController.rawValue) as!  SingleArtViewController
				singleArtViewController.update(selectedArt, artBackgroundColor: nil)
				navigationController.setViewControllers([singleArtViewController], animated: false)
				showDetailViewController(navigationController, sender: self)
			}
		}
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
	}
	
	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		setupArtTitlesFlowLayout()
		collectionView?.reloadData()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		print("\(#file) \(#function)")
	}
	
	// MARK: Fetch Results Controller
	//
	lazy var fetchResultsController:NSFetchedResultsController<Art> = {
		let fetchRequest = NSFetchRequest<Art>(entityName:ModelEntity.art)
        let sortDescriptor = [NSSortDescriptor(key:ModelAttributes.artworkTitle, ascending:true, selector: #selector(NSString.localizedCompare(_:)))]
		fetchRequest.sortDescriptors = sortDescriptor
		let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.moc!, sectionNameKeyPath: nil, cacheName: nil)
		return frc
		}()
	
	// MARK: - Navigation
	
	func setupArtTitlesFlowLayout() {
		if let collectionViewFlowLayout: UICollectionViewFlowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
			collectionViewFlowLayout.scrollDirection = .vertical
			let masterViewsWidth = splitViewController?.primaryColumnWidth ?? 100
			collectionViewFlowLayout.headerReferenceSize = CGSize(width: 0, height: 0)
			
			collectionViewFlowLayout.minimumLineSpacing = 1
			var minimumCellsPerLine = 2 // ultimately up to flow layout
			
			userInterfaceIdion = traitCollection.userInterfaceIdiom
			if userInterfaceIdion == .phone || userInterfaceIdion == .unspecified {
				let sectionInset: CGFloat = 1.0
				collectionViewFlowLayout.sectionInset.top = sectionInset
				collectionViewFlowLayout.sectionInset.left = sectionInset
				collectionViewFlowLayout.sectionInset.right = sectionInset
				let itemSpacing: CGFloat = 1.0
				collectionViewFlowLayout.minimumInteritemSpacing = itemSpacing
				
				
				minimumCellsPerLine = 1
				maxCellWidth = cellWidthToUse(masterViewsWidth, cellsPerLine: minimumCellsPerLine, itemSpacing: itemSpacing, flowLayout: collectionViewFlowLayout)
				collectionViewFlowLayout.itemSize = CGSize(width: maxCellWidth, height: maxCellWidth / 8.0) // TODO: hard constant hack for aspect ratio
			} else {
				let sectionInset: CGFloat = 2.0
				collectionViewFlowLayout.sectionInset.top = sectionInset
				collectionViewFlowLayout.sectionInset.left = sectionInset
				collectionViewFlowLayout.sectionInset.right = sectionInset
				let itemSpacing: CGFloat = 2.0
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
	
	
	
	// MARK: UICollectionViewDataSource
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.MediaCollectionViewCell.rawValue, for: indexPath) as! MediaCollectionViewCell
        let art = fetchResultsController.object(at: indexPath)
        cell.title.text = art.title
        cell.backgroundColor = UIColor.black
        cell.title.textColor = UIColor.sfOrangeColor()
		
		return cell
	}
	
	override func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		let sectionInfo = fetchResultsController.sections![section] 
		return sectionInfo.numberOfObjects
	}
	
	// MARK: UICollectionViewDelegate
	
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let art = fetchResultsController.object(at: indexPath)
        selectedArt = art
        if UIScreen.main.traitCollection.horizontalSizeClass == .compact {
            if	let singleArtViewController: SingleArtViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: ViewControllerIdentifier.SingleArtViewController.rawValue) as?  SingleArtViewController {
                singleArtViewController.update(art, artBackgroundColor: nil)
                show(singleArtViewController, sender: self)
            }
        } else {
            if let navigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ArtPiecesNavControllerID") as? UINavigationController {
                let singleArtViewController: SingleArtViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: ViewControllerIdentifier.SingleArtViewController.rawValue) as!  SingleArtViewController
                singleArtViewController.update(art, artBackgroundColor: nil)
                navigationController.setViewControllers([singleArtViewController], animated: false)
                showDetailViewController(navigationController, sender: self)
            }
        }
    }
	
	override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
		return true
	}
	
	override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
		return true
	}
	
	override func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
		if UIScreen.main.traitCollection.horizontalSizeClass == .regular {
			let indexPathsVisible = collectionView.indexPathsForVisibleItems
			for path in indexPathsVisible {
					let cell = collectionView.cellForItem(at: path) as? MediaCollectionViewCell
					cell?.backgroundColor = UIColor.black
					cell?.title.textColor = UIColor.sfOrangeColor()
			}
			
			if UIScreen.main.traitCollection.horizontalSizeClass == .regular {
				let cell = collectionView.cellForItem(at: indexPath) as? MediaCollectionViewCell
				cell?.backgroundColor = UIColor.white
				cell?.title.textColor = UIColor.black
			}
		}
	}
	
}

extension TitlesCollectionViewController : NSFetchedResultsControllerDelegate {
	
	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		collectionView?.reloadData()
	}
}


