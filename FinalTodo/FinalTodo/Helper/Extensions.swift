//
//  Extensions.swift
//  FinalTodo
//
//  Created by SR on 2023/10/11.
//

import UIKit

extension UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UICollectionViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}
