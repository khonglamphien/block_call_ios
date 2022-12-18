//
//  SKUICollectionView+Ext.swift
//  SaleKit
//
//  Created by Nguyen Anh on 27/07/2021.
//

import Foundation

extension UITableView {

    /// Helper register cell
    /// The View must conform Identifier protocol
    func registerCell<T: Identifier>(_ viewType: T.Type) {
        self.register(viewType.xib(), forCellReuseIdentifier: viewType.identifierView)
    }

    public func dequeueReusableCell<T: UITableViewCell>(cellType: T.Type, forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.identifierView, for: indexPath) as? T else {
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
