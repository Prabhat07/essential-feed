//
//  FeedCache.swift
//  EssentialFeed
//
//  Created by Prabhat Tiwari on 04/08/25.
//

import Foundation

public protocol FeedCache {    
    func save(_ feed: [FeedImage]) throws
}
