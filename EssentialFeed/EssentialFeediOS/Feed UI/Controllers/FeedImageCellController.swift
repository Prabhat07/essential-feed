//
//  FeedImageCellController.swift
//  EssentialFeediOS
//
//  Created by Prabhat Tiwari on 08/07/25.
//

import UIKit
import EssentialFeed

public protocol FeedImageCellControllerDelegate {
    func didRequestImage()
    func didCancelImageRequest()
}

public final class FeedImageCellController: FeedImageView, ResourceView, ResourceLoadingView, ResourceErrorView {
    
   
    public typealias ResourceViewModel = UIImage
    
    private let model: FeedImageViewModel<UIImage>
    private let delegate: FeedImageCellControllerDelegate
    
    public init(model: FeedImageViewModel<UIImage>, delegate: FeedImageCellControllerDelegate) {
        self.model = model
        self.delegate = delegate
    }
    
    private var cell: FeedImageCell?
    
    func view(in tableView: UITableView) -> FeedImageCell {
        cell = tableView.dequeueReusableCell()
        cell?.locationContainer.isHidden = !model.hasLocation
        cell?.locationLabel.text = model.location
        cell?.descriptionLabel.text = model.description
        cell?.onRetry = delegate.didRequestImage
        delegate.didRequestImage()
        return cell!
    }
    
    func preload() {
        delegate.didRequestImage()
    }
    
    func cancelLoad() {
        releaseCellForReuse()
        delegate.didCancelImageRequest()
    }
    
   public func display(_ viewModel: FeedImageViewModel<UIImage>) {
    
    }
    
    public func display(_ viewModel: UIImage) {
        cell?.feedImageView.setImageAnimated(viewModel)
    }
    
    public func display(_ viewModel: ResourceLoadingViewModel) {
        cell?.feedImageContainer.isShimmering = viewModel.isLoading
    }
    
    public func display(_ viewModel: ResourceErrorViewModel) {
        cell?.feedImageRetryButton.isHidden = viewModel.message == nil
    }
    
    private func releaseCellForReuse() {
        cell = nil
    }
}
