//
//  HomeViewModel.swift
//  TVMed
//
//  Created by Vinicius Albino on 21/02/17.
//  Copyright © 2017 tvMed. All rights reserved.
//

import Foundation
import Alamofire

protocol HomeDelegate: class {
    func didFinishedLoadingCategories(succes: Bool)
    func didFinishedLoadingReleases(success: Bool)
    func didFinishedLoadingEspec(succes: Bool)
}

class HomeViewModel: NSObject {
    
    weak var delegate:HomeDelegate?
    private var releases = [Release]()
    private var categories = [Categorie]()
    private var especialities = [Especiality]()
    
    init(delegate: HomeDelegate) {
        self.delegate = delegate
    }
    
    func loadReleases() {
        let releasesRequest = NewReleasesRequest()
        releasesRequest.request { releases, error in
            guard error == nil, let incomingReleases = releases else {
                self.delegate?.didFinishedLoadingReleases(success: false)
                return
            }
            self.releases = incomingReleases
            self.delegate?.didFinishedLoadingReleases(success: true)
        }
    }
    
    func loadCategories() {
        let categoriesRequest = CategoriesRequest()
        categoriesRequest.request { categories, error in
            guard error == nil, let incomingCategories = categories else {
                self.delegate?.didFinishedLoadingCategories(succes: false)
                return
            }
            self.categories = incomingCategories
            self.delegate?.didFinishedLoadingCategories(succes: true)
        }
    }
    
    func loadEspecialities() {
        let request = EspecialityRequest()
        request.request { especialities, error in
            guard error == nil, let especiality = especialities else {
                self.delegate?.didFinishedLoadingEspec(succes: false)
                return
            }
            self.especialities = especiality
            self.delegate?.didFinishedLoadingEspec(succes: true)
        }
    }
    
    func numberOfSections() -> Int {
        return HomeSections.allValues.count
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        switch HomeSections(rawValue: section) {
        case .categories:
            return self.categories.count
        case .especiality:
            return self.especialities.count
        case .releases:
            return self.releases.count
        }
    }
    
    func collectionCellSizeForSection(section: Int) -> CGSize {
        switch HomeSections(rawValue: section) {
        case .categories:
            return CGSize(width: 1920, height: 100)
        case .especiality:
            return CGSize(width: 1920, height: 381)
        case .releases:
            return CGSize(width: 1920, height: 381)
        }
    }
    
    func getReleases() -> [Release] {
        return releases
    }
    
    func getCategories() -> [Categorie] {
        return categories
    }
    
    func getEspecialities() -> [Especiality] {
        return especialities
    }
}
