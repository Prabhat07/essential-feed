//
//  FeedPresenterTests.swift
//  EssentialFeedTests
//
//  Created by Prabhat Tiwari on 17/07/25.
//

import XCTest

class FeedPresenter {
    init(view: Any) {
        
    }
}

final class FeedPresenterTests: XCTestCase {
    
    func test_init_noMessageSent() {
        let view = ViewSpy()
        
        _ = FeedPresenter(view: view)
        
        XCTAssert(view.messages.isEmpty)
    }
    
    class ViewSpy {
        var messages = [Any]()
    }
}
