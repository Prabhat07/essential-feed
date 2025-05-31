//
//  CodableFeedStoreTests.swift
//  EssentialFeedTests
//
//  Created by Prabhat Tiwari on 31/05/25.
//

import XCTest
import EssentialFeed

class CodableFeedStore {
    
    private struct Cache: Codable {
        let feed: [CodableFeedImage]
        let timestamp: Date
        
        var localFeed: [LocalFeedImage] {
            return feed.map { $0.local }
        }
    }
    
    private struct CodableFeedImage: Codable {
        private let id: UUID
        private let description: String?
        private let location: String?
        private let url: URL
        
        init(_ image: LocalFeedImage) {
            id = image.id
            description = image.description
            location = image.location
            url = image.url
        }
        
        var local: LocalFeedImage {
            LocalFeedImage(id: id, description: description, location: location, url: url)
        }
        
    }
    
    private let storeUrl: URL
    
    init(storeUrl: URL) {
        self.storeUrl = storeUrl
    }
    
    func retrieve(completion: @escaping FeedStore.RetrievalCompletion) {
        guard let data = try? Data(contentsOf: storeUrl) else {
           return completion(.empty)
        }
        let decoder = JSONDecoder()
        let caceh = try! decoder.decode(Cache.self, from: data)
        completion(.found(feed: caceh.localFeed, timestamp: caceh.timestamp))
        
    }
    
    func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping FeedStore.InsertionCompletion) {
        let encoder = JSONEncoder()
        let cache = Cache(feed: feed.map(CodableFeedImage.init), timestamp: timestamp)
        let encoded = try! encoder.encode(cache)
        try! encoded.write(to: storeUrl)
        completion(nil)
    }
}

final class CodableFeedStoreTests: XCTestCase {

    override func setUp() {
        super.setUp()

        setupEmptyStoreState()
    }
    
    override func tearDown() {
        super.tearDown()
        
        undoStoreSideEffects()
    }
    
    func test_retrieve_deliversEmptyOnEmptyCache() {
        let sut = makeSut()
        
        expect(sut, toCompleteWith: .empty)
    }
    
    func test_retrieve_hasNoSideEffectsOnEmptyCache() {
        let sut = makeSut()
        
        let exp = expectation(description: "Wait for completion")
        sut.retrieve { firstResult in
            sut.retrieve { secondResult in
                switch (firstResult, secondResult) {
                case (.empty, .empty):
                    break
                default:
                    XCTFail("Expected retrieving twice from empty cache to deliver same empty result, got \(firstResult) and \(secondResult) instead")
                }
                exp.fulfill()
            }
        }
        
        wait(for: [exp], timeout: 1.0)
    }

    
    func test_retrieveAfterInsertingToEmptyCache_deliversInsertedValues() {
        let sut = makeSut()
        let feed = uniqueImageFeed().local
        let timestamp = Date()
        
        let exp = expectation(description: "Wait for completion")
        sut.insert(feed, timestamp: timestamp) { insertionError in
            XCTAssertNil(insertionError, "Expected feed to be inserted successfully")
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
        
        expect(sut, toCompleteWith: .found(feed: feed, timestamp: timestamp))
    }
    
    func test_retrieve_hasNoSideEffectsOnNonEmptyCache() {
        let sut = makeSut()
        let feed = uniqueImageFeed().local
        let timestamp = Date()
        
        let exp = expectation(description: "Wait for completion")
        sut.insert(feed, timestamp: timestamp) { insertionError in
            XCTAssertNil(insertionError, "Expected feed to be inserted successfully")
            
            sut.retrieve { firstResult in
                sut.retrieve { secondResult in
                    switch (firstResult, secondResult) {
                    case let (.found(firstFeed, firstTimeStamp), .found(secondFeed, secondTimestamp)):
                        XCTAssertEqual(firstFeed, feed)
                        XCTAssertEqual(firstTimeStamp, timestamp)
                        
                        XCTAssertEqual(secondFeed, feed)
                        XCTAssertEqual(secondTimestamp, timestamp)
                        break
                    default:
                        XCTFail("Expected retrieving twice from non empty cache to deliver same found result with feed \(feed) and timestamp \(timestamp), got \(firstResult) and \(secondResult) instead")
                    }
                    
                    exp.fulfill()
                }
                
            }
        }
        
        wait(for: [exp], timeout: 1.0)
    }

    //MARK: - Helpers
    
    func makeSut(file: StaticString = #file, line: UInt = #line) -> CodableFeedStore {
       
        let sut = CodableFeedStore(storeUrl: testSpecificStoreURL())
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func expect(_ sut: CodableFeedStore, toCompleteWith expectedResult: RetrieveCachedFeedResult, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for completion")
        sut.retrieve { retrieveResult in
            switch (retrieveResult, expectedResult){
            case (.empty, .empty):
                break
            case let (.found(receivedFeed, receivedTimestamp), .found(expectedFeed, expectedTimestamp)):
                XCTAssertEqual(receivedFeed, expectedFeed)
                XCTAssertEqual(receivedTimestamp, expectedTimestamp)
                break
            default:
                XCTFail("Expected to retrieve \(expectedResult), got \(retrieveResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    private func setupEmptyStoreState() {
        deleteStoreArtifacts()
    }
    
    private func undoStoreSideEffects() {
        deleteStoreArtifacts()
    }
    
    private func deleteStoreArtifacts() {
        try? FileManager.default.removeItem(at: testSpecificStoreURL())
    }
    
    private func testSpecificStoreURL() -> URL {
        FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent("\(type(of: self)).store")
    }
    
}
