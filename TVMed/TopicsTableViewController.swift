//
//  TopicsTableViewController.swift
//  TVMed
//
//  Created by Vinicius de Moura Albino on 15/04/17.
//  Copyright © 2017 tvMed. All rights reserved.
//

import Foundation
import UIKit

class TopicsTableViewController: UITableViewController, TopicsDelegate {
    
    var currentMidia: MidiaPromotion?
    private lazy var viewModel: TopicsViewModel = TopicsViewModel(delegate: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerHeaderFooterView(identifier: String(describing: TableViewHeaderCell.self))
        tableView.registerCell(identifier: String(describing: TopicCell.self))
    }
    
    func loadContent(midia: MidiaPromotion) {
        self.currentMidia = midia
        startLoading()
        DispatchQueue.main.async {
            self.viewModel.loadTopics(midia: midia)
        }
    }
    
    func contentDidFinishedLoading(success: Bool) {
        stopLoading()
        guard success else {
            return
        }
        self.title = viewModel.getTitle()
        self.tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItensInSection(section: section)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: TableViewHeaderCell.self)) as? TableViewHeaderCell
        cell?.fill(text: viewModel.titleForHeaderInSection(section: section))
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 110
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "TopicCell")!
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? TopicCell {
            let subTopic = viewModel.itemForSection(section: indexPath.section, row: indexPath.row)
            cell.fill(text: subTopic.titulo)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        startLoading()
        let subTopic = viewModel.itemForSection(section: indexPath.section, row: indexPath.row)
        viewModel.validatesUserToken(subTopicID: subTopic.subtopicoId)
    }
    
    func errorOnPlayingVideo() {
        stopLoading()
        self.showDefaultSystemAlertWithDefaultLayout(message: "Ocorreu um erro ao reproduzir o video. Por favor tente novamente.", completeBlock: nil)
    }
    
    func playVideo(url: String) {
        stopLoading()
        self.performSegue(withIdentifier: "videoSegue", sender: url)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "videoSegue":
            if let controller = segue.destination as? VideoPlayerController, let url = sender as? String {
                controller.loadVideo(url: url)
            }
        default:
            break
        }
    }
}
