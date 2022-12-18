//
//  SKUICollectionView+Ext.swift
//  SaleKit
//
//  Created by Nguyen Anh on 27/07/2021.
//

import Foundation

extension UICollectionView {

    /// Helper register cell
    /// The View must conform Identifier protocol
    func registerCell<T: Identifier>(_ viewType: T.Type) {
        self.register(viewType.xib(), forCellWithReuseIdentifier: viewType.identifierView)
    }

    /// Register Supplementary
    func registerSupplementaryView<T: Identifier>(_ supplementaryType: T.Type, kind: String) {
        self.register(supplementaryType.xib(), forSupplementaryViewOfKind: kind, withReuseIdentifier: supplementaryType.identifierView)
    }

    public func dequeueReusableCell<T: UICollectionViewCell>(cellType: T.Type, forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.identifierView, for: indexPath) as? T else {
            fatalError(" Could not dequeue cell with identifier: \(T.identifierView)")
        }
        return cell
    }

    func reloadData(completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0, animations: {
            self.reloadData()
            completion()
        })
    }

}
