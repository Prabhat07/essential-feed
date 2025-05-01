//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Prabhat Tiwari on 01/05/25.
//

import Foundation

public protocol HTTPClient {
    func get(from url: URL)
}

public class RemoteFeedLoader {
    let url: URL
    let client: HTTPClient
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load() {
        client.get(from: url)
    }
    
}
