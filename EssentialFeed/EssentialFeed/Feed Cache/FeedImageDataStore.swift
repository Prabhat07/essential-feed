//
//  FeedImageDataStore.swift
//  EssentialFeed
//
//  Created by Prabhat Tiwari on 22/07/25.
//

import Foundation

public protocol FeedImageDataStore {
    typealias RetrievalResult = Swift.Result<Data?, Error>
    typealias InsertionResult = Swift.Result<Void, Error>
    
    func insert(_ data: Data, for url: URL) throws
    func retrieve(dataForURL url: URL) throws -> Data?
    
    @available(*, deprecated)
    func insert(_ data: Data, for url: URL, completion: @escaping (InsertionResult) -> Void)
    
    @available(*, deprecated)
    func retrieve(dataForURL url: URL, completion:@escaping (RetrievalResult) -> Void)
}

public extension FeedImageDataStore {
    func insert(_ data: Data, for url: URL) throws {
        let dispathchGroup = DispatchGroup()
        var receiveResult: InsertionResult!
        
        dispathchGroup.enter()
        insert(data, for: url) {
            receiveResult = $0
            dispathchGroup.leave()
        }
        dispathchGroup.wait()
        return try receiveResult.get()
    }
    func retrieve(dataForURL url: URL) throws -> Data? {
        let dispathchGroup = DispatchGroup()
        var receiveResult: RetrievalResult!
        dispathchGroup.enter()
        retrieve(dataForURL: url) {
            receiveResult = $0
            dispathchGroup.leave()
        }
        dispathchGroup.wait()
        return try receiveResult.get()
    }
    
    func insert(_ data: Data, for url: URL, completion: @escaping (InsertionResult) -> Void) {}
    func retrieve(dataForURL url: URL, completion:@escaping (RetrievalResult) -> Void) {}
}
