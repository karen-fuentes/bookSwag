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
    let catrgoires: String?
    let id : Int
    let lastCheckedOut: String?
    let lastCheckedOutBy: String?
    let publisher: String?
    var title: String?
    let url: String
    
   static func createBookObjects(data: Data) -> [Book]? {
        var bookArr = [Book]()
        let defaultValue: String?  = " "
        
        do {
         let jsonData = try JSONSerialization.jsonObject(with: data , options: [])
            guard let JsonArr = jsonData as? [[String:AnyObject]] else {
             //PUT ERROR CHECK HERE
               throw ErrorCases.JsonObjectError
            }
            
            for bookDict in JsonArr {
                guard let author = bookDict["author"] as? String ?? defaultValue,
                      let categories = bookDict["categories"] as? String ?? defaultValue,
                      let id = bookDict["id"] as? Int,
                      let lastCheckedOut = bookDict["lastCheckedOut"] as? String ?? defaultValue,
                      let lastCheckedOutBy = bookDict["lastCheckedOutBy"] as? String ?? defaultValue,
                      let title = bookDict["title"] as? String ?? defaultValue,
                      let publisher = bookDict["publisher"] as? String ?? defaultValue,
                      let url = bookDict["url"] as? String else {
                        //PUT ERROR CHECK HERE
                        throw ErrorCases.parsingError
                }
                
                let dateFormat = DateFormatter()
                dateFormat.dateFormat = "yyyy-MM-dd"
                dateFormat.dateStyle = .long
                var dateString = ""
                if let date = dateFormat.date(from: lastCheckedOut) {
                    dateString = dateFormat.string(from: date)
                }
                
                let parsedBook = Book(author:author, catrgoires:categories, id:id, lastCheckedOut:dateString, lastCheckedOutBy:lastCheckedOutBy, publisher: publisher, title:title, url:url)
                
                bookArr.append(parsedBook)
                
            }
        }
        
        catch {
            
        }
        return bookArr
    }
    static func todaysDate() -> String {
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss zzz"
        return dateFormatter.string(from: today)
    }
    static func getSingleBook(from data: Data) -> Book? {
        var bookToReturn: Book?
        
        do {
            let jsonData: Any = try JSONSerialization.jsonObject(with: data, options: [])
            
            guard let response = jsonData as? [String : Any] else {
                throw ErrorCases.singlebookError
            }
            
//            if let book = try Book(frresponseom: ) {
//                bookToReturn = book
//            }
        }
            
        catch {
            print("Error encountered with \(error)")
        }
        
        return bookToReturn
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

/*
 
 "author": "Jason Morris",
 "categories": "interface, ui, android",
 "id": 1,
 "lastCheckedOut": null,
 "lastCheckedOutBy": null,
 "title": "User Interface Development: Beginner's Guide",
 "url": "/books/1/"
 
 */
