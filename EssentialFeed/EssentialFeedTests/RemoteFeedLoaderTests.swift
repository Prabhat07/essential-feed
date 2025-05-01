//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Prabhat Tiwari on 01/05/25.
//

import XCTest

class RemoteFeedLoader {
    
}

class HTTPCLient {
    var requestedURL: URL?
}

class RemoteFeedLoaderTests: XCTestCase {

    func test_init_doseNotRequestDataFromURL() {
        let client = HTTPCLient()
        _ = RemoteFeedLoader()
        
        XCTAssertNil(client.requestedURL)
    }

}
