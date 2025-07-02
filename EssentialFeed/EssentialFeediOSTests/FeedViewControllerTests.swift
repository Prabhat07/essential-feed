//
//  FeedViewControllerTests.swift
//  EssentialFeediOSTests
//
//  Created by Prabhat Tiwari on 29/06/25.
//

import XCTest
import UIKit
import EssentialFeed

final class FeedViewController: UITableViewController {
    
    private var loader: FeedLoader?
    private var viewIsApperaing: ((FeedViewController) -> ())?
    
    convenience init(loader: FeedLoader) {
        self.init()
        self.loader = loader
    }
    
    override func viewDidLoad() {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(load), for: .valueChanged)
        viewIsApperaing = { vc in
            vc.load()
            vc.viewIsApperaing = nil
        }
    }
    
    override func viewIsAppearing(_ animated: Bool) {
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

final class FeedViewControllerTests: XCTestCase {
    
    func test_loadFeedActions_requestFeedFromLoader() {
        let (sut, loader) = makeSUT()
        XCTAssertEqual(loader.loadCallCount, 0, "Expected no loading requests before view is loaded")
        
        sut.simulateViewAppearance()
        XCTAssertEqual(loader.loadCallCount, 1, "Expected a loading request once view is loaded")
        
        sut.simulateUserInitiatedFeedReload()
        XCTAssertEqual(loader.loadCallCount, 2, "Expected another loading request once user initiates a reload")
        
        sut.simulateUserInitiatedFeedReload()
        XCTAssertEqual(loader.loadCallCount, 3, "Expected yet another loading request once user initiates another reload")
    }
    
    func test_loadingFeedIndicator_isVisibleWhileLoadingFeed() {
        let (sut, loader) = makeSUT()
        
        sut.simulateViewAppearance()
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once view is loaded")
        
        loader.completeFeedLoading(at: 0)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once loading is completed")
        
        sut.simulateUserInitiatedFeedReload()
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once user initiates a reload")
        
        loader.completeFeedLoading(at: 1)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once user initiated loading is completed")
    }

    // MARK: - Helpers
    
    func makeSUT(file: StaticString = #file, line: UInt = #line) -> (FeedViewController, LoaderSpy) {
        let loader = LoaderSpy()
        let sut = FeedViewController(loader: loader)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(loader, file: file, line: line)
        return (sut, loader)
    }
    
    class LoaderSpy: FeedLoader {
        
        var completions = [(FeedLoader.Result) -> Void]()
        var loadCallCount: Int {
            completions.count
        }
        
        func load(completion: @escaping (FeedLoader.Result) -> Void) {
            completions.append(completion)
        }
        
        func completeFeedLoading(at index: Int) {
            completions[index](.success([]))
        }
    }
}

private extension UIRefreshControl {
    func simulatePullToRefresh() {
       allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: .valueChanged)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}

private extension FeedViewController {
    
    func simulateViewAppearance() {
        if !isViewLoaded {
            loadViewIfNeeded()
            replaceWithFakeRefreshControlForiOS17Support()
        }
        beginAppearanceTransition(true, animated: false)
        endAppearanceTransition()
    }
    
    func replaceWithFakeRefreshControlForiOS17Support() {
        let fake = FakeUIRefreshControl()
        
        refreshControl?.allTargets.forEach { target in
            refreshControl?.actions(forTarget: target, forControlEvent: .valueChanged)?.forEach {
                fake.addTarget(target, action: Selector($0), for: .valueChanged)
            }
        }
        refreshControl = fake
    }
    
    func simulateUserInitiatedFeedReload() {
        refreshControl?.simulatePullToRefresh()
    }
    
    var isShowingLoadingIndicator: Bool {
        return refreshControl?.isRefreshing == true
    }
}

class FakeUIRefreshControl: UIRefreshControl {
    var _isRefresing: Bool = false
    
    override var isRefreshing: Bool { _isRefresing }
    
    override func beginRefreshing() {
        _isRefresing = true
    }
    
    override func endRefreshing() {
        _isRefresing = false
    }
    
}
