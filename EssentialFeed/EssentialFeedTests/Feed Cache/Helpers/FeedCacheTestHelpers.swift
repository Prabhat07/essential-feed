//
//  FeedCacheTestHelpers.swift
//  EssentialFeedTests
//
//  Created by Prabhat Tiwari on 29/05/25.
//

import Foundation
import EssentialFeed

func uniqueItem() -> FeedImage {
    return FeedImage(id: UUID(), description: "any", location: "any", url: anyURL())
}

func uniqueImageFeed() -> (models:[FeedImage], local: [LocalFeedImage]) {
    let items = [uniqueItem(), uniqueItem()]
    let localItems = items.map {
        LocalFeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.url)
    }
    return (items, localItems)
}

extension Date {
    func minusFeedCacheMaxAge() -> Date {
        adding(days: -feedCacheMaxAgeInDays)
    }
    
    private var feedCacheMaxAgeInDays: Int {
       return 7
    }
    
    private func adding(days: Int) -> Date {
        return Calendar(identifier: .gregorian).date(byAdding: .day, value: days, to: self)!
    }
}

extension Date {
    func adding(seconds: TimeInterval) -> Date {
        return self + seconds
    }
}
