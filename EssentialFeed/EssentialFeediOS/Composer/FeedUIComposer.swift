//
//  FeedUIComposer.swift
//  EssentialFeediOS
//
//  Created by Prabhat Tiwari on 08/07/25.
//

import UIKit
import EssentialFeed

public final class FeedUIComposer {
    private init() {}
    
    public static func feedComposedWith(feedLoader: FeedLoader, imageLoader: FeedImageDataLoader) -> FeedViewController {
        let feedViewModel = FeedViewModel(feedLoader: feedLoader)
        let refreshController = FeedRefreshController(viewModel: feedViewModel)
        let feedController = FeedViewController(refreshController: refreshController)
        feedViewModel.onFeedLoaded = adaptFeedToCellController(forwardingTo: feedController, loader: imageLoader)
        return feedController
    }
    
    static func adaptFeedToCellController(forwardingTo feedController: FeedViewController, loader: FeedImageDataLoader) -> (([FeedImage]) -> Void) {
        return { [weak feedController] feed in
            feedController?.tableModel = feed.map {
                FeedImageCellController(viewModel: FeedImageViewModel(model: $0, imageLoader: loader, imageTransformer: UIImage.init))
            }
        }
    }
}
