//
//  APIRequestManager.swift
//  bookSwag
//
//  Created by Karen Fuentes on 5/20/17.
//  Copyright © 2017 Karen Fuentes. All rights reserved.
//

import Foundation
enum HttpMethods: String {
    case post, put, delete
}

class APIRequestManager {
    
    static let manager = APIRequestManager()
    private init() {}
    
    func getData(endPoint: String, callback: @escaping (Data?) -> Void) {
        guard let myURL = URL(string: endPoint) else { return }
        let session = URLSession(configuration: URLSessionConfiguration.default)
        session.dataTask(with: myURL) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                print("Error durring session: \(error)")
            }
            guard let validData = data else { return }
            callback(validData)
            }.resume()
    }
    func postData(data: [String:Any],endPoint: String, method: HttpMethods , id: Int?) {
        var endpointWithID = endPoint
        if let bookId = id {
            endpointWithID += "/\(bookId)"
        }
        guard let url = URL(string: endpointWithID) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            let body = try JSONSerialization.data(withJSONObject: data, options: [])
            request.httpBody = body
            
        }
        catch {
            print("error in creating body data: \(error)")
        }
        let session = URLSession(configuration: .default)
        session.dataTask(with: request) { (data , response, error) in
            if error != nil {
                print("error during post request: \(error)")
            }
            if response != nil {
                let httpResponse = (response! as! HTTPURLResponse)
                print("Response status code: \(httpResponse.statusCode)")
            }
            guard let validData = data else {return}
            do {
                let json = try JSONSerialization.jsonObject(with: validData, options: .mutableLeaves) as? [String:Any]
                if let validJson = json {
                    dump(validJson)
                }
            }
            catch {
                print ("error in converting json \(error)")
            }
        }.resume()
    }
    
    func putRequest(endPoint: String, id: Int, dataBody: [String : Any], callback: @escaping (HTTPURLResponse?) -> Void) {
        let combinedEndpoint: String = "\(endPoint)\(id)"
        var request = URLRequest(url: URL(string: combinedEndpoint)!)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let body = try JSONSerialization.data(withJSONObject: dataBody, options: [])
            request.httpBody = body
        }
            
        catch {
            print("Error posting body: \(error)")
        }
        
        let session = URLSession.shared
        
        session.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print("Error encountered during post request: \(error)")
            }
            
            if response != nil {
                let httpResponse = (response! as! HTTPURLResponse)
                callback(httpResponse)
                print("Response status code: \(httpResponse.statusCode)")
            }
            
            guard let validData = data else { return }
            do {
                let json = try JSONSerialization.jsonObject(with: validData, options: []) as? [String:Any]
                if let validJson = json {
                    print(validJson)
                }
            }
                
            catch {
                print("Error converting json: \(error)")
            }
            }.resume()
    }
    
}
