//
//  FocusTextView.swift
//  TVMed
//
//  Created by Vinicius de Moura Albino on 12/04/17.
//  Copyright © 2017 tvMed. All rights reserved.
//

import Foundation
import UIKit

class FocusTextView: UITextView {
    
    private let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
    
    private let motionEffectGroup = UIMotionEffectGroup()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        isSelectable = true
        isScrollEnabled = false
        clipsToBounds = false
        textContainer.lineBreakMode = .byTruncatingTail
        textContainerInset = .zero;
        
        blurEffectView.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        blurEffectView.frame = bounds.insetBy(dx: -10, dy: -10)
        blurEffectView.alpha = 0
        blurEffectView.layer.cornerRadius = 10
        blurEffectView.clipsToBounds = true
        insertSubview(blurEffectView, at: 0)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        
        tap.allowedPressTypes = [NSNumber(value: UIPressType.select.rawValue)]
        addGestureRecognizer(tap)
        
        let motionRange = 5
        
        let verticalMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        verticalMotionEffect.minimumRelativeValue = -motionRange
        verticalMotionEffect.maximumRelativeValue = motionRange
        
        let tiltAngle = CGFloat(1 * M_PI / 180)
        
        var minX = CATransform3DIdentity
        minX.m34 = 1.0 / 500
        minX = CATransform3DRotate(minX, -tiltAngle, 1, 0, 0)
        
        var maxX = CATransform3DIdentity
        maxX.m34 = minX.m34
        maxX = CATransform3DRotate(maxX, tiltAngle, 1, 0, 0)
        
        let verticalTiltEffect = UIInterpolatingMotionEffect(keyPath: "layer.transform", type: .tiltAlongVerticalAxis)
        verticalTiltEffect.minimumRelativeValue =  NSValue(caTransform3D: minX)
        verticalTiltEffect.maximumRelativeValue =  NSValue(caTransform3D: maxX)
        
        self.motionEffectGroup.motionEffects = [verticalMotionEffect, verticalTiltEffect]
    }
    
    func tapped(_ gestureRecognizer: UITapGestureRecognizer) {
        if let vc = delegate as? UIViewController {
            let storyboard = UIStoryboard(name: "ModalTextView", bundle: nil)
            let modal = storyboard.instantiateViewController(withIdentifier: "Modal") as! TextPresentationViewController
            modal.modalPresentationStyle = .overFullScreen
            vc.present(modal, animated: true, completion: {
                modal.textView.attributedText = self.attributedText
                modal.textView.textColor = .white
            })
        }
    }
    
    override var canBecomeFocused: Bool {
        return true
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        
        if context.nextFocusedView == self {
            coordinator.addCoordinatedAnimations({ () -> Void in
                self.blurEffectView.alpha = 1
                self.addMotionEffect(self.motionEffectGroup)
            }, completion: nil)
        } else if context.previouslyFocusedView == self {
            coordinator.addCoordinatedAnimations({ () -> Void in
                self.blurEffectView.alpha = 0
                self.removeMotionEffect(self.motionEffectGroup)
            }, completion: nil)
        }
    }
}

class TextPresentationViewController:UIViewController {
    @IBOutlet weak var textView: UITextView!
    let blurStyle = UIBlurEffectStyle.dark
    
    override func viewDidLoad() {
        self.textView.isUserInteractionEnabled = true
         textView.panGestureRecognizer.allowedTouchTypes = [NSNumber(value: UITouchType.indirect.rawValue)]
    }
}
