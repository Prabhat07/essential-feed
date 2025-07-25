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
    
    func insert(_ data: Data, for url: URL, completion: @escaping (InsertionResult) -> Void)
    func retrieve(dataForURL url: URL, completion:@escaping (RetrievalResult) -> Void)
}
