//
//  SKUIStoryboard+Ext.swift
//  SaleKit
//
//  Created by Nguyen Anh on 05/07/2021.
//

import Foundation
import UIKit

extension UIStoryboard {
    
    class func storyBoard(_ storyboard: String) -> UIStoryboard {
        return UIStoryboard(name: storyboard, bundle: nil)
    }
    
    func viewController<T: UIViewController>(of type: T.Type) -> T {
        guard let viewController =  instantiateViewController(withIdentifier: T.identifierView) as? T else {
            fatalError("Unabble to instantiate '\(T.identifierView)' ")
        }
        return viewController
    }
    
}
