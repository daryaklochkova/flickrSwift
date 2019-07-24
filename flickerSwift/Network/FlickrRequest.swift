//
//  FlickrRequest.swift
//  flickerSwift
//
//  Created by Darya Klochkova on 15/07/2019.
//  Copyright © 2019 Darya Klochkova. All rights reserved.
//

import Foundation

class FlickrRequestCreator {
    let url = "https://www.flickr.com/services/rest/"
    let api_key = "85974c3f3e4f62fd98efb4422277c008"
    let format = "json"
    let nojsoncallback = "1"
    
    private var urlComponents: URLComponents!
    
    init() {
        urlComponents = URLComponents(string: url)
        
        let apiKeyItem = URLQueryItem(name: "api_key", value: api_key)
        let formatItem = URLQueryItem(name: "format", value: format)
        let nojsoncallbackItem = URLQueryItem(name: "nojsoncallback", value: nojsoncallback)
        
        urlComponents.queryItems = [apiKeyItem, formatItem, nojsoncallbackItem]
    }
    
    func createGetUserInfoRequest(_ userID: String) -> URLRequest {
        var tmpUrlComponents = URLComponents(url: urlComponents.url!, resolvingAgainstBaseURL: true)!
        tmpUrlComponents.queryItems?.append(URLQueryItem(name: "method", value: "flickr.people.getInfo"))
        tmpUrlComponents.queryItems?.append(URLQueryItem(name: "user_id", value: userID))
        
        return URLRequest(url: tmpUrlComponents.url!)
    }
    
    func createFindByUsernameRequest(_ username: String) -> URLRequest {
        var tmpUrlComponents = URLComponents(url: urlComponents.url!, resolvingAgainstBaseURL: true)!
        tmpUrlComponents.queryItems?.append(URLQueryItem(name: "method", value: "flickr.people.findByUsername"))
        tmpUrlComponents.queryItems?.append(URLQueryItem(name: "username", value: username))
        
        print(tmpUrlComponents.url!)
        
        return URLRequest(url: tmpUrlComponents.url!)
    }
    
    func createGetPhotosRequest(_ userID: String) -> URLRequest {
        var tmpUrlComponents = URLComponents(url: urlComponents.url!, resolvingAgainstBaseURL: true)!
        tmpUrlComponents.queryItems?.append(URLQueryItem(name: "method", value: "flickr.people.getPhotos"))
        tmpUrlComponents.queryItems?.append(URLQueryItem(name: "user_id", value: userID))
        
        return URLRequest(url: tmpUrlComponents.url!)
    }
}
