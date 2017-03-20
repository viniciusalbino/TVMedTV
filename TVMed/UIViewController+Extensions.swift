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
    func startLoading() {
        SVProgressHUD.setDefaultStyle(.light)
        SVProgressHUD.show()
    }
    
    func stopLoading() {
        SVProgressHUD.dismiss()
    }
}
