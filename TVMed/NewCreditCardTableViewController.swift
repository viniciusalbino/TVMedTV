//
//  CreditCardTableViewController.swift
//  TVMed
//
//  Created by Vinicius de Moura Albino on 08/04/17.
//  Copyright © 2017 tvMed. All rights reserved.
//

import Foundation
import UIKit

class NewCreditCardTableViewController: UITableViewController, UITextFieldDelegate {
    
    private var creditCardPersister = CreditCardPersister()
    @IBOutlet weak var creditCardNumberField: MaskCreditCardTextField!
    @IBOutlet weak var creditCardNameField: MaskNameTextField!
    @IBOutlet weak var creditCardDateField: MaskCreditCardDateValidationTextField!
    @IBOutlet weak var creditCardCVVField: MaskCreditCardCVCTextField!
    @IBOutlet weak var saveButton:UIButton!
    
    var currentTextField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addDelegates()
        setNeedValidateFields()
    }
    
    private func addDelegates() {
        allTextFields.forEach { $0.delegate = self }
    }
    
    private var allTextFields: [UITextField] {
        return [creditCardNumberField, creditCardNameField, creditCardDateField, creditCardCVVField]
    }
    
    private var obligatoryFields: [AnnotatedTextField] {
        return [creditCardNumberField, creditCardNameField, creditCardDateField, creditCardCVVField]
    }
    
    private func setNeedValidateFields() {
        obligatoryFields.forEach { $0.needValidation = true }
    }
    
    private func treatInvalidateTextField(field: UITextField) {
        dismissAllTextFields()
        currentTextField = field
    }
    
    private func dismissAllTextFields() {
        self.view.endEditing(true)
    }
    
    func validate() -> Bool {
        return validateFields(fields: obligatoryFields)
    }
    
    private func validateFields(fields: [AnnotatedTextField]) -> Bool {
        checkPlaceholderColor(fields: fields)
        
        var isValidFields = true
        var textFieldToTreat: UITextField?
        for textField in fields {
            guard let text = textField.text else {
                return false
            }
            if text.isEmpty {
                treatInvalidateTextField(field: textField)
                return false
            }
            fields.flatMap({ $0 as? TextFieldMask }).filter {$0.needValidation}.forEach { if !$0.isValid() {
                if textFieldToTreat == nil {
                    textFieldToTreat = $0
                }
                
                isValidFields = false
                }
            }
        }
        
        if !isValidFields {
            if let tf = textFieldToTreat {
                treatInvalidateTextField(field: tf)
            }
        }
        return isValidFields
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == creditCardNameField && string != " " {
            let characterSet = CharacterSet.letters
            if string.rangeOfCharacter(from: characterSet.inverted) != nil {
                return false
            }
        }
        return TextFieldMask.textField(textField: textField, shouldChangeCharactersInRange: range, replacementString: string)
    }
    
    private func checkPlaceholderColor(fields: [AnnotatedTextField]) {
        for textField in fields {
            if let text = textField.text {
                if text.isEmpty {
                    textField.invalidate()
                } else {
                    fields.flatMap({ $0 as? TextFieldMask}).filter {$0.needValidation}.forEach {$0.isValid() ? $0.validate() : $0.invalidate() }
                }
            }
        }
    }
    
    func dateComponents(dateText: String) -> (year: String, month: String) {
        let dateArray = dateText.trimWhiteSpaces().components(separatedBy: "/")
        return (dateArray.last ?? "", dateArray.first ?? "")
    }
    
    @IBAction func saveCreditCard() {
        if validate() {
            guard let cardNumber = creditCardNumberField.text, let cardName = creditCardNameField.text, let date = creditCardDateField.text, let cvv = creditCardCVVField.text else {
                self.showDefaultSystemAlertWithDefaultLayout(message: "Preencha corretamente os campos indicados.", completeBlock: { _ in })
                return
            }
            let dates = dateComponents(dateText: date)
            let newCard = CreditCard()
            let brandEnum = BrandEnum(rawValue: creditCardNumberField.type!)
            newCard.cardNumber = cardNumber
            newCard.name = cardName
            newCard.month = dates.month
            newCard.year = dates.year
            newCard.cvv = cvv
            newCard.brand = brandEnum.intValue
            newCard.brandImage = creditCardNumberField.type!
            
            self.creditCardPersister.save(card: newCard, callback: { success in
                if success {
                    self.showDefaultSystemAlertWithDefaultLayout(message: "Cartão salvo com sucesso!", completeBlock: { _ in
                        _ = self.navigationController?.popViewController(animated: true)
                    })
                } else {
                    self.showDefaultSystemAlertWithDefaultLayout(message: "Ocorreu um erro ao salvar seu cartão, por favor tente novamente", completeBlock: { _ in })
                }
            })
        } else {
            self.showDefaultSystemAlertWithDefaultLayout(message: "Preencha corretamente os campos indicados.", completeBlock: { _ in })
        }
    }
}
