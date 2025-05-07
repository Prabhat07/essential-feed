//
//  HTTPClient.swift
//  EssentialFeed
//
//  Created by Prabhat Tiwari on 07/05/25.
//

import Foundation

public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}
