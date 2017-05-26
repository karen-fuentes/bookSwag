//
//  Book.swift
//  bookSwag
//
//  Created by Karen Fuentes on 5/20/17.
//  Copyright © 2017 Karen Fuentes. All rights reserved.
//

import Foundation

enum ErrorCases: Error {
    case parsingError, JsonObjectError, singlebookError
}

struct Book {
    let author: String?
    let categories: String?
    let id : Int
    let lastCheckedOut: String?
    let lastCheckedOutBy: String?
    let publisher: String?
    var title: String?
    let url: String
    
    // MARK: - Parsing
    
    static func createBookObjects(data: Data) -> [Book]? {
        var bookArr = [Book]()
        let defaultValue: String?  = " "
        
        do {
            let jsonData = try JSONSerialization.jsonObject(with: data , options: [])
            guard let JsonArr = jsonData as? [[String:AnyObject]] else {
                throw ErrorCases.JsonObjectError
            }
            
            for bookDict in JsonArr {
                guard let author = bookDict["author"] as? String ?? defaultValue,
                    let categories = bookDict["categories"] as? String ?? defaultValue,
                    let id = bookDict["id"] as? Int,
                    let title = bookDict["title"] as? String ?? defaultValue,
                    let publisher = bookDict["publisher"] as? String ?? defaultValue,
                    let url = bookDict["url"] as? String else {
                        throw ErrorCases.parsingError
                }
                
                let lastCheckedOut = bookDict["lastCheckedOut"] as? String
                let lastCheckedOutBy = bookDict["lastCheckedOutBy"] as? String
                
                let parsedBook = Book(author:author, categories:categories, id:id, lastCheckedOut:lastCheckedOut, lastCheckedOutBy:lastCheckedOutBy, publisher: publisher, title:title, url:url)
                
                bookArr.append(parsedBook)
            }
        }
            
        catch {
            print("Error encountered with \(error)")
        }
        
        return bookArr
    }
    
    // MARK: - Get One Book Method
    
    static func getOneBook(from data: Data) -> Book? {
        var bookToReturn: Book?
        
        do {
            let jsonData: Any = try JSONSerialization.jsonObject(with: data, options: [])
            
            guard let response = jsonData as? [String : Any] else {
                throw ErrorCases.parsingError
            }
            
            if let book = try Book(dict: response) {
                bookToReturn = book
            }
        }
            
        catch {
            print("Error encountered with \(error)")
        }
        
        return bookToReturn
    }
    
    // MARK: - Date Functions
    
    static func todaysDate() -> String {
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss zzz"
        
        return dateFormatter.string(from: today)
    }
    
    static func dateStringToReadableString(_ dateString: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss zzz"
        let date = dateFormatter.date(from: dateString + " GMT")
        
        let newFormatter = DateFormatter()
        newFormatter.dateFormat = "MMM d, yyyy   h:mma"
        
        if let date = date {
            return newFormatter.string(from: date)
        } else {
            return "Date Error"
        }
    }
}

/* What data looks like ⬇️
 
 "author": "Jason Morris",
 "categories": "interface, ui, android",
 "id": 1,
 "lastCheckedOut": null,
 "lastCheckedOutBy": null,
 "title": "User Interface Development: Beginner's Guide",
 "url": "/books/1/"
 
 */

