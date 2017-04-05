//
//  UIalertController+Extensions.swift
//  TVMed
//
//  Created by Vinicius de Moura Albino on 04/04/17.
//  Copyright © 2017 tvMed. All rights reserved.
//

import Foundation
import UIKit

typealias AlertSystemButtonParameters = (title: String, style: UIAlertActionStyle)

struct SystemAlertDTO: Equatable {
    var title: String?
    var message: String?
    var buttonActions = [AlertSystemButtonParameters]()
    
    static func == (lhs: SystemAlertDTO, rhs: SystemAlertDTO) -> Bool {
        return  lhs.title == rhs.title &&
            lhs.message == rhs.message &&
            lhs.buttonActions.count == rhs.buttonActions.count &&
            lhs.buttonActions.first?.title == rhs.buttonActions.first?.title &&
            lhs.buttonActions.first?.style == rhs.buttonActions.first?.style
    }
}

extension UIViewController {
    
    func showDefaultSystemAlert(systemAlertDTO: SystemAlertDTO, completeBlock: ((UIAlertAction) -> Void)?) {
        let alertController = UIAlertController(title: systemAlertDTO.title, message: systemAlertDTO.message, preferredStyle: .alert)
        
        for buttonAction in systemAlertDTO.buttonActions {
            let action = UIAlertAction(title: buttonAction.title, style: buttonAction.style, handler: completeBlock)
            alertController.addAction(action)
        }
        
        if systemAlertDTO.buttonActions.isEmpty {
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
                alertController.dismiss(animated: true, completion: nil)
            })
            alertController.addAction(okAction)
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showDefaultSystemAlertWithDefaultLayout(message: String, completeBlock: ((UIAlertAction) -> Void)?) {
        let alertController = UIAlertController(title: "Aviso", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: completeBlock)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showYesNoAlert(message: String, yesButton: String, completeBlock: ((UIAlertAction) -> Void)?) {
        let alertController = UIAlertController(title: "Aviso", message: message, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: yesButton, style: .default, handler: completeBlock)
        let notAction = UIAlertAction(title: "Cancelar", style: .default, handler: completeBlock)
        alertController.addAction(notAction)
        alertController.addAction(yesAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
