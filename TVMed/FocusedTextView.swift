//
//  FocusedTextView.swift
//  TVMed
//
//  Created by Vinicius Albino on 19/03/17.
//  Copyright © 2017 tvMed. All rights reserved.
//

import Foundation
import UIKit

class FocusedTextView: UITextView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
         panGestureRecognizer.allowedTouchTypes = [NSNumber(value: UITouchType.indirect.rawValue)]
        isUserInteractionEnabled = true
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
         if context.nextFocusedView == self {
            self.backgroundColor = .white
         } else {
            self.backgroundColor = .clear
        }
    }
    
    override var canBecomeFocused: Bool {
        return true
    }
}
