//
//  FeedViewControllerTests.swift
//  EssentialFeediOSTests
//
//  Created by Prabhat Tiwari on 29/06/25.
//

import XCTest

final class FeedViewController {
    
    init(loader: FeedViewControllerTests.LoaderSpy) {
        
    }
    
}

final class FeedViewControllerTests: XCTestCase {

    func test_init_doseNotLoad() {
        let loader = LoaderSpy()
        _ = FeedViewController(loader: loader)
        XCTAssertEqual(loader.loadCallCount, 0)
    }
    
    // MARK: - Helpers
    
    class LoaderSpy {
        private(set) var loadCallCount = 0
    }
}
