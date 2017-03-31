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
    private var currentMidia: MidiaPromotion?
    private var selectedMidiaIndex = 0
    
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
    
    func loadMidiaPromotion(id: String) {
        let request = NewReleasesRequest()
        request.getMidiaPromotion(congressoId: id) { content, error in
            guard error == nil, let midias = content else {
                self.delegate?.contentDidFinishedLoading(succes: false)
                return
            }
            self.midias = midias
            self.delegate?.contentDidFinishedLoading(succes: true)
        }
    }
    
    func getCurrentMidia() -> MidiaPromotion {
        guard self.midias.count > 0, let midia = midias.object(index: selectedMidiaIndex) else {
            return MidiaPromotion()
        }
        return midia
    }
    
    func numberOfItensInSection() -> Int {
        return self.midias.count
    }
    
    func midiaForRow(row: Int) -> MidiaPromotion {
        return self.midias.object(index: row) ?? MidiaPromotion()
    }
    
    func setSelectedMidiaIndex(index: Int) {
        self.selectedMidiaIndex = index
        self.currentMidia = midiaForRow(row: index)
    }
    
    func setMidia(midia: MidiaPromotion) {
        self.currentMidia = midia
        self.midias = [midia]
        self.delegate?.contentDidFinishedLoading(succes: true)
    }
}
