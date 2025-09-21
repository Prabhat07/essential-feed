//
//  FeedLoaderPresentationAdapter.swift
//  EssentialFeediOS
//
//  Created by Prabhat Tiwari on 16/07/25.
//

import EssentialFeed
import EssentialFeediOS
import Combine

final class FeedLoaderPresentationAdapter: FeedViewControllerDelegate {
    let feedLoader: () -> AnyPublisher<[FeedImage], Error>
    var presenter: LoadResourcePresenter<[FeedImage], FeedViewAdapter>?
    private var cancellable: Cancellable?
    
    init(feedLoader:@escaping () -> AnyPublisher<[FeedImage], Error>) {
        self.feedLoader = feedLoader
    }
    
    func didRequestFeedRefresh() {
        presenter?.didStartLoading()
        
        cancellable = feedLoader().sink(
            receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished: break
                    
                case let .failure(error):
                    self?.presenter?.didFinishLoading(with: error)
                }
            }, receiveValue: { [weak self] feed in
                self?.presenter?.didFinishLoading(with: feed)
            })
        
    }
    
}
