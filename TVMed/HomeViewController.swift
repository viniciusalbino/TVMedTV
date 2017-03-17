//
//  HomeViewController.swift
//  TVMed
//
//  Created by Vinicius Albino on 21/02/17.
//  Copyright © 2017 tvMed. All rights reserved.
//

import Foundation
import  UIKit

class HomeViewController: UICollectionViewController, HomeDelegate, UICollectionViewDelegateFlowLayout, SelectedEspecialityProtocol, SelectedReleaseProtocol, SelectedCategorieProtocol {
    
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
            self.viewModel.loadEspecialities()
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
    
    func didFinishedLoadingEspec(succes: Bool) {
        self.collectionView?.performBatchUpdates({ 
            let indexSet = IndexSet(integer: HomeSections.especiality.rawValue)
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
        case .especiality:
            return collectionView.dequeueReusableCell(withReuseIdentifier: EspecCollectionViewContainerCell.reuseIdentifier, for: indexPath)
        case .releases:
            return collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewContainerCell.reuseIdentifier, for: indexPath)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderCell", for: indexPath) as! HeaderCell
            headerView.fill(title: viewModel.titleForHeaderInSection(section: indexPath.section))
            return headerView
        default:
            assert(false, "Unexpected element kind")
        }
        return UICollectionReusableView()
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        switch HomeSections(rawValue: indexPath.section) {
        case .categories:
            if let cell = cell as? CategorieContainerCell {
                cell.configure(with: viewModel.getCategories(), delegate: self)
            }
        case .especiality:
            if let cell = cell as? EspecCollectionViewContainerCell {
                cell.configure(with: viewModel.getEspecialities(), delegate: self)
            }
        case .releases:
            if let cell = cell as? CollectionViewContainerCell {
                cell.configure(with: viewModel.getReleases(), delegate: self)
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
    
    func didSelectedRelease(index: Int) {
        
    }
    
    func didSelectedCategorie(index: Int) {
        let categorie = self.viewModel.getCategories().object(index: index)
        self.performSegue(withIdentifier: "EspecialitiesSegue", sender: categorie)
    }
    
    func didSelectedEspeciality(index: Int) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "EspecialitiesSegue":
            if let controller = segue.destination as? EspecialitiesController, let categorie = sender as? Categorie {
                controller.getEspecialities(id: categorie.codigo)
            }
        default:
            break
        }
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

