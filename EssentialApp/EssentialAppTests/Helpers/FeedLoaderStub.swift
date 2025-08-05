//
//  FeedLoaderStub.swift
//  EssentialAppTests
//
//  Created by Prabhat Tiwari on 02/08/25.
//

import EssentialFeed

class FeedLoaderStub: FeedLoader {
    private let result: FeedLoader.Result

    init(result: FeedLoader.Result) {
        self.result = result
    }

    func load(completion: @escaping (FeedLoader.Result) -> Void) {
        completion(result)
    }
}
