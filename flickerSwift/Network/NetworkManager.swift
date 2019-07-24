//
//  NetworkManager.swift
//  flickerSwift
//
//  Created by Darya Klochkova on 15/07/2019.
//  Copyright © 2019 Darya Klochkova. All rights reserved.
//

import Foundation

typealias RequestCompletionHandler = (NSDictionary) -> Void

final class NetworkManager {
    
    //MARK: - Singletone
    static let instance = NetworkManager()
    
    private let requestCreator = FlickrRequestCreator()
    
    private init() {}
    
    //MARK: - Fetch data
    func fetchGetUserInfoRequest(userID: String, completionHandler: @escaping RequestCompletionHandler) {
        DispatchQueue.global().async {
            [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            let request = strongSelf.requestCreator.createGetUserInfoRequest(userID)
            strongSelf.fetchRequest(request: request, completionHandler: completionHandler)
        }
    }
    
    func fetchFindByUsernameRequest(username: String, completionHandler: @escaping RequestCompletionHandler) {
        DispatchQueue.global().async {
            [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            let request = strongSelf.requestCreator.createFindByUsernameRequest( username)
            strongSelf.fetchRequest(request: request, completionHandler: completionHandler)
        }
    }
    
    func fetchPhotosFor(userID: String, completionHandler: @escaping RequestCompletionHandler) {
        DispatchQueue.global().async {
            [weak self] in
            
            guard let strongSelf = self else {
                return
            }
            
            let request = strongSelf.requestCreator.createGetPhotosRequest(userID)
            strongSelf.fetchRequest(request: request, completionHandler: completionHandler)
        }
    }
    
    func fetchRequest(request: URLRequest, completionHandler: @escaping RequestCompletionHandler) {
        let task = URLSession.shared.dataTask(with: request, completionHandler: {(data, URLResponse, error) in
            guard error == nil else {
                print("Error! \(error.debugDescription)")
                return
            }
            
            guard let content = data else {
                print("No data")
                return
            }
            
            // serialise the data / NSData object into Dictionary [String : Any]
            guard let json = (try? JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSDictionary else {
                print("Not containing JSON")
                return
            }
            
            if let stat = json["stat"] as? String, stat != "ok", let message = json["message"] as? String  {
                print(message)
                return
            }
            completionHandler(json)
        })
        
        task.resume()
    }
    
    func downloadDataBy(url: URL, completionHandler: @escaping (URL) -> Void ) {
        let task = URLSession.shared.downloadTask(with: url) { (tmpUrl, urlResponce, error) in
            guard error == nil else {
                print("Error! \(error.debugDescription)")
                return
            }
            
            if let url = tmpUrl {
                completionHandler(url)
            }
        }
        
        task.resume()
    }
}

