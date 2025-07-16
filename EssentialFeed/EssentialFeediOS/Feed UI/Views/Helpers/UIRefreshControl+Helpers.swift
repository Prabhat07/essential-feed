//
//  UIRefreshControl+Helpers.swift
//  EssentialFeediOS
//
//  Created by Prabhat Tiwari on 16/07/25.
//

import UIKit

extension UIRefreshControl {
    func update(isRefreshing: Bool) {
        isRefreshing ? beginRefreshing() : endRefreshing()
    }
}
