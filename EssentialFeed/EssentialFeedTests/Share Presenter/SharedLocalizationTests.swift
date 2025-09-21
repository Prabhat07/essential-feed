//
//  SharedLocalizationTestHelpers.swift
//  EssentialFeedTests
//
//  Created by Prabhat Tiwari on 21/09/25.
//

import XCTest
import EssentialFeed

final class SharedLocalizationTests: XCTestCase {

    private class DummyView: ResourceView {
        func display(_ viewModel: Any) {}
    }
    
    func test_localizedStrings_haveKeysAndValuesForAllSupportedLocalizations() {
        let table = "Shared"
        let bundle = Bundle(for: LoadResourcePresenter<String, DummyView>.self)
        assertLocalizedKeyAndValuesExist(in: bundle, table)
    }
    
}

