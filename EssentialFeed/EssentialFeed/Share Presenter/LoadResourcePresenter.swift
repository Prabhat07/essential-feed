//
//  LoadResourcePresenter.swift
//  EssentialFeed
//
//  Created by Prabhat Tiwari on 20/09/25.
//

import Foundation

public protocol ResourceView {
    func display(_ viewModel: String)
}

final public class LoadResourcePresenter {
    public typealias Mapper = (String) -> String
    
    private let errorView: FeedErrorView
    private let loadingView: FeedLoadingView
    private let resoureView: ResourceView
    private let mapper: Mapper
    
    private var feedLoadError: String {
        NSLocalizedString("FEED_VIEW_CONNECTION_ERROR", tableName: "Feed", bundle: Bundle(for: FeedPresenter.self), comment: "Feed error view message")
        
    }
    
    public init(resourceView: ResourceView, loadingView: FeedLoadingView, errorView: FeedErrorView, mapper: @escaping Mapper) {
        self.resoureView = resourceView
        self.loadingView = loadingView
        self.errorView = errorView
        self.mapper = mapper
    }
    
    public func didStartLoading() {
        errorView.display(.noError)
        loadingView.display(FeedLoadingViewModel(isLoading: true))
    }
    
    public func didFinishLoading(with resource: String) {
        resoureView.display(mapper(resource))
        loadingView.display(FeedLoadingViewModel(isLoading: false))
    }
    
    public func didFinishLoadingFeed(with error: Error) {
        errorView.display(.error(message: feedLoadError))
        loadingView.display(FeedLoadingViewModel(isLoading: false))
    }
}
