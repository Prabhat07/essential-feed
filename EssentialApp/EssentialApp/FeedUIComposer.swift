//
//  FeedUIComposer.swift
//  EssentialFeediOS
//
//  Created by Prabhat Tiwari on 08/07/25.
//

import UIKit
import EssentialFeed
import EssentialFeediOS
import Combine

public final class FeedUIComposer {
    private init() {}
    
    private typealias FeedPresentationAdapter = LoadResourcePresentationAdapter<Paginated<FeedImage>, FeedViewAdapter>
    
    public static func feedComposedWith(
        feedLoader: @escaping () -> AnyPublisher<Paginated<FeedImage>,
        Error>, imageLoader: @escaping (URL) -> FeedImageDataLoader.Publisher,
        selection: @escaping (FeedImage) -> Void = { _ in }
    ) -> ListViewController {
        
        let presentationAdapter = FeedPresentationAdapter(loader: feedLoader)
        let feedController = makeFeedViewController(title: FeedPresenter.title)
        feedController.onRefresh = presentationAdapter.loadResource
        
        presentationAdapter.presenter = LoadResourcePresenter<Paginated<FeedImage>, FeedViewAdapter>(
            resourceView: FeedViewAdapter(controller: feedController, loader: imageLoader, selection: selection),
            loadingView: WeakRefVirtualProxy(feedController),
            errorView: WeakRefVirtualProxy(feedController),
            mapper: { $0 })
        return feedController
    }
    
    private static func makeFeedViewController(title: String) -> ListViewController {
        let bundle = Bundle(for: ListViewController.self)
        let storyBoard = UIStoryboard(name: "Feed", bundle: bundle)
        let feedController = storyBoard.instantiateInitialViewController() as! ListViewController
        feedController.title = FeedPresenter.title
        return feedController
    }

}
