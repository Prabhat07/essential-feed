//
//  FeedCache.swift
//  EssentialFeed
//
//  Created by Prabhat Tiwari on 04/08/25.
//

import Foundation

public protocol FeedCache {
    typealias SaveResult = Result<Void, Error>
    
    func save(_ feed: [FeedImage], completion: @escaping (SaveResult) -> Void)
}
