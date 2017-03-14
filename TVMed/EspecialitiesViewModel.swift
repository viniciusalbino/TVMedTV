//
//  EspecialitiesViewModel.swift
//  TVMed
//
//  Created by Vinicius Albino on 08/03/17.
//  Copyright © 2017 tvMed. All rights reserved.
//

import Foundation

protocol EspecialitiesDelegate: class {
    func didFinishedLoading(succes: Bool)
}

class EspecialitiesViewModel: NSObject {
    
    weak var delegate: EspecialitiesDelegate?
    private var especialities = [Especiality]()
    
    init(delegate: EspecialitiesDelegate) {
        self.delegate = delegate
    }
    
    func loadEspecialities(id: String) {
        let request = EspecialityRequest()
        request.filterEspeciality(especialidade: id) { especialities, error in
            guard error == nil, let content = especialities else {
                self.delegate?.didFinishedLoading(succes: false)
                return
            }
            self.especialities = content
            self.delegate?.didFinishedLoading(succes: true)
        }
    }
    
    func getEspecialities() -> [Especiality] {
        return especialities
    }
    
    func numberOfItensInSection() -> Int {
        return especialities.count
    }
}
