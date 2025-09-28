//
//  FeedEndpoint.swift
//  EssentialFeed
//
//  Created by Prabhat Tiwari on 28/09/25.
//

import Foundation

public enum FeedEndpoint {
    case get

    public func url(baseURL: URL) -> URL {
        switch self {
        case .get:
            return baseURL.appendingPathComponent("/v1/feed")
        }
    }
}
