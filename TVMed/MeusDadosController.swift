//
//  MeusDadosController.swift
//  TVMed
//
//  Created by Vinicius de Moura Albino on 10/04/17.
//  Copyright © 2017 tvMed. All rights reserved.
//

import Foundation
import UIKit

class MeusDadosController: UIViewController, MeusDadosDelegate {
    
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var portugueseButton: UIButton!
    @IBOutlet weak var spanishButton: UIButton!
    @IBOutlet weak var englishButton: UIButton!
    @IBOutlet weak var emailLabel:UILabel!
    @IBOutlet weak var nameLabel:UILabel!
    @IBOutlet weak var especLabel:UILabel!
    @IBOutlet weak var cpfLabel:UILabel!
    @IBOutlet weak var telLabel:UILabel!
    @IBOutlet weak var cepLabel:UILabel!
    @IBOutlet weak var numLabel:UILabel!
    @IBOutlet weak var compLabel:UILabel!
    @IBOutlet weak var cardLine1Label:UILabel!
    @IBOutlet weak var cardLine2Label:UILabel!
    @IBOutlet weak var bacgkgroundView: UIView!
    lazy var viewModel: MeusDadosViewModel = MeusDadosViewModel(delegate: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addLogo()
        self.portugueseButton.tag = 0
        self.spanishButton.tag = 1
        self.englishButton.tag = 2
        
        self.bacgkgroundView.layer.cornerRadius = 10
        self.portugueseButton.layer.cornerRadius = 5
        self.spanishButton.layer.cornerRadius = 5
        self.englishButton.layer.cornerRadius = 5
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startLoading()
        viewModel.getUserData()
    }
    
    func contentDidFinishedLoading(success: Bool) {
        stopLoading()
        guard success else {
            self.logoutButton.setTitle("Login", for: .normal)
            emptyTexts()
            return
        }
        self.logoutButton.setTitle("Logout", for: .normal)
        
        self.emailLabel.text = viewModel.textForRowAt(index: 0).subtitle
        self.nameLabel.text = viewModel.textForRowAt(index: 1).subtitle
        self.especLabel.text = viewModel.textForRowAt(index: 2).subtitle
        self.cpfLabel.text = viewModel.textForRowAt(index: 3).subtitle
        self.telLabel.text = viewModel.textForRowAt(index: 4).subtitle
        self.cepLabel.text = viewModel.textForRowAt(index: 5).subtitle
        self.numLabel.text = viewModel.textForRowAt(index: 6).subtitle
        self.compLabel.text = viewModel.textForRowAt(index: 7).subtitle
    }
    
    func emptyTexts() {
        self.emailLabel.text = ""
        self.nameLabel.text = ""
        self.especLabel.text = ""
        self.cpfLabel.text = ""
        self.telLabel.text = ""
        self.cepLabel.text = ""
        self.numLabel.text = ""
        self.compLabel.text = ""
        self.cardLine1Label.text = ""
        self.cardLine2Label.text = ""
    }
    
    @IBAction func login() {
        if viewModel.isUserLoggedIn() {
            let dto = SystemAlertDTO(title: "Aviso", message: "Deseja deslogar?", buttonActions: [(title: "Logoff", style: .default), (title: "Cancelar", style: .cancel)])
            self.showDefaultSystemAlert(systemAlertDTO: dto , completeBlock: { action in
                if action.title == "Logoff" {
                    self.startLoading()
                    self.viewModel.logout()
                }
            })
        } else {
            self.performSegue(withIdentifier: "presentLogin", sender: nil)
        }
    }
    
    @IBAction func changeLanguage(sender: UIButton) {
        let dto = SystemAlertDTO(title: "Aviso", message: "Deseja Modificar a linguagem do app?", buttonActions: [(title: "Mudar", style: .default), (title: "Cancelar", style: .cancel)])
        self.showDefaultSystemAlert(systemAlertDTO: dto , completeBlock: { action in
            if action.title == "Mudar" {
                self.startLoading()
                self.viewModel.logout()
                switch sender.tag {
                case 0:
                    LanguageHeader().changeHeaderLanguage(header: .portuguese)
                case 1:
                    LanguageHeader().changeHeaderLanguage(header: .spanish)
                default:
                    LanguageHeader().changeHeaderLanguage(header: .english)
                }
            }
        })
    }
}
