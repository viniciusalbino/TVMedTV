//
//  MeusDadosViewModel.swift
//  TVMed
//
//  Created by Vinicius de Moura Albino on 10/04/17.
//  Copyright © 2017 tvMed. All rights reserved.
//

import Foundation

protocol MeusDadosDelegate: class {
    func contentDidFinishedLoading(success: Bool)
}

class MeusDadosViewModel {
    
    private weak var delegate: MeusDadosDelegate?
    private var userRequest = UserRequests()
    private var currentUser: User?
    private var creditCardPersister = CreditCardPersister()
    private var tokenPersister = TokenPersister()
    private var cartPersister = CartPersister()
    
    init(delegate: MeusDadosDelegate) {
        self.delegate = delegate
    }
    
    func getUserData() {
        self.userRequest.requestUserData { user, error in
            guard error == nil, let userData = user else {
                self.delegate?.contentDidFinishedLoading(success: false)
                return
            }
            self.currentUser = userData
            self.delegate?.contentDidFinishedLoading(success: true)
        }
    }
    
    func isUserLoggedIn() -> Bool {
        if let user = currentUser, user.nome.length() > 0 {
            return true
        } else {
            return false
        }
    }
    
    func logout() {
        self.currentUser = nil
        cartPersister.delete { _ in }
        tokenPersister.delete { _ in }
        self.delegate?.contentDidFinishedLoading(success: false)
    }
    
    func getUserLabelData() -> String {
        if let user = currentUser, user.nome.length() > 0 {
            return "Olá , \(user.nome)"
        } else {
            return "Olá, visitante"
        }
    }
    
    func textForRowAt(index: Int) -> (title: String, subtitle: String) {
        guard let user = currentUser else {
            return (title: "", subtitle: "")
        }
        switch index {
        case 0:
            return (title: "Email", subtitle: "\(user.email)")
        case 1:
            return (title: "Nome", subtitle: "\(user.nome)")
        case 2:
            return (title: "Especialidade", subtitle: "\(user.especialidade)")
        case 3:
            return (title: "CPF / CNPJ", subtitle: "\(user.getDocumentNumber())")
        case 4:
            return (title: "Telefone", subtitle: "\(user.foneDdd)-\(user.foneNumero)")
        case 5:
            return (title: "Cep", subtitle: "\(user.cep)")
        case 6:
            return (title: "Endereço", subtitle: "\(user.enderecoNumero)")
        case 7:
            return (title: "Complemento", subtitle: "\(user.enderecoComplemento)")
        default:
            return (title: "", subtitle: "")
        }
    }
}
