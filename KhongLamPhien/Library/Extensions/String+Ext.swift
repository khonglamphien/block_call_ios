//
//  String+Ext.swift
//  KhongLamPhien
//
//  Created by Nguyen Anh on 11/01/2023.
//

import Foundation

extension String {
    
    /// A localized string for the specified localization key.
    var localized: String {
        let path = Bundle.main.path(forResource: Session.shared.laguage, ofType: "lproj")
            let bundle = Bundle(path: path!)

            return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
//        return NSLocalizedString(self, comment: "")
    }
    
}
