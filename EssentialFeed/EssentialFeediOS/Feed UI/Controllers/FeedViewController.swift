//
//  FeedViewController.swift
//  EssentialFeediOS
//
//  Created by Prabhat Tiwari on 02/07/25.
//

import UIKit

final public class FeedViewController: UITableViewController, UITableViewDataSourcePrefetching {
    
    public var refreshController: FeedRefreshController?
   
    var tableModel = [FeedImageCellController]() {
        didSet { tableView.reloadData() }
    }
    
    private var viewIsApperaing: ((FeedViewController) -> ())?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = refreshController?.view
        
        viewIsApperaing = { vc in
            vc.viewIsApperaing = nil
            vc.refreshController?.refresh()
        }
        tableView.prefetchDataSource = self
    }
    
    override public func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        
        viewIsApperaing?(self)
    }

    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModel.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellController(forRowAt: indexPath).view()
    }
    
    public override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
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
        tableModel[indexPath.row]
    }
    
    private func cellControllerCancelLoad(forRowAt indexPath: IndexPath) {
        cellController(forRowAt: indexPath).cancelLoad()
    }
    
}
