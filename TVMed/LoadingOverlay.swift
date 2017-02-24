//
//  LoadingOverlay.swift
//  TVMed
//
//  Created by Vinicius Albino on 23/02/17.
//  Copyright © 2017 tvMed. All rights reserved.
//

import Foundation
import UIKit

public class LoadingOverlay {
    
    var overlayView : UIView!
    var activityIndicator : UIActivityIndicatorView!
    var alert:UIAlertController!
    
    class var shared: LoadingOverlay {
        struct Static {
            static let instance: LoadingOverlay = LoadingOverlay()
        }
        return Static.instance
    }
    
    init(){
        alert = UIAlertController(title: nil, message: "Carregando...", preferredStyle: .alert)
        
        alert.view.tintColor = UIColor.lightGray
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50)) as UIActivityIndicatorView
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = .white
        alert.view.addSubview(activityIndicator)
    }
    
    public func showOverlay(viewController: UIViewController) {
        activityIndicator.startAnimating()
        viewController.present(alert, animated: true, completion: nil)
    }
    
    public func hideOverlayView(viewController: UIViewController) {
        activityIndicator.stopAnimating()
        viewController.dismiss(animated: true, completion: nil)
        
    }
}
