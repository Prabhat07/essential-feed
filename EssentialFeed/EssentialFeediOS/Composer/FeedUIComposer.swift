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
       
        let presentationAdapter = FeedLoaderPresentationAdapter(feedLoader: MainQueueDispatchDecorator(decoratee: feedLoader))
        let feedController = makeFeedViewController(
            delegate: presentationAdapter, title: FeedPresenter.title)
        
        presentationAdapter.presenter = FeedPresenter(
            feedView: FeedViewAdapter(loader: MainQueueDispatchDecorator(decoratee:imageLoader), controller: feedController),
            loadingView: WeakRefVirtualProxy(feedController),
            errorView: WeakRefVirtualProxy(feedController)
        )
        return feedController
    }
    
    private static func makeFeedViewController(delegate: FeedViewControllerDelegate, title: String) -> FeedViewController {
        let bundle = Bundle(for: FeedViewController.self)
        let storyBoard = UIStoryboard(name: "Feed", bundle: bundle)
        let feedController = storyBoard.instantiateInitialViewController() as! FeedViewController
        feedController.title = FeedPresenter.title
        feedController.delegate = delegate
        return feedController
    }

}
