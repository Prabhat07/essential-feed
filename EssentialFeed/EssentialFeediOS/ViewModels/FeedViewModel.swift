//
//  FeedViewModel.swift
//  EssentialFeediOS
//
//  Created by Prabhat Tiwari on 08/07/25.
//

import Foundation
import EssentialFeed

final public class FeedViewModel {
    
    typealias Observer<T> = (T) -> Void
    
    private let feedLoader: FeedLoader
    
    var onChange: ((FeedViewModel) -> Void)?
    
    private(set) var isLoading: Bool = false {
        didSet {
            onChange?(self)
        }
    }
    
    var onLoadingStateChange: Observer<Bool>?
    
    var onFeedLoaded: Observer<[FeedImage]>?
    
    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }
    
    @objc func loadFeed() {
        onLoadingStateChange?(true)
        feedLoader.load { [weak self] result in
            if let feed = try? result.get() {
                self?.onFeedLoaded?(feed)
            }
            self?.onLoadingStateChange?(false)
        }
    }
}
