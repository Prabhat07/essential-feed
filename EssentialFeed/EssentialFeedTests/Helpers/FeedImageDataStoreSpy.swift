//
//  FeedImageDataStoreSpy.swift
//  EssentialFeedTests
//
//  Created by Prabhat Tiwari on 23/07/25.
//

import Foundation
import EssentialFeed

class FeedImageDataStoreSpy: FeedImageDataStore {
    
    enum Message: Equatable {
        case retrieve(dataFor: URL)
        case insert(data: Data, for: URL)
    }
    
    var retrievalCompletions = [(FeedImageDataStore.RetrievalResult) -> Void]()
    var insertionCompletions = [(FeedImageDataStore.InsertionResult) -> Void]()
    private(set) var receivedMessages = [Message]()
    
    func retrieve(dataForURL url: URL, completion:@escaping (FeedImageDataStore.RetrievalResult) -> Void) {
        receivedMessages.append(.retrieve(dataFor: url))
        retrievalCompletions.append(completion)
    }
    
    func completeRetrieval(with error: Error, at index: Int = 0) {
        retrievalCompletions[index](.failure(error))
    }
    
    func completeRetrieval(with data: Data?, at index: Int = 0) {
        retrievalCompletions[index](.success(data))
    }
    
    // Insert
    
    func insert(_ data: Data, for url: URL, completion: @escaping (InsertionResult) -> Void) {
        receivedMessages.append(.insert(data: data, for: url))
        insertionCompletions.append(completion)
    }
    
    func completeInsertion(with error: Error, at index: Int = 0) {
        insertionCompletions[index](.failure(error))
    }
    
    func completeInsertionSuccessfully(at index: Int = 0) {
        insertionCompletions[index](.success(()))
    }
}

