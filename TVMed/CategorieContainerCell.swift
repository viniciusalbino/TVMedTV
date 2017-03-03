//
//  CategorieContainerCell.swift
//  TVMed
//
//  Created by Vinicius Albino on 02/03/17.
//  Copyright © 2017 tvMed. All rights reserved.
//

import Foundation
import UIKit

class CategorieContainerCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet var collectionView: UICollectionView!
    private var dataItems = [Categorie]()
    static let reuseIdentifier = "CategorieContainerCell"
    
    override var preferredFocusedView: UIView? {
        return collectionView
    }
    
    func configure(with dataItems: [Categorie]) {
        self.dataItems = dataItems
        collectionView.reloadData()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.registerCells()
    }
    
    func registerCells() {
        collectionView?.register(
            UINib(nibName: "HomeCategoryCell", bundle: nil),
            forCellWithReuseIdentifier: "HomeCategoryCell")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataItems.count
    }
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 400, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return self.createCategoryCell(collectionView: collectionView, indexPath: indexPath)
    }
    
    private func createCategoryCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell: HomeCategoryCell = HomeCategoryCell.createCell(collectionView: collectionView, indexPath: indexPath)
        cell.fill(category: self.dataItems.object(index: indexPath.row) ?? Categorie())
        return cell
    }
}
