//
//  CongressDetailController.swift
//  TVMed
//
//  Created by Vinicius Albino on 16/03/17.
//  Copyright © 2017 tvMed. All rights reserved.
//

import Foundation
import UIKit

enum CongressType {
    case midiaPromotion
    case congress
}

typealias LoadContentType = (type: CongressType, id: String)

class CongressDetailController: UIViewController, CongressDetailDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var discountPrice: UILabel!
    @IBOutlet weak var finalPrice: UILabel!
    @IBOutlet weak var decriptionTextView: FocusedTextView!
    @IBOutlet weak var congressImage: UIImageView!
    private var contentType: LoadContentType?
    private var userRequest = UserRequests()
    
    var currentMidia:MidiaPromotion?
    
    lazy var viewModel: CongressDetailViewModel = CongressDetailViewModel(delegate: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let midia = self.currentMidia {
            viewModel.setMidia(midia: midia)
        }
    }
    
    func setMidia(midia: MidiaPromotion) {
        self.currentMidia = midia
    }
    
    func loadContent(contentType: LoadContentType) {
        self.contentType = contentType
        if contentType.type == .congress {
            self.loadCongress(congressID: contentType.id)
        } else {
            self.loadMidiaPromo(midiaID: contentType.id)
        }
    }
    
    func loadCongress(congressID: String) {
        self.startLoading()
        DispatchQueue.main.async {
            self.viewModel.loadContent(id: congressID)
        }
    }
    
    func loadMidiaPromo(midiaID: String) {
        DispatchQueue.main.async {
            self.viewModel.loadMidiaPromotion(id: midiaID)
        }
    }
    
    func contentDidFinishedLoading(succes: Bool) {
        self.stopLoading()
        if succes {
            self.tableView.reloadData()
            self.fillScreen()
        } else {
            
        }
    }
    
    func fillScreen() {
        let midia = viewModel.getCurrentMidia()
        if let url = URL(string: midia.imagemHtml) {
            self.congressImage.kf.setImage(with: url, placeholder: UIImage(named:"defaultImage"), options: nil, progressBlock: nil, completionHandler: nil)
        }
        self.decriptionTextView.text = midia.formattedDescription()
        self.titleLabel.text = midia.nomeCongresso
        
        self.buyButton.setTitle(midia.clienteComprouParaAssistirOnLine ? "Assistir" : "Comprar", for: .normal)
        
        self.finalPrice.text = midia.getMidiaPrice()
        self.discountPrice.isHidden = !midia.hasDiscount()
        self.discountPrice.text = midia.hasDiscount() ? midia.discountPercentage() : ""
        
        print(midia.discountPercentage())
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItensInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: CongressDetailCell.reuseIdentifier, for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? CongressDetailCell {
            print(viewModel.midiaForRow(row: indexPath.row).congresso)
            cell.fill(title: viewModel.midiaForRow(row: indexPath.row).nomeCongresso, subTitle: viewModel.midiaForRow(row: indexPath.row).formattedSubtitle())
        }
    }
    
    func tableView(_ tableView: UITableView, didUpdateFocusIn context: UITableViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if let selected = context.nextFocusedIndexPath {
            DispatchQueue.main.async {
                self.viewModel.setSelectedMidiaIndex(index: selected.row)
                self.fillScreen()
            }
        }
    }
    
    @IBAction func makePurchase() {
        let tokenPersister = TokenPersister()
        tokenPersister.query { token in
            if let _ = token {
                self.validateUserData()
            } else {
                self.presentLogin()
            }
        }
    }
    
    func validateUserData() {
        self.userRequest.requestUserData { user, error in
            guard error == nil, let userData = user else {
                self.presentAlertWithTitle(title: "Erro", message: "Ocorreu um erro ao efetuar sua compra.")
                return
            }
            if userData.isEligibleToBuy() {
                
            } else {
                //present user form
            }
        }
    }
    
    func presentLogin() {
        self.performSegue(withIdentifier: "presentLogin", sender: nil)
    }
}
