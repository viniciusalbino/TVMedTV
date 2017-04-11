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
    
    func getUserLabelData() -> String {
        if let user = currentUser {
            return "Olá , \(user.nome)"
        } else {
            return "Olá visitante"
        }
    }
    
    func textForRowAt(section: Int, index: Int) -> (title: String, subtitle: String) {
        guard let user = currentUser else {
            return (title: "", subtitle: "")
        }
        switch section {
        case 0:
            switch index {
            case 0:
                return (title: "Nome", subtitle: "\(user.nome)")
            case 1:
                return (title: "Email", subtitle: "\(user.email)")
            case 2:
                return (title: "Especialidade", subtitle: "\(user.especialidade)")
            case 3:
                return (title: "Telefone", subtitle: "\(user.foneDdd)-\(user.foneNumero)")
            case 4:
                return (title: "CPF / CNPJ", subtitle: "\(user.getDocumentNumber())")
            default:
                return (title: "", subtitle: "")
            }
        default:
            switch index {
            case 0:
                return (title: "Endereço", subtitle: "\(user.endereco), \(user.enderecoNumero)")
            case 1:
                return (title: "Complemento", subtitle: "\(user.enderecoComplemento)")
            case 2:
                return (title: "Cep", subtitle: "\(user.cep)")
            case 3:
                return (title: "Bairro - Cidade", subtitle: "\(user.bairro) - \(user.cidade)")
            case 4:
                return (title: "Estado", subtitle: "\(user.estado)")
            case 5:
                return (title: "País", subtitle: "\(user.pais)")
            default:
                return (title: "", subtitle: "")
            }
        }
    }
}
