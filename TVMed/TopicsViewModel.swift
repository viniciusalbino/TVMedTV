//
//  TopicsViewModel.swift
//  TVMed
//
//  Created by Vinicius de Moura Albino on 15/04/17.
//  Copyright © 2017 tvMed. All rights reserved.
//

import Foundation

protocol TopicsDelegate: class {
    func contentDidFinishedLoading(success: Bool)
}

class TopicsViewModel {
    
    private var delegate: TopicsDelegate?
    private var topicsRemoteService = NewReleasesRequest()
    private var topics: MidiaDetail?
    
    init(delegate: TopicsDelegate?) {
        self.delegate = delegate
    }
    
    func loadTopics(midia: MidiaPromotion) {
        topicsRemoteService.getTopic(midia: midia) { midiaDetail, error in
            guard error == nil, let midia = midiaDetail else {
                self.delegate?.contentDidFinishedLoading(success: false)
                return
            }
            self.topics = midia
            self.delegate?.contentDidFinishedLoading(success: true)
        }
    }
    
    func getTitle() -> String {
        if let topic = topics {
            return topic.congressoTitulo
        } else {
            return ""
        }
    }
    
    func numberOfSections() -> Int {
        guard let topic = topics else {
            return 0
        }
        return topic.topicos.count
    }
    
    func numberOfItensInSection(section: Int) -> Int {
        guard let topic = topics else {
            return 0
        }
        return topic.topicos.object(index: section)?.subTopicos.count ?? 0
    }
    
    func titleForHeaderInSection(section: Int) -> String {
        guard let topic = topics else {
            return ""
        }
        return topic.topicos.object(index: section)?.titulo ?? ""
    }
    
    func itemForSection(section: Int, row: Int) -> MidiaSubTopic {
        guard let topic = topics else {
            return MidiaSubTopic()
        }
        return topic.topicos.object(index: section)?.subTopicos.object(index: row) ?? MidiaSubTopic()
    }
}
