//
//  Photo.swift
//  flickerSwift
//
//  Created by Darya Klochkova on 22/07/2019.
//  Copyright © 2019 Darya Klochkova. All rights reserved.
//

import UIKit

class Photo: DownloadingFile {

    var id: String
    var farmID: Int
    var serverID: String
    var secret: String
    
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
        
        DispatchQueue.global().async {
            DataProvider.instance.getFile(file: self) {
                NotificationCenter.default.post(name: .photoUpdated, object: self)
            }
        }
    }
    
}
