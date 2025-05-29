//
//  FeedCachePolicy.swift
//  EssentialFeed
//
//  Created by Prabhat Tiwari on 29/05/25.
//

import Foundation

struct FeedCachePolicy {
    private init() {}
    
    private static let calender = Calendar(identifier: .gregorian)
    
    private static var maxCacheAgeInDays: Int {
        return 7
    }
    
    static func validate(_ timestamp: Date, against date: Date) -> Bool {
        guard let maxAge = calender.date(byAdding: .day, value: maxCacheAgeInDays, to: timestamp) else {
            return false
        }
        return date < maxAge
    }
    
}
