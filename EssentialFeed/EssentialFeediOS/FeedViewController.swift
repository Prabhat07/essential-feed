//
//  FeedViewController.swift
//  EssentialFeediOS
//
//  Created by Prabhat Tiwari on 02/07/25.
//

import UIKit
import EssentialFeed

final public class FeedViewController: UITableViewController {
    
    private var loader: FeedLoader?
    private var viewIsApperaing: ((FeedViewController) -> ())?
    
    public convenience init(loader: FeedLoader) {
        self.init()
        self.loader = loader
    }
    
    public override func viewDidLoad() {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(load), for: .valueChanged)
        viewIsApperaing = { vc in
            vc.load()
            vc.viewIsApperaing = nil
        }
    }
    
    public override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        viewIsApperaing?(self)
    }
    
    @objc func load() {
        refreshControl?.beginRefreshing()
        loader?.load { [weak self] _ in
            self?.refreshControl?.endRefreshing()
        }
    }
    
}
