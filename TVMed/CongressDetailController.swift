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

class CongressDetailController: UIViewController, CongressDetailDelegate, UITextViewDelegate, SelectedMidiaDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    private var contentType: LoadContentType?
    private var userRequest = UserRequests()
    
    var currentMidia:MidiaPromotion?
    
    lazy var viewModel: CongressDetailViewModel = CongressDetailViewModel(delegate: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            self.fillScreen()
        } else {
            
        }
    }
    
    func fillScreen() {
        let height = self.viewModel.numberOfItensInSection() * 600
        self.scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width - 40, height: self.view.frame.size.height)
        for index in 0..<viewModel.numberOfItensInSection() {
            if let congressCell = UINib(nibName: "CongressCell", bundle: nil).instantiate(withOwner: nil, options: nil).first as? CongressCell {
                self.scrollView.addSubview(congressCell)
                congressCell.frame = CGRect(x: 20, y: (index * 500), width: Int(self.scrollView.frame.size.width - 40), height: 450)
                congressCell.fill(midia: viewModel.midiaForRow(row: index), delegate: self, midiaDelegate: self, row: index)
                congressCell.layer.cornerRadius = 5
            }
        }
        self.scrollView.contentSize = CGSize(width: Int(self.view.frame.size.width), height: height)
    }
    
    func didSelectedMidia(row: Int, midiaIndex: Int) {
        let tokenPersister = TokenPersister()
        tokenPersister.query { token in
            if let _ = token {
                let midia = self.viewModel.midiaForRow(row: row)
                let price = midia.midiaPrice(index: midiaIndex)
                self.validateUserData(midia: midia, price: price)
                
            } else {
                self.presentLogin()
            }
        }
    }
    
    func validateUserData(midia: MidiaPromotion, price: Float) {
        self.userRequest.requestUserData { user, error in
            guard error == nil, let userData = user else {
                self.presentAlertWithTitle(title: "Erro", message: "Ocorreu um erro ao efetuar sua compra.")
                return
            }
            if userData.isEligibleToBuy() {
                guard self.viewModel.selectedMidia() else {
                    self.showDefaultSystemAlertWithDefaultLayout(message: "Escolha a Midia a ser comprada", completeBlock: nil)
                    return
                }
                let alertDTO = SystemAlertDTO(title: "Aviso", message: "Deseja comprar : \(midia.congressoFormattedName())", buttonActions: [(title: "Comprar", style: .default), (title: "Cancelar", style: .cancel)])
                self.showDefaultSystemAlert(systemAlertDTO: alertDTO, completeBlock: { action in
                    if action.title == "Comprar" {
                        self.startLoading()
                        self.viewModel.addToCart(selectedPrice: price, midia: midia)
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
