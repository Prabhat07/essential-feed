//
//  FeedImagePresenter.swift
//  EssentialFeediOS
//
//  Created by Prabhat Tiwari on 11/07/25.
//

import Foundation
import EssentialFeed

protocol FeedRetryImageLoad {
    func displayRetry(_ shouldRetry: Bool)
}

protocol FeedImageLoading {
    func display(_ isLoading: Bool)
}

protocol FeedImageLoad {
    associatedtype Image
    func displayImage(_ image: Image)
}

final class FeedImagePresenter<View:FeedImageLoad, Image> where View.Image == Image {
    
    private var task: FeedImageDataLoaderTask?
    private let model: FeedImage
    private let imageLoader: FeedImageDataLoader
    private let imageTransformer: (Data) -> Image?
    
    init(model: FeedImage, imageLoader: FeedImageDataLoader, imageTransformer: @escaping (Data) -> Image?) {
        self.model = model
        self.imageLoader = imageLoader
        self.imageTransformer = imageTransformer
    }
    
    var description: String? {
        return model.description
    }
    
    var location: String?  {
        return model.location
    }
    
    var hasLocation: Bool {
        return location != nil
    }
    
    var onImageLoad: View?
    var onImageLoadingStateChange: FeedImageLoading?
    var onShouldRetryImageLoadStateChange: FeedRetryImageLoad?
    
    
    func loadImageData() {
        onImageLoadingStateChange?.display(true)
        onShouldRetryImageLoadStateChange?.displayRetry(false)
        task = self.imageLoader.loadImageData(from: model.url) { [weak self] result in
            self?.handle(result)
        }
    }
    
    private func handle(_ result: FeedImageDataLoader.Result) {
        if let image = (try? result.get()).flatMap(imageTransformer) {
            onImageLoad?.displayImage(image)
        } else {
            onShouldRetryImageLoadStateChange?.displayRetry(true)
        }
        onImageLoadingStateChange?.display(false)
    }
    
    func cancelImageLoad() {
        task?.cancel()
        task = nil
    }
    
}
