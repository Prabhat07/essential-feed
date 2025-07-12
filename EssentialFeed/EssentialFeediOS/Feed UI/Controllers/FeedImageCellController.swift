//
//  FeedImageCellController.swift
//  EssentialFeediOS
//
//  Created by Prabhat Tiwari on 08/07/25.
//

import UIKit

final class FeedImageCellController: FeedImageLoad, FeedImageLoading, FeedRetryImageLoad {
    private let presenter: FeedImagePresenter<WeakRefVirtualProxy<FeedImageCellController>, UIImage>
    
    init(presenter: FeedImagePresenter<WeakRefVirtualProxy<FeedImageCellController>, UIImage>) {
        self.presenter = presenter
    }
    
    lazy var cell = FeedImageCell()
    
    func view() -> FeedImageCell {
        presenter.loadImageData()
        return cell
    }
    
    func preload() {
        presenter.loadImageData()
    }
    
    func cancelLoad() {
        presenter.cancelImageLoad()
    }
    
    func display(_ isLoading: Bool) {
        cell.feedImageContainer.isShimmering = isLoading
    }
    
    // Error
    func displayRetry(_ shouldRetry: Bool) {
        cell.feedImageRetryButton.isHidden = !shouldRetry
        updateCell()
    }
    
    // Success
    func displayImage(_ image: UIImage) {
        cell.feedImageView.image = image
        updateCell()
    }
    
    func updateCell() {
        cell.locationContainer.isHidden = !presenter.hasLocation
        cell.locationLabel.text = presenter.location
        cell.descriptionLabel.text = presenter.description
        cell.onRetry = presenter.loadImageData
    }
}
