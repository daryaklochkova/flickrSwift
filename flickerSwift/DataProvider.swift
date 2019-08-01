//
//  DataProvider.swift
//  flickerSwift
//
//  Created by Darya Klochkova on 18/07/2019.
//  Copyright © 2019 Darya Klochkova. All rights reserved.
//

import Foundation

class DataProvider {
    
    static let instance = DataProvider()
    private init() {}
    
    func getUserBy(name: String, completionHandler: @escaping (User) -> Void) {
        NetworkManager.instance.fetchFindByUsernameRequest(username: name) {
            (dataDictionary) in
            guard let userInfo = dataDictionary["user"] as? NSDictionary,
                let userID = (userInfo["id"] as? String) else {
                    return
            }
            
            NetworkManager.instance.fetchGetUserInfoRequest(userID: userID, completionHandler: { (dataDictionary) in
                if let user = User(dictionary: dataDictionary) {
                    completionHandler(user)
                }
            })       
        }
    }
    
    
    func getFile(file: DownloadingFile, completionHandler: @escaping () -> ()) {
        if let remoteUrl = file.remoteURL, let localURL = file.localURL {
            NetworkManager.instance.downloadDataBy(url: remoteUrl, completionHandler: { (url) in
                do {
                    try FileManager.default.removeItem(at: localURL)
                } catch {
                    print(error)
                }
                
                do {
                    try FileManager.default.moveItem(at: url, to: localURL)
                    completionHandler()
                } catch {
                    print(error)
                    return
                }

            }, failHandler: { (error) in
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: .fileDownloadFailed, object: file)
                }
            })
        }
    }
    
    func getPhotosInfoForUser(user: User, completionHandler: @escaping (NSDictionary) -> Void) {
        NetworkManager.instance.fetchPhotosFor(userID: user.id, completionHandler: completionHandler)
    }
}
