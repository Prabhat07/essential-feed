//
//  FeedViewController.swift
//  EssentialFeediOS
//
//  Created by Prabhat Tiwari on 02/07/25.
//

import UIKit
import EssentialFeed

public protocol FeedViewControllerDelegate {
    func didRequestFeedRefresh()
}

final public class FeedViewController: UITableViewController, UITableViewDataSourcePrefetching, ResourceLoadingView, ResourceErrorView {
    
    @IBOutlet private(set) public var errorView: ErrorView?
    
    public var delegate: FeedViewControllerDelegate?
   
    private var loadingControllers = [IndexPath: FeedImageCellController]()
    
    private var tableModel = [FeedImageCellController]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var viewIsApperaing: ((FeedViewController) -> ())?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        viewIsApperaing = { vc in
            vc.viewIsApperaing = nil
            vc.refresh()
        }
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.sizeTableHeaderToFit()
    }
    
    @IBAction func refresh() {
        delegate?.didRequestFeedRefresh()
    }
    
    public func display(_ cellControllers: [FeedImageCellController]) {
        loadingControllers = [:]
        tableModel = cellControllers
    }
    
    public func display(_ viewModle: ResourceLoadingViewModel) {
        refreshControl?.update(isRefreshing: viewModle.isLoading)
    }
    
    public func display(_ viewModle: ResourceErrorViewModel) {
        errorView?.message = viewModle.message
    }
    
    override public func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        
        viewIsApperaing?(self)
    }

    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModel.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellController(forRowAt: indexPath).view(in: tableView)
    }
    
    public override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
       // guard tableModel.count > indexPath.row else { return }
        cellControllerCancelLoad(forRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
           cellController(forRowAt: indexPath).preload()
        }
    }
    
    public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach(cellControllerCancelLoad)
    }
    
    private func cellController(forRowAt indexPath: IndexPath) -> FeedImageCellController {
        let cellController = tableModel[indexPath.row]
        loadingControllers[indexPath] = cellController
        return cellController
    }
    
    private func cellControllerCancelLoad(forRowAt indexPath: IndexPath) {
        loadingControllers[indexPath]?.cancelLoad()
        loadingControllers[indexPath] = nil
    }
    
}
