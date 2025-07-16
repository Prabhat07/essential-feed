//
//  UITableView+Dequeueing.swift
//  EssentialFeediOS
//
//  Created by Prabhat Tiwari on 15/07/25.
//

import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        let identifires = String(describing: T.self)
        return dequeueReusableCell(withIdentifier: identifires) as! T
    }
}
