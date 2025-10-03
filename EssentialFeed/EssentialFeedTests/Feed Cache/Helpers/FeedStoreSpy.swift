//
//  FeedStoreSpy.swift
//  EssentialFeedTests
//
//  Created by Prabhat Tiwari on 27/05/25.
//

import Foundation
import EssentialFeed


class FeedStoreSpy: FeedStore {
    
    private var deletionCompletions = [DeletionCompletion]()
    private var insertionCompletions = [InsertionCompletion]()
    private var retrievalCompletions = [RetrievalCompletion]()
    
    private var deletionResult: Result<Void, Error>?
    private var insertionResult: Result<Void, Error>?
    private var retrievalResult: Result<CachedFeed?, Error>?
    
    enum ReceivedMessage: Equatable {
        case retrieve
        case deleteCachedFeed
        case insert(feed: [LocalFeedImage], timeStamp: Date)
    }
    
    private(set) var receivedMessage = [ReceivedMessage]()
    
    func deleteCachedFeed() throws {
        receivedMessage.append(.deleteCachedFeed)
        try deletionResult?.get()
    }
    
    func insert(_ feed: [EssentialFeed.LocalFeedImage], timestamp: Date) throws {
        receivedMessage.append(.insert(feed: feed, timeStamp: timestamp))
        try insertionResult?.get()
    }
    
    func completeDeletion(with error: Error, at index: Int = 0) {
        deletionResult = .failure(error)
    }
    
    func completeDeletionSuccessfully(at index: Int = 0) {
        deletionResult = .success(())
    }
    
    func completeInsertion(with error: Error, at index: Int = 0) {
        insertionResult = .failure(error)
    }
    
    func completeInsertionSuccessfully(at index: Int = 0) {
        insertionResult = .success(())
    }
    
    func retrieve() throws -> CachedFeed? {
        receivedMessage.append(.retrieve)
        return try retrievalResult?.get()
    }
    
    func completeRetrieval(with error: Error, at index: Int = 0) {
         retrievalResult = .failure(error)
    }
    
    func completeRetrievalWithEmptyCache(at index: Int = 0) {
        retrievalResult = .success(.none)
    }
    
    func completeRetrieval(with feed: [LocalFeedImage], timestamp: Date, at index: Int = 0) {
        retrievalResult = .success(CachedFeed(feed: feed, timestamp: timestamp))
    }
}
