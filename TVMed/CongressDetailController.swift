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
    @IBOutlet weak var midiaFisicaButton: UIButton!
    @IBOutlet weak var midiaOnlineButton: UIButton!
    @IBOutlet weak var midiaFisicaOnlineButton: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var discountPrice: UILabel!
    @IBOutlet weak var finalPrice: UILabel!
    @IBOutlet weak var descriptionButton: UIButton!
    @IBOutlet weak var congressImage: UIImageView!
    private var contentType: LoadContentType?
    private var userRequest = UserRequests()
    
    var currentMidia:MidiaPromotion?
    
    lazy var viewModel: CongressDetailViewModel = CongressDetailViewModel(delegate: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.midiaFisicaButton.tag = 0
        self.midiaOnlineButton.tag = 1
        self.midiaFisicaOnlineButton.tag = 2
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
        self.titleLabel.text = midia.nomeCongresso
        
        if midia.clienteComprouParaAssistirOnLine {
            self.finalPrice.isHidden = true
            self.discountPrice.isHidden = true
            self.midiaFisicaButton.setTitle("Assistir", for: .normal)
            self.midiaOnlineButton.isHidden = true
            self.midiaFisicaOnlineButton.isHidden = true
        } else {
            self.finalPrice.isHidden = false
            self.discountPrice.isHidden = false
            self.midiaFisicaButton.setTitle("Comprar Mídia fisica", for: .normal)
            self.midiaOnlineButton.isHidden = false
            self.midiaFisicaOnlineButton.isHidden = false
        }
        
        self.finalPrice.text = midia.getMidiaPrice()
        self.discountPrice.isHidden = !midia.hasDiscount()
        self.discountPrice.text = midia.hasDiscount() ? midia.discountPercentage() : ""
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
    
    @IBAction func makePurchase(sender: UIButton) {
        if viewModel.getCurrentMidia().clienteComprouParaAssistirOnLine {
            
        } else {
            let tokenPersister = TokenPersister()
            tokenPersister.query { token in
                if let _ = token {
                    self.validateUserData(tag: sender.tag)
                } else {
                    self.presentLogin()
                }
            }
        }
    }
    
    func validateUserData(tag: Int) {
        self.userRequest.requestUserData { user, error in
            guard error == nil, let userData = user else {
                self.presentAlertWithTitle(title: "Erro", message: "Ocorreu um erro ao efetuar sua compra.")
                return
            }
            if userData.isEligibleToBuy() {
                //buy
                guard self.viewModel.selectedMidia() else {
                    self.showDefaultSystemAlertWithDefaultLayout(message: "Escolha a Midia a ser comprada", completeBlock: nil)
                    return
                }
                let alertDTO = SystemAlertDTO(title: "Aviso", message: "Deseja comprar : \(self.viewModel.getCurrentMidia().nomeCongresso)", buttonActions: [(title: "Comprar", style: .default), (title: "Cancelar", style: .cancel)])
                self.showDefaultSystemAlert(systemAlertDTO: alertDTO, completeBlock: { action in
                    if action.title == "Comprar" {
                        let selectedPrice = self.viewModel.getCurrentMidia().midiaPrice(index: tag)
                        self.startLoading()
                        self.viewModel.addToCart(selectedPrice: selectedPrice)
                    }
                })
            } else {
                //present user form
                self.presentAlertWithTitle(title: "Erro", message: "Cadastro incompleto. Por favor, valide seu cadastro no navegador web")
            }
        }
    }
    
    func addedToCart(success: Bool) {
        stopLoading()
        if success {
            self.showDefaultSystemAlertWithDefaultLayout(message: "Adicionado ao Carrinho com sucesso!", completeBlock: nil)
        } else {
            self.showDefaultSystemAlertWithDefaultLayout(message: "Ocorreu um erro ao adicionar seu item ao carrinho. Por favor tente novamente.", completeBlock: nil)
        }
    }
    
    func presentLogin() {
        self.performSegue(withIdentifier: "presentLogin", sender: nil)
    }
    
    @IBAction func showDescription() {
        self.performSegue(withIdentifier: "sinopsePush", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier ==  "sinopsePush" {
            if let controller = segue.destination as? SinopseViewController {
                controller.currentText = viewModel.getCurrentMidia().formattedDescription()
            }
        }
    }
}
