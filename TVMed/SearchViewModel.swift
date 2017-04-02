//
//  SearchViewModel.swift
//  TVMed
//
//  Created by Vinicius Albino on 02/04/17.
//  Copyright © 2017 tvMed. All rights reserved.
//

import Foundation

protocol SearchDelegate: class {
    func finishedLoadingContent(success: Bool)
}

class SearchViewModel {
    
    weak var delegate:SearchDelegate?
    private var congressos = [MidiaPromotion]()
    
    init(delegate:SearchDelegate) {
        self.delegate = delegate
    }
    
    func numberOfItensInSection() -> Int {
        return congressos.count
    }
    
    func requestSearch(string: String) {
        
    }
}
