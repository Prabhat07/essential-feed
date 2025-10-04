//
//  NullStore.swift
//  EssentialApp
//
//  Created by Prabhat Tiwari on 01/10/25.
//

import Foundation
import EssentialFeed

class NullStore: FeedStore & FeedImageDataStore {
    func deleteCachedFeed() throws {}

    func insert(_ feed: [LocalFeedImage], timestamp: Date) {}

    func retrieve() throws -> CachedFeed? { return .none }

    func insert(_ data: Data, for url: URL) throws { }
    
    func retrieve(dataForURL url: URL) throws -> Data? { .none }
}
