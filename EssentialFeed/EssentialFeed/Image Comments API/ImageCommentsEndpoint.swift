//
//  ImageCommentsEndpoint.swift
//  EssentialFeed
//
//  Created by Prabhat Tiwari on 28/09/25.
//

import Foundation

public enum ImageCommentsEndpoint {
    case get(UUID)
    
    public func url(baseURL: URL) -> URL {
        switch self {
        case let .get(id):
            return baseURL.appendingPathComponent("/v1/image/\(id)/comments")
        }
    }
}
