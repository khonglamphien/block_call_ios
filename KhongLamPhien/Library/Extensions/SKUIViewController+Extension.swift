//
//  SKUIViewController+Extension.swift
//  SaleKit
//
//  Created by Nguyen Anh on 05/07/2021.
//

import Foundation
import UIKit

extension UIViewController: Identifier {
    
    /// ID View
    static var identifierView: String {
        return String(describing: self)
    }
    
    /// XIB
    static func xib() -> UINib? {
        return UINib(nibName: self.identifierView, bundle: nil)
    }
}

protocol Identifier {
    
    /// ID view
    static var identifierView: String {get}

    /// XIB - init XIB from identifierView
    static func xib() -> UINib?
}
