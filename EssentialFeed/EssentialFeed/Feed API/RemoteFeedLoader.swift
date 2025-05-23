//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Prabhat Tiwari on 01/05/25.
//

import Foundation

public class RemoteFeedLoader: FeedLoader {
    let url: URL
    let client: HTTPClient
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    public typealias Result = LoadFeedResult
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load(completion: @escaping (Result) -> Void){
        client.get(from: url) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case let .success(data, response):
                completion(FeedItemsMapper.map(data, response))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
    
}
