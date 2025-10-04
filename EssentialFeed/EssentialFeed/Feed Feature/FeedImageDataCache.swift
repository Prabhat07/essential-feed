//
//  FeedImageDataCache.swift
//  EssentialFeed
//
//  Created by Prabhat Tiwari on 05/08/25.
//

import Foundation

public protocol FeedImageDataCache {
    func save(_ data: Data, for url: URL) throws
}
