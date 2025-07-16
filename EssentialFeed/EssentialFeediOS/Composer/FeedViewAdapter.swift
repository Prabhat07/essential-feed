//
//  FeedViewAdapter.swift
//  EssentialFeediOS
//
//  Created by Prabhat Tiwari on 16/07/25.
//

import UIKit
import EssentialFeed

final class FeedViewAdapter: FeedView {
    weak var controller: FeedViewController?
    let loader: FeedImageDataLoader
    
    init(loader: FeedImageDataLoader, controller: FeedViewController) {
        self.loader = loader
        self.controller = controller
    }
    
    func display(_ viewModel: FeedViewModel) {
        controller?.tableModel = viewModel.feed.map { model in
            let adapter = FeedImageDataLoaderPresentationAdapter<WeakRefVirtualProxy<FeedImageCellController>, UIImage>(model: model, imageLoader: loader)
            let view = FeedImageCellController(delegate: adapter)
            
            adapter.presenter = FeedImagePresenter(view: WeakRefVirtualProxy(view), imageTransformer: UIImage.init)
            
            return view
        }
    }

}
