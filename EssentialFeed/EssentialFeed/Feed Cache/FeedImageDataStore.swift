//
//  FeedImageDataStore.swift
//  EssentialFeed
//
//  Created by Prabhat Tiwari on 22/07/25.
//

import Foundation

public protocol FeedImageDataStore {
    func insert(_ data: Data, for url: URL) throws
    func retrieve(dataForURL url: URL) throws -> Data?
 }
