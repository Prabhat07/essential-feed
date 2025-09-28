//
//  SharedTestHelpers.swift
//  EssentialAppTests
//
//  Created by Prabhat Tiwari on 31/07/25.
//

import Foundation
import EssentialFeed

func anyData() -> Data {
    return Data("any data".utf8)
}

func anyURL() -> URL {
    return URL(string: "http://a-url.com")!
}

func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
}

func uniqueFeed() -> [FeedImage] {
    return [FeedImage(id: UUID(), description: "any", location: "any", url: anyURL())]
}

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

