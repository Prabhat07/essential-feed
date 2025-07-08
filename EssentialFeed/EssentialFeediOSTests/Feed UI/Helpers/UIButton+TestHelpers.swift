//
//  UIButton+TestHelpers.swift
//  EssentialFeediOSTests
//
//  Created by Prabhat Tiwari on 08/07/25.
//

import UIKit

extension UIButton {
    func simulateTap() {
        simulate(event: .touchUpInside)
    }
}
