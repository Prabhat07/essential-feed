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
       
        let presentationAdapter = FeedLoaderPresentationAdapter(feedLoader: feedLoader)
        let refreshController = FeedRefreshController(delegate: presentationAdapter)
        let feedController = FeedViewController(refreshController: refreshController)
        presentationAdapter.presenter = FeedPresenter(
            loadingView:  WeakRefVirtualProxy(refreshController),
            feedView: FeedViewAdapter(loader: imageLoader, controller: feedController)
        )
        return feedController
    }

}

final class WeakRefVirtualProxy<T: AnyObject> {
    weak var object: T?
    
    init(_ object: T) {
        self.object = object
    }
}

extension WeakRefVirtualProxy: FeedViewLoading where T: FeedViewLoading {
    func display(_ viewModle: FeedLoadingViewModel) {
        object?.display(viewModle)
    }
}

extension WeakRefVirtualProxy: FeedImageLoad where T: FeedImageLoad, T.Image == UIImage {
    func displayImage(_ image: UIImage) {
        object?.displayImage(image)
    }
}

extension WeakRefVirtualProxy: FeedImageLoading where T: FeedImageLoading {
    func display(_ isLoading: Bool) {
        object?.display(isLoading)
    }
}

extension WeakRefVirtualProxy: FeedRetryImageLoad where T: FeedRetryImageLoad {
    func displayRetry(_ shouldRetry: Bool) {
        object?.displayRetry(shouldRetry)
    }
}


final class FeedViewAdapter: FeedView {
    weak var controller: FeedViewController?
    let loader: FeedImageDataLoader
    
    init(loader: FeedImageDataLoader, controller: FeedViewController) {
        self.loader = loader
        self.controller = controller
    }
    
    func display(_ viewModel: FeedViewModel) {
        controller?.tableModel = viewModel.feed.map { model in
            let presenter = FeedImagePresenter<WeakRefVirtualProxy< FeedImageCellController>, UIImage>(model: model, imageLoader: loader, imageTransformer: UIImage.init)
            let controller = FeedImageCellController(presenter: presenter)
            presenter.onImageLoad = WeakRefVirtualProxy(controller)
            presenter.onImageLoadingStateChange = WeakRefVirtualProxy(controller)
            presenter.onShouldRetryImageLoadStateChange = WeakRefVirtualProxy(controller)
            return controller
        }
    }

}

final class FeedLoaderPresentationAdapter: FeedRefreshViewControllerDelegate {
    let feedLoader: FeedLoader
    var presenter: FeedPresenter?
    
    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }
    
    func didRequestFeedRefresh() {
        presenter?.didStartLoadingFeed()
        feedLoader.load { [weak self] result in
            switch result {
            case .success(let feed):
                self?.presenter?.didFinishLoadingFeed(with: feed)
            case .failure(let error):
                self?.presenter?.didFinishLoadingFeed(with: error)
            }
        }
    }
    
}
