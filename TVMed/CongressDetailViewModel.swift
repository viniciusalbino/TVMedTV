//
//  CongressDetailViewModel.swift
//  TVMed
//
//  Created by Vinicius Albino on 16/03/17.
//  Copyright © 2017 tvMed. All rights reserved.
//

import Foundation

protocol CongressDetailDelegate: class {
    func contentDidFinishedLoading(succes: Bool)
}

class CongressDetailViewModel {
    
    private weak var delegate: CongressDetailDelegate?
    private var midias = [MidiaPromotion]()
    
    init(delegate: CongressDetailDelegate) {
        self.delegate = delegate
    }
    
    func loadContent(id: String) {
        let request = EspecialityRequest()
        
        request.getMidiaCongress(congressID: id) { content, error in
            guard error == nil, let midias = content else {
                self.delegate?.contentDidFinishedLoading(succes: false)
                return
            }
            self.midias = midias
            self.delegate?.contentDidFinishedLoading(succes: true)
        }
    }
}
