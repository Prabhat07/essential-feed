//
//  FeedImageViewModel.swift
//  EssentialFeed
//
//  Created by Prabhat Tiwari on 20/07/25.
//

import Foundation

public struct FeedImageViewModel {
    public let description: String?
    public let location: String?
    
    public var hasLocation: Bool {
        return location != nil
    }
}
