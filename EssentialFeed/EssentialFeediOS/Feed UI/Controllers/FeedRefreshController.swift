//
//  FeedRefreshController.swift
//  EssentialFeediOS
//
//  Created by Prabhat Tiwari on 07/07/25.
//

import UIKit

protocol FeedRefreshViewControllerDelegate {
    func didRequestFeedRefresh()
}

final public class FeedRefreshController: NSObject, FeedViewLoading {
    @IBOutlet public var view: UIRefreshControl?
    
   var delegate: FeedRefreshViewControllerDelegate?
    
    @IBAction func refresh() {
        delegate?.didRequestFeedRefresh()
    }
    
    func display(_ viewModle: FeedLoadingViewModel) {
        if viewModle.isLoading {
            view?.beginRefreshing()
        } else {
            view?.endRefreshing()
        }
    }

}
