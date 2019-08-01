//
//  Photo.swift
//  flickerSwift
//
//  Created by Darya Klochkova on 22/07/2019.
//  Copyright © 2019 Darya Klochkova. All rights reserved.
//

import UIKit

class Photo: DownloadingFile {

    let id: String
    let farmID: Int
    let serverID: String
    let secret: String
    
    unowned var owner: User
    
    var remoteURL: URL? {
        get {
            return URL.init(string: "https://farm\(farmID).staticflickr.com/\(serverID)/\(id)_\(secret).jpg")
        }
    }
    
    var localURL: URL? {
        get {
            return owner.userFolder.appendingPathComponent("\(id)_\(secret).jpg")
        }
    }
    
    init?(dictionary: NSDictionary, owner: User) {
        guard let id = dictionary["id"] as? String,
            let farmID = dictionary["farm"] as? Int,
            let serverID = dictionary["server"] as? String,
            let secret = dictionary["secret"] as? String else {
               return nil
        }
        
        self.owner = owner
        self.id = id
        self.farmID = farmID
        self.serverID = serverID
        self.secret = secret
        
        getPhotoFromDataProvider()
    }
    
    func getPhotoFromDataProvider() {
        DispatchQueue.global().async {
            DataProvider.instance.getFile(file: self) {
                [weak self] in
                self?.sendPhotoIdNotification()
            }
        }
    }
    
    func sendPhotoIdNotification() {
        DispatchQueue.main.async {
            [weak self] in
            NotificationCenter.default.post(name: .photoUpdated, object: self)
        }
    }
}
