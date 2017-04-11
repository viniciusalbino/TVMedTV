//
//  MeusProdutos.swift
//  TVMed
//
//  Created by Vinicius Albino on 26/03/17.
//  Copyright © 2017 tvMed. All rights reserved.
//

import Foundation
import UIKit
class MeusProdutosViewController: UICollectionViewController, MeusProdutosDelegate, SelectedOrderProtocol {
    
    private static let minimumEdgePadding = CGFloat(90.0)
    lazy private var viewModel: MeusProdutosViewModel = MeusProdutosViewModel(delegate: self)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.loadContent()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Make sure their is sufficient padding above and below the content.
        guard let collectionView = collectionView, let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        collectionView.contentInset.top = MeusProdutosViewController.minimumEdgePadding - layout.sectionInset.top
        collectionView.contentInset.bottom = MeusProdutosViewController.minimumEdgePadding - layout.sectionInset.bottom
    }
    
    func loadContent() {
        let tokenPersister = TokenPersister()
        tokenPersister.query { token in
            guard let userToken = token, !userToken.token.isEmpty else {
                return
            }
            
            self.viewModel.checkValiToken { success in
                guard !success else {
                    self.startLoading()
                    self.viewModel.loadMeusProdutos()
                    return
                }
                self.performSegue(withIdentifier: "presentLogin", sender: nil)
            }
        }
    }
    
    func contentDidFinishedLoading(success: Bool) {
        stopLoading()
        self.collectionView?.performBatchUpdates({
            let indexSet = IndexSet(integer: 0)
            self.collectionView?.reloadSections(indexSet)
        }, completion: nil)
    }
    
    func didSelectedOrder(index: Int) {
        let congress = self.viewModel.getMidias().object(index: index)
        self.performSegue(withIdentifier: "CongressoDetail", sender: congress)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "CongressoDetail":
            if let controller = segue.destination as? CongressDetailController {
                if let midia =  sender as? MidiaPromotion {
                    controller.loadContent(contentType: (type: .congress, id: "\(midia.congresso)"))
                }
            }
        default:
            break
        }
    }
    
    // MARK: - UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderCell", for: indexPath) as! HeaderCell
            headerView.fill(title: "Meus Produtos")
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
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 1920, height: 381)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: OrdersContainerCell.reuseIdentifier, for: indexPath)
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? OrdersContainerCell {
            cell.configure(with: viewModel.getMidias(), delegate: self)
        }
    }
}
