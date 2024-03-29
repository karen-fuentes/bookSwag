//
//  NeteworkManager.swift
//  bookSwag
//
//  Created by Karen Fuentes on 5/24/17.
//  Copyright © 2017 Karen Fuentes. All rights reserved.
//

import Foundation

enum RequestMethod: String {
    case post, put, get, delete
}

class NetworkRequestManager{
    static let manager = NetworkRequestManager()
    private init() {}
    
    func makeRequest(to endpoint: String,  method: RequestMethod = .get, body: [String:Any]? = nil, completion: @escaping (Data?, URLResponse?) -> Void) {
        
        guard let url: URL = URL(string: endpoint) else { return }
        
        var request: URLRequest = URLRequest(url: url)
        
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let jsonObject = body {
            do {
                let body = try JSONSerialization.data(withJSONObject: jsonObject, options: [])
                request.httpBody = body
            }
                
            catch {
                print("Error serializing body: \(error)")
            }
        }
        
        let session = URLSession.shared
        
        session.dataTask(with: request) { (data: Data?, response:URLResponse?, error: Error?) in
            if error != nil {
                print("Error encountered during post request: \(String(describing: error))")
            }
            
            if response != nil {
                let httpResponse = (response! as! HTTPURLResponse)
                print("Response status code: \(httpResponse.statusCode)")
            }
            
            completion(data, response)
            
            }.resume()
    }
}

