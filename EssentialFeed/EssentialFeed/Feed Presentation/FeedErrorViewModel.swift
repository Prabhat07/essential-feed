//
//  FeedErrorViewModel.swift
//  EssentialFeed
//
//  Created by Prabhat Tiwari on 18/07/25.
//

import Foundation

public struct FeedErrorViewModel {
    public let message: String?
    
    static var noError: FeedErrorViewModel {
        return FeedErrorViewModel(message: nil)
    }
    
    static func error(message: String) -> FeedErrorViewModel {
        FeedErrorViewModel(message: message)
    }
}
