//
//  FeedLocalizationTests.swift
//  EssentialFeediOSTests
//
//  Created by Prabhat Tiwari on 16/07/25.
//

import XCTest
import EssentialFeed

final class FeedLocalizationTests: XCTestCase {

    func test_localizedStrings_haveKeysAndValuesForAllSupportedLocalizations() {
        let table = "Feed"
        let bundle = Bundle(for: FeedPresenter.self)
        assertLocalizedKeyAndValuesExist(in: bundle, table)
    }

}

