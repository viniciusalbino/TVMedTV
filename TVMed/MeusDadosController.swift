//
//  MeusDadosController.swift
//  TVMed
//
//  Created by Vinicius de Moura Albino on 10/04/17.
//  Copyright © 2017 tvMed. All rights reserved.
//

import Foundation
import UIKit

class MeusDadosController: UIViewController, UITableViewDataSource, UITableViewDelegate, MeusDadosDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var portugueseButton: UIButton!
    @IBOutlet weak var spanishButton: UIButton!
    @IBOutlet weak var englishButton: UIButton!
    @IBOutlet weak var userLabel: UILabel!
    lazy var viewModel: MeusDadosViewModel = MeusDadosViewModel(delegate: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startLoading()
        viewModel.getUserData()
    }
    
    func contentDidFinishedLoading(success: Bool) {
        stopLoading()
        self.tableView.reloadData()
        self.userLabel.text = viewModel.getUserLabelData()
        guard success else {
            self.logoutButton.setTitle("Logout", for: .normal)
            return
        }
        self.logoutButton.setTitle("Login", for: .normal)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 5
        default:
            return 6
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Dados usuário"
        default:
            return "Dados endereço"
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "UserDataCell")!
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell =  cell as? UserDataCell {
            let texts = viewModel.textForRowAt(section: indexPath.section, index: indexPath.row)
            cell.fill(titleText: texts.title, subtitle: texts.subtitle)
        }
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
}
