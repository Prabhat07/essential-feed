//
//  FeedLoaderWithFallbackComposite.swift
//  EssentialApp
//
//  Created by Prabhat Tiwari on 27/07/25.
//

import Foundation
import EssentialFeed

public class FeedLoaderWithFallbackComposite: FeedLoader {
    
    private let primary: FeedLoader
    private let fallback: FeedLoader
    
   public init(primary: FeedLoader, fallback: FeedLoader) {
        self.primary = primary
        self.fallback = fallback
    }
    
    public func load(completion: @escaping (FeedLoader.Result) -> Void) {
        primary.load { [weak self] result in
            switch result {
            case let .success(feed):
                completion(.success(feed))
            case .failure:
                self?.fallback.load(completion: completion)
            }
        }
    }
    
}
