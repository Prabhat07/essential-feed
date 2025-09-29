//
//  FeedPresenter.swift
//  EssentialFeed
//
//  Created by Prabhat Tiwari on 18/07/25.
//

import Foundation

final public class FeedPresenter {
    
    public static var title: String {
        NSLocalizedString("FEED_VIEW_TITLE",
                    tableName: "Feed",
                    bundle: Bundle(for: FeedPresenter.self),
                    comment: "Feed view title")
    }

 }
