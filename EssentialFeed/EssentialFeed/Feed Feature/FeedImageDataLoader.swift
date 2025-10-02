//
//  FeedImageDataLoader.swift
//  EssentialFeed
//
//  Created by Prabhat Tiwari on 04/07/25.
//
import Foundation

public protocol FeedImageDataLoader {
    func loadImageData(from url: URL) throws -> Data
}
