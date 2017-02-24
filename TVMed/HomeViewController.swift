//
//  HomeViewController.swift
//  TVMed
//
//  Created by Vinicius Albino on 21/02/17.
//  Copyright © 2017 tvMed. All rights reserved.
//

import Foundation
import  UIKit

class HomeViewController: UICollectionViewController, HomeDelegate, UICollectionViewDelegateFlowLayout {
    
    lazy var viewModel: HomeViewModel = HomeViewModel(delegate:self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        LoadingOverlay().showOverlay(viewController: self)
        self.registerCells()
        DispatchQueue.main.async {
            self.viewModel.loadReleases()
            self.viewModel.loadCategories()
        }
        
        let flowLayout = UICollectionViewFlowLayout()
        
//        flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width/2 - 10, height: 381)
//        flowLayout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5)
//        flowLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
//        flowLayout.minimumInteritemSpacing = 0.0
//        self.collectionView?.collectionViewLayout = flowLayout
        
    }
    
    func registerCells() {
        collectionView?.register(
            UINib(nibName: "HomeCatalogCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: "HomeCatalogCollectionViewCell")
    }
    
    func didFinishedLoadingCategories(succes: Bool) {
        
    }
    
    func didFinishedLoadingReleases(success: Bool) {
            self.collectionView?.performBatchUpdates({
                let indexSet = IndexSet(integer: HomeSections.releases.rawValue)
                self.collectionView?.reloadSections(indexSet)
            }, completion: nil)
    }
    
    private func createCatalogCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell: HomeCatalogCollectionViewCell = HomeCatalogCollectionViewCell.createCell(collectionView: collectionView, indexPath: indexPath)
        cell.fill(item: viewModel.getReleases().object(index: indexPath.row) ?? Release())
        return cell
    }
    
    func catalogCellDidSelectedCell(index: Int) {
        
    }
    
    // MARK: - UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.numberOfSections()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.numberOfRowsInSection(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return viewModel.collectionCellSizeForSection(section: indexPath.section)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) ->
        UICollectionViewCell {
        switch HomeSections(rawValue: indexPath.section) {
        case .categories:
            return UICollectionViewCell()
        case .catalog:
            return UICollectionViewCell()
        case .releases:
            return self.createCatalogCell(collectionView: collectionView, indexPath: indexPath)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didUpdateFocusIn context: UICollectionViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        
        if let indexPath = context.previouslyFocusedIndexPath,
            let cell = collectionView.cellForItem(at: indexPath),
            let titleLabel = cell.viewWithTag(10) {
            let descrLabel = cell.viewWithTag(11)
            coordinator.addCoordinatedAnimations({
                titleLabel.alpha = 0.4
                descrLabel?.alpha = 0.4
            }, completion: nil)
        }
        
        if let indexPath = context.nextFocusedIndexPath,
            let cell = collectionView.cellForItem(at: indexPath),
            let titleLabel = cell.viewWithTag(10) {
            let descrLabel = cell.viewWithTag(11)
            coordinator.addCoordinatedAnimations({
                titleLabel.alpha = 1.0
                descrLabel?.alpha = 1.0
            }, completion: nil)
        }
    }
}

