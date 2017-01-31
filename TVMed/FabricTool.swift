//
//  FabricTool.swift
//  TVMed
//
//  Created by Vinicius Albino on 30/01/17.
//  Copyright © 2017 tvMed. All rights reserved.
//

import Foundation
import Fabric
import Crashlytics
import UIKit

class FabricTracker: ThirdPartyTool {
    class func loadTool(application: UIApplication) {
        Fabric.with([Crashlytics.sharedInstance()])
    }
}
