//
//  FeedImagePresenter.swift
//  EssentialFeed
//
//  Created by Prabhat Tiwari on 20/07/25.
//

import Foundation


public class FeedImagePresenter {
    
    public static func map(_ image: FeedImage) -> FeedImageViewModel {
        FeedImageViewModel(
            description: image.description,
            location: image.location)
    }
}
