//
//  OrdersContainerCell.swift
//  TVMed
//
//  Created by Vinicius Albino on 29/03/17.
//  Copyright © 2017 tvMed. All rights reserved.
//

import Foundation
import UIKit

protocol SelectedOrderProtocol: class {
    func didSelectedOrder(index: Int)
}

class OrdersContainerCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet var collectionView: UICollectionView!
    private var dataItems = [MidiaPromotion]()
    static let reuseIdentifier = "OrdersContainerCell"
     weak var delegate:SelectedOrderProtocol?
    
    override var preferredFocusedView: UIView? {
        return collectionView
    }
    
    func configure(with dataItems: [MidiaPromotion], delegate: SelectedOrderProtocol) {
        self.dataItems = dataItems
        collectionView.reloadData()
        self.delegate = delegate
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.registerCells()
    }
    
    func registerCells() {
        collectionView?.register(
            UINib(nibName: "OrderCell", bundle: nil),
            forCellWithReuseIdentifier: "OrderCell")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.didSelectedOrder(index: indexPath.row)
    }
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 540, height: 380)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return self.createCategoryCell(collectionView: collectionView, indexPath: indexPath)
    }
    
    private func createCategoryCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell: OrderCell = OrderCell.createCell(collectionView: collectionView, indexPath: indexPath)
        cell.fill(item: self.dataItems.object(index: indexPath.row) ?? MidiaPromotion())
        return cell
    }
}
