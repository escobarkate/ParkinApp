//
//  HttpClient.swift
//  parkinApp
//
//  Created by Mario Gironza Cerón on 17/11/16.
//  Copyright © 2016 movil unicauca. All rights reserved.
//

import Foundation

class HttpClient {
    
    
    func get(url:String, callback:@escaping (_ data:Data?)->Void){
        request(method: "GET", url: url, json: nil, callback: callback)
    }
    
    func post(url:String, json:String, callback:@escaping (_ data:Data?)->Void){
        request(method: "POST", url: url, json: json, callback: callback)
    }
    
    func put(url:String, json:String, callback:@escaping (_ data:Data?)->Void){
        request(method: "PUT", url: url, json: json, callback: callback)
    }
    
    func delete(url:String, callback:@escaping (_ data:Data?)->Void){
        request(method: "DELETE", url: url, json: nil, callback: callback)
    }
    
    private func request(method:String, url:String, json:String?
        , callback:@escaping (_ data:Data?)->Void){
        
        
        let u:URL = URL(string: url)!
        var request:URLRequest = URLRequest(url: u)
        request.httpMethod = method
        
        if json != nil {
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = json?.data(using: .utf8)
        }
        
        
        let session = URLSession.shared
        let task = session.dataTask(with: request){
            (data:Data?, response:URLResponse?, err:Error?) in
            
            callback(data)
            
        }
        task.resume()
    }
}
