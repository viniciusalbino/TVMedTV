//
//  SearchViewController.swift
//  TVMed
//
//  Created by Vinicius Albino on 30/01/17.
//  Copyright © 2017 tvMed. All rights reserved.
//

import Foundation

import UIKit

class SearchViewController: UICollectionViewController, UISearchResultsUpdating, SearchDelegate {
    
    lazy var viewModel: SearchViewModel = SearchViewModel(delegate: self)
    private var spinner = UIActivityIndicatorView(activityIndicatorStyle: .white)
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func finishedLoadingContent(success: Bool) {
        spinner.stopAnimating()
        guard success else {
            return
        }
        self.collectionView?.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text, text.length() > 2 else {
            return
        }
        
        searchController.searchBar.subviews.forEach {($0 as? UIActivityIndicatorView)?.removeFromSuperview()}
        spinner.frame = CGRect(x: searchController.searchBar.frame.size.width - 70, y: 7, width: 40, height: 40)
        spinner.hidesWhenStopped = true
        searchController.searchBar.addSubview(spinner)
        spinner.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.025) {
            self.viewModel.requestSearch(string: text)
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItensInSection()
    }
}
