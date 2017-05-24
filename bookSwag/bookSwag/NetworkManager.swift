//
//  NeteworkManager.swift
//  bookSwag
//
//  Created by Karen Fuentes on 5/24/17.
//  Copyright © 2017 Karen Fuentes. All rights reserved.
//

import Foundation

enum RequestMethod: String {
    case post, put, get,delete
}
enum ErrorCases: Error {
    case jsonSerializationError, postRequestError
}
class NetworkRequestManager{
    static let manager = NetworkRequestManager()
    private init() {}
    
    func makeRequest(to endpoint: String,  method: RequestMethod = .get, body: [String:Any]? = nil, id: Int? = nil, completion: @escaping (Data?)->Void){
        var urlString = endpoint
        if let bookId = id {
            urlString = endpoint + "/\(bookId)"
        }
        guard let url: URL = URL(string: urlString) else { return }
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
            if let jsonObject = body {
                do {
                    let body = try JSONSerialization.data(withJSONObject: jsonObject, options: [])
                    request.httpBody = body
                } catch {
                    print("Error serializing body: \(ErrorCases.jsonSerializationError)")
                }
            }
        let session = URLSession.shared
        session.dataTask(with: request) { (data: Data?, response:URLResponse?, error:Error?) in
            if error != nil {
                print("Error encountered during post request: \(ErrorCases.postRequestError)")
            }
            if response != nil {
                let httpResponse = (response! as! HTTPURLResponse)
                print("Response status code: \(httpResponse.statusCode)")
            }
            completion(data)

        }.resume()
    }
}

