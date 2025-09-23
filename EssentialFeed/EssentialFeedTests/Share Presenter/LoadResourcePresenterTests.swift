//
//  LoadResourcePresenterTests.swift
//  EssentialFeedTests
//
//  Created by Prabhat Tiwari on 20/09/25.
//

import XCTest
import EssentialFeed

final class LoadResourcePresenterTests: XCTestCase {
    
    func test_init_noMessageSent() {
        let (_, view) = makeSUT()
        
        XCTAssert(view.messages.isEmpty)
    }
    
    func test_didStartLoading_displaysNoErrorMessageAndStartsLoading() {
        let (sut, view) = makeSUT()
        
        sut.didStartLoading()
        
        XCTAssertEqual(view.messages, [.display(errorMessage: .none), .display(isLoading: true)])
    }
    
    func test_didFinishLoadingResource_displaysResourceAndStopsLoading() {
        let (sut, view) = makeSUT { resource in
            resource + " view model"
        }
        
        let resource = "resource"
        sut.didFinishLoading(with: resource)
        
        XCTAssertEqual(view.messages, [.display(resourceViewModel: "resource view model"), .display(isLoading: false)])
    }
    
    func test_didFinishLoadingWithMapperError_displaysLocalizedErrorMessageAndStopsLoading() {
        let (sut, view) = makeSUT { _ in
            throw anyNSError()
        }
        
        sut.didFinishLoading(with: "resource")
        
        XCTAssertEqual(view.messages, [.display(errorMessage: localized("GENERIC_CONNECTION_ERROR")), .display(isLoading: false)])
    }
    
    func test_didFinishLoadingWithError_displaysLocalizedErrorMessageAndStopsLoading() {
        let (sut, view) = makeSUT()
        
        sut.didFinishLoading(with: anyNSError())
        
        XCTAssertEqual(view.messages, [.display(errorMessage: localized("GENERIC_CONNECTION_ERROR")), .display(isLoading: false)])
    }
    
    // MARK : - Helpers
    
    typealias SUT = LoadResourcePresenter<String, ViewSpy>
    
    private func makeSUT(
        mapper: @escaping SUT.Mapper = { _ in "any" },
        file: StaticString = #filePath,
        line: UInt = #line) -> (SUT, ViewSpy) {
        let view = ViewSpy()
        let sut = LoadResourcePresenter(resourceView: view, loadingView: view, errorView: view, mapper: mapper)
        trackForMemoryLeaks(view)
        trackForMemoryLeaks(sut)
        return (sut, view)
    }
    
    private  func localized(_ key: String, file: StaticString = #file, line: UInt = #line) -> String {
        let table = "Shared"
        let bundle = Bundle(for: SUT.self)
        let value = bundle.localizedString(forKey: key, value: nil, table: table)
        if value == key {
            XCTFail("Missing localized string for key: \(key) in table: \(table)", file: file, line: line)
        }
        return value
    }
    
    class ViewSpy: ResourceView, ResourceLoadingView, ResourceErrorView {
        
        typealias ResourceViewModel = String
        
        enum Message: Hashable {
            case display(errorMessage: String?)
            case display(isLoading: Bool)
            case display(resourceViewModel: String)
        }
        
        var messages = Set<Message>()
        
        func display(_ viewModel: ResourceErrorViewModel) {
            messages.insert(.display(errorMessage: viewModel.message))
        }
        
        func display(_ viewModel: ResourceLoadingViewModel) {
            messages.insert(.display(isLoading: viewModel.isLoading))
        }
        
        func display(_ viewModel: String) {
            messages.insert(.display(resourceViewModel: viewModel))
        }
        
    }

}
