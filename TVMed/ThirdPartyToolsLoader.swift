//
//  ThirdPartyToolsLoader.swift
//  TVMed
//
//  Created by Vinicius Albino on 30/01/17.
//  Copyright © 2017 tvMed. All rights reserved.
//

import Foundation
import UIKit

protocol ThirdPartyTool {
    static func loadTool(application: UIApplication)
}

class ThirdPartyToolsLoader: NSObject {
    
    private static let _sharedInstance = ThirdPartyToolsLoader()
    
    class func sharedInstance() -> ThirdPartyToolsLoader {
        return _sharedInstance
    }
    
    func loadTools(application: UIApplication) {
        FabricTracker.loadTool(application: application)
    }
}
