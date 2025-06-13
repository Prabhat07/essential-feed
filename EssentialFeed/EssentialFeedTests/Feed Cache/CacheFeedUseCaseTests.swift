//
//  CacheFeedUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Prabhat Tiwari on 21/05/25.
//

import XCTest
import EssentialFeed

final class CacheFeedUseCaseTests: XCTestCase {
    
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.receivedMessage, [])
    }
    
    func test_save_requestsCacheDeletion() {
        let (sut, store) = makeSUT()
                
        sut.save(uniqueImageFeed().models) { _ in }
        
        XCTAssertEqual(store.receivedMessage, [.deleteCachedFeed])
    }
    
    func test_save_doesNotRequestCacheInsertionOnDeletionError() {
        let (sut, store) = makeSUT()
        let deletionError = anyNSError()
        
        sut.save(uniqueImageFeed().models) { _ in }
        store.completeDeletion(with: deletionError)
        
        XCTAssertEqual(store.receivedMessage, [.deleteCachedFeed])
    }
    
    func test_save_requestsNewCacheInsertionWithTimestampOnSuccessfulDeletion() {
        let timeStamp = Date()
        let (sut, store) = makeSUT { timeStamp }
        let feed = uniqueImageFeed()
        sut.save(feed.models) { _ in }
        store.completeDeletSuccessfully()
        
        XCTAssertEqual(store.receivedMessage, [.deleteCachedFeed, .insert(feed: feed.local, timeStamp: timeStamp)])
    }
    
    func test_save_failsOnDeletionError() {
        let (sut, store) = makeSUT()
        let deletionError = anyNSError()
        
        expect(sut, toCompleteWithError: deletionError, when: {
            store.completeDeletion(with: deletionError)
        })
    }
    
    func test_save_failsOnInsertionError() {
        let (sut, store) = makeSUT()
        let insertionError = anyNSError()
        expect(sut, toCompleteWithError: insertionError, when: {
            store.completeDeletSuccessfully()
            store.completeInsertion(with: insertionError)
        })

    }
    
    func test_save_succeedsOnSuccessfulCacheInsertion() {
        let (sut, store) = makeSUT()
        expect(sut, toCompleteWithError: nil, when: {
            store.completeDeletSuccessfully()
            store.completeInsertionSuccessfully()
        })
    }
    
    func test_save_doesNotDeliverDeletionErrorAfterSUTInstanceHasBeenDeallocated() {
        var sut: LocalFeedLoader?
        let store = FeedStoreSpy()
        sut = LocalFeedLoader(store: store, currentDate: Date.init)
        
        var receivedResult = [LocalFeedLoader.SaveResult]()
        sut?.save(uniqueImageFeed().models) { result in
            receivedResult.append(result)
        }
        
        sut = nil
        store.completeDeletion(with: anyNSError())
        
        XCTAssertTrue(receivedResult.isEmpty)
    }
    
    func test_save_doesNotDeliverInsertionErrorAfterSUTInstanceHasBeenDeallocated() {
        var sut: LocalFeedLoader?
        let store = FeedStoreSpy()
        sut = LocalFeedLoader(store: store, currentDate: Date.init)
        
        var receivedResult = [LocalFeedLoader.SaveResult]()
        sut?.save(uniqueImageFeed().models) { result in
            receivedResult.append(result)
        }
        
        store.completeDeletSuccessfully()
        sut = nil
        store.completeInsertion(with: anyNSError())
        
        XCTAssertTrue(receivedResult.isEmpty)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(currentDate: @escaping(() -> Date) = Date.init, file: StaticString = #file, line: UInt = #line) -> (sut: LocalFeedLoader, store: FeedStoreSpy) {
        let store = FeedStoreSpy()
        let sut = LocalFeedLoader(store: store, currentDate: currentDate)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    private func expect(_ sut: LocalFeedLoader, toCompleteWithError expectedError: NSError?, when action: () -> Void,  file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for completion")
        
        var receivedError: Error?
        sut.save(uniqueImageFeed().models) { result in
            if case let .failure(error) = result { receivedError = error }
            exp.fulfill()
        }
        action()
        wait(for: [exp], timeout: 0.5)
        
        XCTAssertEqual(receivedError as? NSError, expectedError, file: file, line: line)
    }
    
}
