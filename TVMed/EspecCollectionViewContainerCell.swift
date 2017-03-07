//
//  EspecCollectionViewContainerCell.swift
//  TVMed
//
//  Created by Vinicius Albino on 07/03/17.
//  Copyright © 2017 tvMed. All rights reserved.
//

import Foundation
import UIKit

class EspecCollectionViewContainerCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet var collectionView: UICollectionView!
    private var dataItems = [Especiality]()
    static let reuseIdentifier = "EspecCollectionViewContainerCell"
    
    override var preferredFocusedView: UIView? {
        return collectionView
    }
    
    func configure(with dataItems: [Especiality]) {
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
            UINib(nibName: "HomeSpecCell", bundle: nil),
            forCellWithReuseIdentifier: "HomeSpecCell")
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
        return self.createEspecCell(collectionView: collectionView, indexPath: indexPath)
    }
    
    private func createEspecCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell: HomeSpecCell = HomeSpecCell.createCell(collectionView: collectionView, indexPath: indexPath)
        cell.fill(item: self.dataItems.object(index: indexPath.row) ?? Especiality())
        return cell
    }
}
