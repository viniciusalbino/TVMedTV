//
//  UITableViewCell+Extensions.swift
//  TVMed
//
//  Created by Vinicius Albino on 23/02/17.
//  Copyright © 2017 tvMed. All rights reserved.
//

import Foundation
import UIKit

extension UITableViewCell {
    class func createCell<T: UITableViewCell>(tableView: UITableView) -> T {
        // swiftlint:disable force_cast
        return tableView.dequeueReusableCell(withIdentifier: String(describing: T.self)) as! T
        // swiftlint:enable force_cast
    }
}
