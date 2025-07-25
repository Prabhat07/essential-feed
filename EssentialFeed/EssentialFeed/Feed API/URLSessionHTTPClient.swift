//
//  URLSessionHTTPClient.swift
//  EssentialFeed
//
//  Created by Prabhat Tiwari on 12/05/25.
//

import Foundation

public final class URLSessionHTTPClient: HTTPClient {
    private let session: URLSession
    
    public init(session: URLSession) {
        self.session = session
    }
    
    private struct URLSessionTaskWrapper: HTTPClientTask {
        let wrraped: URLSessionDataTask
        
        func cancel() {
            wrraped.cancel()
        }
    }
    
    struct UnexpectedValuesRepresentation: Error {}

    public func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        let task = session.dataTask(with: url) { data, response, error in
            completion(Result {
                if let error = error {
                    throw error
                } else if let data = data, let response = response as? HTTPURLResponse {
                    return (data, response)
                } else {
                    throw UnexpectedValuesRepresentation()
                }
            })
        }
       task.resume()
       return URLSessionTaskWrapper(wrraped: task)
    }
}
