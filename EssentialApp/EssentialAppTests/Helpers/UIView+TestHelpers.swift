//
//  UIView+TestHelpers.swift
//  EssentialAppTests
//
//  Created by Prabhat Tiwari on 01/09/25.
//

import UIKit

extension UIView {
    func enforceLayoutCycle() {
        layoutIfNeeded()
        RunLoop.current.run(until: Date())
    }
}
