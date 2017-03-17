//
//  EspecialitiesController.swift
//  TVMed
//
//  Created by Vinicius Albino on 07/03/17.
//  Copyright © 2017 tvMed. All rights reserved.
//

import Foundation
import UIKit

class EspecialitiesController: UICollectionViewController, SelectedEspecialityProtocol, EspecialitiesDelegate {
    
    private static let minimumEdgePadding = CGFloat(90.0)
    lazy var viewModel: EspecialitiesViewModel = EspecialitiesViewModel(delegate:self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Make sure their is sufficient padding above and below the content.
        guard let collectionView = collectionView, let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        collectionView.contentInset.top = EspecialitiesController.minimumEdgePadding - layout.sectionInset.top
        collectionView.contentInset.bottom = EspecialitiesController.minimumEdgePadding - layout.sectionInset.bottom
    }
    
    func getEspecialities(id: String) {
        DispatchQueue.main.async {
            self.viewModel.loadEspecialities(id: id)
        }
    }
    
    func didFinishedLoading(succes: Bool) {
        self.collectionView?.performBatchUpdates({
            let indexSet = IndexSet(integer: 0)
            self.collectionView?.reloadSections(indexSet)
        }, completion: nil)
    }
    
    func didSelectedEspeciality(index: Int) {
        
    }
    
    // MARK: - UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderCell", for: indexPath) as! HeaderCell
            headerView.fill(title: "Congressos")
            return headerView
        default:
            assert(false, "Unexpected element kind")
        }
        return UICollectionReusableView()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItensInSection()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 1920, height: 381)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: EspecCollectionViewContainerCell.reuseIdentifier, for: indexPath)
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? EspecCollectionViewContainerCell {
            cell.configure(with: viewModel.getEspecialities(), delegate: self)
        }
    }
}
