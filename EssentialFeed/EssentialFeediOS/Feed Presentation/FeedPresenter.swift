//
//  FeedPresenter.swift
//  EssentialFeediOS
//
//  Created by Prabhat Tiwari on 09/07/25.
//

import Foundation
import EssentialFeed

protocol FeedViewLoading: AnyObject {
    func dispay(isLoading: Bool)
}

protocol FeedView {
    func dispay(feed: [FeedImage])
}

final public class FeedPresenter {
        
    private let feedLoader: FeedLoader
    
    weak var loadingView: FeedViewLoading?
    
    var feedView: FeedView?
    
    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }
    
    @objc func loadFeed() {
        loadingView?.dispay(isLoading: true)
        feedLoader.load { [weak self] result in
            if let feed = try? result.get() {
                self?.feedView?.dispay(feed: feed)
            }
            self?.loadingView?.dispay(isLoading: false)
        }
    }
}
