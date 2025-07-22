//
//  FeedImageDataStore.swift
//  EssentialFeed
//
//  Created by Prabhat Tiwari on 22/07/25.
//

import Foundation

public protocol FeedImageDataStore {
    typealias Result = Swift.Result<Data?, Error>
    func retrieve(dataForURL url: URL, completion:@escaping (Result) -> Void)
}
