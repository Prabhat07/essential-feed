//
//  UIControl+TestHelpers.swift
//  EssentialFeediOSTests
//
//  Created by Prabhat Tiwari on 08/07/25.
//

import UIKit

extension UIControl {
    func simulate(event: UIControl.Event) {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: event)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}
