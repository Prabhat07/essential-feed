//
//  FeedViewControllerTests+Localization.swift
//  EssentialFeediOSTests
//
//  Created by Prabhat Tiwari on 16/07/25.
//

import Foundation
import XCTest
import EssentialFeed

extension FeedUIIntegrationTests {
    
    private struct DummyView: ResourceView {
        func display(_ viewModel: Any) {}
    }
    
    var loadingError: String {
        LoadResourcePresenter<String, DummyView>.loadError
    }
    
    var title: String {
        FeedPresenter.title
    }
    
    var commentsTitle: String {
        ImageCommentsPresenter.title
    }
    
}
