//
//  ErrorView.swift
//  EssentialFeediOS
//
//  Created by Prabhat Tiwari on 16/07/25.
//

import UIKit

public final class ErrorView: UIView {
    @IBOutlet private(set) var label: UILabel!
    
    public var message: String? {
        get { label.text }
        set { label.text = newValue }
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        label.text = nil
    }
}
