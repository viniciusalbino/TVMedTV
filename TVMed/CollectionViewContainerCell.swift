//
//  CollectionViewContainerCell.swift
//  TVMed
//
//  Created by Vinicius Albino on 02/03/17.
//  Copyright © 2017 tvMed. All rights reserved.
//

import Foundation
import UIKit

class CollectionViewContainerCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet var collectionView: UICollectionView!
    private var dataItems = [Release]()
    static let reuseIdentifier = "CollectionViewContainerCell"
    
    override var preferredFocusedView: UIView? {
        return collectionView
    }
    
    func configure(with dataItems: [Release]) {
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
            UINib(nibName: "HomeCatalogCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: "HomeCatalogCollectionViewCell")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataItems.count
    }
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 540, height: 381)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return self.createCatalogCell(collectionView: collectionView, indexPath: indexPath)
    }
    
    private func createCatalogCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell: HomeCatalogCollectionViewCell = HomeCatalogCollectionViewCell.createCell(collectionView: collectionView, indexPath: indexPath)
        cell.fill(item: self.dataItems.object(index: indexPath.row) ?? Release())
        return cell
    }
}
