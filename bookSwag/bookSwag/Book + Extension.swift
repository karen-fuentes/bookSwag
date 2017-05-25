//
//  Book + Extension.swift
//  bookSwag
//
//  Created by Karen Fuentes on 5/25/17.
//  Copyright © 2017 Karen Fuentes. All rights reserved.
//

import Foundation
extension Book {
    
    init?(dict: [String: Any]) throws {
        self.init(
            author: dict["author"] as? String,
            categories: dict["categories"] as? String,
            id: dict["id"] as! Int,
            lastCheckedOut: dict["lastCheckedOut"] as? String,
            lastCheckedOutBy: dict["lastCheckedOutBy"] as? String,
            publisher: dict["publisher"] as? String,
            title: dict["title"] as? String,
            url: dict["url"] as! String
        )
    }
}
