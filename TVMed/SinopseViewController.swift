//
//  SinopseViewController.swift
//  TVMed
//
//  Created by Vinicius de Moura Albino on 09/04/17.
//  Copyright © 2017 tvMed. All rights reserved.
//

import Foundation
import UIKit

class SinopseViewController: UIViewController {
    @IBOutlet weak var textView: FocusedTextView!
    var currentText = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.textView.text = currentText
    }
}
