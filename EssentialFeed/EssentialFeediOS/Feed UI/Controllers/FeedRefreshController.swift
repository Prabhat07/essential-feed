//
//  FeedRefreshController.swift
//  EssentialFeediOS
//
//  Created by Prabhat Tiwari on 07/07/25.
//

import UIKit

final public class FeedRefreshController: NSObject, FeedViewLoading {
    public lazy var view: UIRefreshControl = loadView()
    
    private let feedPresenter: FeedPresenter
    
    init(feedPresenter: FeedPresenter) {
        self.feedPresenter = feedPresenter
    }
    
    @objc func refresh() {
        feedPresenter.loadFeed()
    }
    
    func dispay(isLoading: Bool) {
        if isLoading {
            view.beginRefreshing()
        } else {
            view.endRefreshing()
        }
    }
    
    private func loadView() -> UIRefreshControl {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }
}
