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
    
    private static let minimumEdgePadding = CGFloat(90.0)
    lazy var viewModel: HomeViewModel = HomeViewModel(delegate:self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Make sure their is sufficient padding above and below the content.
        guard let collectionView = collectionView, let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        collectionView.contentInset.top = HomeViewController.minimumEdgePadding - layout.sectionInset.top
        collectionView.contentInset.bottom = HomeViewController.minimumEdgePadding - layout.sectionInset.bottom
        
        DispatchQueue.main.async {
            self.viewModel.loadReleases()
            self.viewModel.loadCategories()
        }
    }
    
    func didFinishedLoadingCategories(succes: Bool) {
        self.collectionView?.performBatchUpdates({
            let indexSet = IndexSet(integer: HomeSections.categories.rawValue)
            self.collectionView?.reloadSections(indexSet)
        }, completion: nil)
    }
    
    func didFinishedLoadingReleases(success: Bool) {
        self.collectionView?.performBatchUpdates({
            let indexSet = IndexSet(integer: HomeSections.releases.rawValue)
            self.collectionView?.reloadSections(indexSet)
        }, completion: nil)
    }
    
    func catalogCellDidSelectedCell(index: Int) {
        
    }
    
    // MARK: - UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.viewModel.numberOfSections()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return viewModel.collectionCellSizeForSection(section: indexPath.section)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) ->
        UICollectionViewCell {
        switch HomeSections(rawValue: indexPath.section) {
        case .categories:
            return collectionView.dequeueReusableCell(withReuseIdentifier: CategorieContainerCell.reuseIdentifier, for: indexPath)
        case .catalog:
            return UICollectionViewCell()
        case .releases:
            return collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewContainerCell.reuseIdentifier, for: indexPath)
        }
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        switch HomeSections(rawValue: indexPath.section) {
        case .categories:
            if let cell = cell as? CategorieContainerCell {
                cell.configure(with: viewModel.getCategories())
            }
        case .catalog:
            break
        case .releases:
            if let cell = cell as? CollectionViewContainerCell {
                cell.configure(with: viewModel.getReleases())
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        /*
         Return `false` because we don't want this `collectionView`'s cells to
         become focused. Instead the `UICollectionView` contained in the cell
         should become focused.
         */
        return false
    }
    
//    override func collectionView(_ collectionView: UICollectionView, didUpdateFocusIn context: UICollectionViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
//        
//        if let indexPath = context.previouslyFocusedIndexPath,
//            let cell = collectionView.cellForItem(at: indexPath),
//            let titleLabel = cell.viewWithTag(10) {
//            let descrLabel = cell.viewWithTag(11)
//            coordinator.addCoordinatedAnimations({
//                titleLabel.alpha = 0.4
//                descrLabel?.alpha = 0.4
//            }, completion: nil)
//        }
//        
//        if let indexPath = context.nextFocusedIndexPath,
//            let cell = collectionView.cellForItem(at: indexPath),
//            let titleLabel = cell.viewWithTag(10) {
//            let descrLabel = cell.viewWithTag(11)
//            coordinator.addCoordinatedAnimations({
//                titleLabel.alpha = 1.0
//                descrLabel?.alpha = 1.0
//            }, completion: nil)
//        }
//    }
}

