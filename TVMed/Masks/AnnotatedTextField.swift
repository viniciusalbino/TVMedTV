//
//  AnnotatedTextField.swift
//  Shoestock
//
//  Created by Vinicius de Moura Albino on 06/03/17.
//  Copyright © 2017 Netshoes. All rights reserved.
//

import Foundation
import UIKit

class AnnotatedTextField: UITextField {
    
    private var annotatedTextFieldContext = 0
    
    var annotationLabel = UILabel()
    var heightConstraint = NSLayoutConstraint()
    var isRequired = true
    var needValidation = false
    var invalidatedColor: UIColor = .red
    var validColor: UIColor = .black
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeView()
    }
    
    deinit {
        removeObserver(self, forKeyPath: "text", context: &annotatedTextFieldContext)
    }
    
    func initializeView() {
        addTarget(self, action: #selector(textChanged(textField:)), for: .editingChanged)
        addObserver(self, forKeyPath: "text", options: .new, context: &annotatedTextFieldContext)
        contentVerticalAlignment = .bottom
        annotationLabel = createAnnotationLabel()
        annotationLabel.accessibilityIdentifier = "annotated_text_field.uilabel.annotation_label"
        addSubview(annotationLabel)
        addConstraints()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == &annotatedTextFieldContext {
            textChanged(textField: self)
        }
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(super.textRect(forBounds: bounds), UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0))
    }
    
    func textChanged(textField: UITextField) {
        if let text = textField.text {
            if text.characters.count > 0 {
                validate()
            }
            toggleAnnotationVisibility(show: text.characters.count > 0)
        }
    }
    
    /// Shows the annotation label that appears about the user's input.
    /// If the annotationLabel is showing and the argument is true, the
    /// animation is not executed because it animates the input text,
    /// which is not desired.
    func toggleAnnotationVisibility(show: Bool) {
        if self.annotationLabel.alpha == 1 && show {
            return
        }
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: [], animations: {
            self.heightConstraint.constant = show ? 10 : 0
            self.annotationLabel.alpha = show ? 1 : 0
            self.annotationLabel.layoutIfNeeded()
        }, completion: nil)
    }
    
    func createAnnotationLabel() -> UILabel {
        let label = UILabel()
        label.text = self.placeholder
        label.translatesAutoresizingMaskIntoConstraints = false
        label.minimumScaleFactor = 0.3
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = validColor
        label.alpha = 0
        label.accessibilityIdentifier = "annotated_text_field.uilabel.label"
        return label
    }
    
    func addConstraints() {
        let views = ["annotationLabel": annotationLabel]
        let metrics = ["height": 0, "leftInset": self.borderStyle == .roundedRect ? 7 : 0, "verticalInset": 8]
        
        let vertical = NSLayoutConstraint.constraints(withVisualFormat: "V:|-verticalInset-[annotationLabel(height)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views)
        heightConstraint = vertical[1]
        let horizontal = NSLayoutConstraint.constraints(withVisualFormat: "H:|-leftInset-[annotationLabel]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views)
        self.addConstraints(vertical)
        self.addConstraints(horizontal)
        self.updateConstraints()
    }
    
    /// Paints the text field as "invalid"
    func invalidate() {
        DispatchQueue.main.async {
            self.textColor = self.invalidatedColor
            self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes: [NSForegroundColorAttributeName: self.invalidatedColor])
            self.annotationLabel.textColor = self.invalidatedColor
        }
    }
    
    /// Paints the text field as "valid", i.e., its standard appearance.
    func validate() {
        DispatchQueue.main.async {
            self.textColor = self.validColor
            self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes: [NSForegroundColorAttributeName: self.validColor.withAlphaComponent(0.7)])
            self.annotationLabel.textColor = self.validColor
        }
    }
    
    /// Verifies whether text field has been invalidated visually. This is independent of
    /// whether the text inside the text field is valid.
    func isInvalidated() -> Bool {
        return textColor == invalidatedColor
    }
}
