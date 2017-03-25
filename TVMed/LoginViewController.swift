//
//  LoginViewController.swift
//  TVMed
//
//  Created by Vinicius Albino on 22/03/17.
//  Copyright © 2017 tvMed. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController, LoginDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    lazy var viewModel: LoginViewModel = LoginViewModel(delegate: self)
    
    func contentDidFinishedLoading(success: Bool) {
        stopLoading()
        guard success else {
            presentLoginIvalidAlert()
            return
        }
    }
    
    @IBAction func cancelLogin() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func makeLogin() {
        guard let emailText = emailTextField.text, let passwordText = passwordTextField.text else {
            presentLoginIvalidAlert()
            return
        }
        guard viewModel.validatesLogin(password: passwordText, email: emailText) else {
            presentLoginIvalidAlert()
            return
        }
        
        startLoading()
        viewModel.loginRequest(email: emailText, password: passwordText)
    }
    
    func presentLoginIvalidAlert() {
        self.presentAlertWithTitle(title: "Aviso", message: "Usuário ou senha inválidos")
    }
}
