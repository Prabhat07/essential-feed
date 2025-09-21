//
//  LoadResourcePresenter.swift
//  EssentialFeed
//
//  Created by Prabhat Tiwari on 20/09/25.
//

import Foundation

public protocol ResourceView {
    associatedtype ResourceViewModel
    func display(_ viewModel: ResourceViewModel)
}

final public class LoadResourcePresenter<Resource, View: ResourceView> {
    public typealias Mapper = (Resource) -> View.ResourceViewModel
    
    private let errorView: FeedErrorView
    private let loadingView: ResourceLoadingView
    private let resoureView: View
    private let mapper: Mapper
    
    public static var loadError: String {
        NSLocalizedString("GENERIC_CONNECTION_ERROR", tableName: "Shared", bundle: Bundle(for: Self.self), comment: "Feed error view message")
        
    }
    
    public init(resourceView: View, loadingView: ResourceLoadingView, errorView: FeedErrorView, mapper: @escaping Mapper) {
        self.resoureView = resourceView
        self.loadingView = loadingView
        self.errorView = errorView
        self.mapper = mapper
    }
    
    public func didStartLoading() {
        errorView.display(.noError)
        loadingView.display(ResourceLoadingViewModel(isLoading: true))
    }
    
    public func didFinishLoading(with resource: Resource) {
        resoureView.display(mapper(resource))
        loadingView.display(ResourceLoadingViewModel(isLoading: false))
    }
    
    public func didFinishLoadingFeed(with error: Error) {
        errorView.display(.error(message: Self.loadError))
        loadingView.display(ResourceLoadingViewModel(isLoading: false))
    }
}
