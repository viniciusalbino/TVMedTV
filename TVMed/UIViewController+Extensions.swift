//
//  UIViewController+Extensions.swift
//  TVMed
//
//  Created by Vinicius Albino on 19/03/17.
//  Copyright © 2017 tvMed. All rights reserved.
//

import Foundation
import SVProgressHUD

extension UIViewController {
    
    func presentAlertWithTitle(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { _ in }
        alertController.addAction(OKAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func startLoading() {
        SVProgressHUD.setDefaultStyle(.light)
        SVProgressHUD.show()
    }
    
    func stopLoading() {
        SVProgressHUD.dismiss()
    }
}
