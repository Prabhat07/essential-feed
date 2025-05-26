//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Prabhat Tiwari on 01/05/25.
//

import XCTest
import EssentialFeed

class LoadFeedFromRemoteUseCaseTests: XCTestCase {

    func test_init_doseNotRequestDataFromURL() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_requestsDataFromURL() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadTwice_requestDataFromURLTwice() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load { _ in }
        sut.load { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        
        expect(sut, completeWith: failure(.connectivity), when: {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: clientError)
        })
        
    }
    
    func test_load_deliversErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()
        
        let samples = [199, 201, 300, 400, 500]
            
        samples.enumerated().forEach { index, code in
            expect(sut, completeWith: failure(.invalidData), when: {
                let data = makeItemJSON([])
                client.complete(withStatusCode: code, data: data, at: index)
            })
        }
        
    }
    
    func test_load_deliversErrorOnInvalidJson() {
        let (sut, client) = makeSUT()
        
        expect(sut, completeWith: failure(.invalidData), when: {
            let invalidJson = Data("Invlaid JSON".utf8)
            client.complete(withStatusCode: 200, data: invalidJson)
        })
        
    }
    
    func test_load_deliverNoItemsOn200HTTPResponseWithEmptyJSONList() {
        let (sut, client) = makeSUT()
        
        expect(sut, completeWith: .success([]), when: {
            let data = makeItemJSON([])
            client.complete(withStatusCode: 200, data: data)
        })
    
    }
    
    func test_load_deliverItemsOn200HTTPResponseWithJSONList() {
        let (sut, client) = makeSUT()
        
        let item1 = makeItem(id: UUID(),
                             imageURL: URL(string:"https://a-url.com")!)
       
        
        let item2 = makeItem(id: UUID(),
                             description: "a description",
                             location: "a location",
                             imageURL: URL(string:"https://another-url.com")!)
        
        let items = [item1.modle, item2.modle]
        
        expect(sut, completeWith: .success(items), when: {
            let data = makeItemJSON([item1.json, item2.json])
            client.complete(withStatusCode: 200, data: data)
        })
    
    }
    
    func test_sut_doseNotDeliverResultAfterInstanceHasBeenDeallocated() {
        let url = URL(string: "https://any-url.com")!
        let client = HTTPClientSpy()
        var sut: RemoteFeedLoader? = RemoteFeedLoader(url: url, client: client)
        
        var capturedResult = [RemoteFeedLoader.Result]()
        sut?.load { capturedResult.append($0) }
        
        sut = nil
        client.complete(withStatusCode: 200, data: makeItemJSON([]))
        
        XCTAssertTrue(capturedResult.isEmpty)
    }
    
    //MARK: - Helpers
    
    private func makeSUT(url: URL = URL(string: "https://a-url.com")!, file: StaticString = #filePath, line: UInt = #line) -> (RemoteFeedLoader, HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        trackForMemoryLeaks(client)
        trackForMemoryLeaks(sut)
        return (sut, client)
    }
    
    private func failure(_ error: RemoteFeedLoader.Error) -> RemoteFeedLoader.Result {
        .failure(error)
    }
    
    private func makeItem(id: UUID, description: String? = nil, location: String? = nil, imageURL: URL) -> (modle: FeedImage, json: [String: Any]) {
        let item = FeedImage(id: id,
                            description: description,
                            location: location,
                            url: imageURL)
        let json = ["id": id.uuidString,
                    "description": description,
                    "location": location,
                    "image": imageURL.absoluteString]
            .reduce(into: [String: Any]()) { acc, e in
                if let value = e.value { acc[e.key] = value }
            }
        return (item, json)
    }
    
    private func makeItemJSON(_ items:[[String: Any]]) -> Data {
        let json = ["items": items]
        return try! JSONSerialization.data(withJSONObject: json)
    }
    
    private func expect(_ sut: RemoteFeedLoader, completeWith expectedResult: RemoteFeedLoader.Result, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "wait for load completion")
        
        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedItems), .success(expectedItems)):
                XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)
            case let (.failure(receivedError as RemoteFeedLoader.Error), .failure(expectedError as RemoteFeedLoader.Error)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
            default:
              XCTFail("Expected result \(expectedResult) got \(receivedResult) instead", file: file, line: line)
            }
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1.0)
        
    }
    
    
    private class HTTPClientSpy: HTTPClient {
        var messages = [(url: URL, completion: (HTTPClientResult) -> Void)]()
        var requestedURLs: [URL] {
            messages.map { $0.url }
        }
        
        func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
            messages.append((url, completion))
        }
        
        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }
        
        func complete(withStatusCode code: Int, data: Data, at index: Int = 0) {
            let response = HTTPURLResponse(
                url: requestedURLs[index],
                statusCode: code,
                httpVersion: nil,
                headerFields: nil)!
            messages[index].completion(.success(data, response))
        }
        
    }

}
