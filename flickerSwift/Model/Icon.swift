//
//  Photo.swift
//  flickerSwift
//
//  Created by Darya Klochkova on 18/07/2019.
//  Copyright © 2019 Darya Klochkova. All rights reserved.
//


import Foundation


class Icon: DownloadingFile {
    let nsid: String
    let iconserver: String
    let iconfarm: Int
    
    unowned var owner: User
    
    var remoteURL: URL? {
        get {
            return URL(string: "https://farm\(iconfarm).staticflickr.com/\(iconserver)/buddyicons/\(nsid).jpg")
        }
    }
    
    var localURL: URL? {
        get {
            return owner.userFolder.appendingPathComponent("\(nsid).jpg")
        }
    }
    
    init?(dictionary: NSDictionary, owner: User) {
        guard let nsid = dictionary["nsid"] as? String,
            let iconserver = dictionary["iconserver"] as? String,
            let iconfarm = dictionary["iconfarm"] as? Int else {
                return nil
        }
        
        self.owner = owner
        self.iconserver = iconserver
        self.iconfarm = iconfarm
        self.nsid = nsid
        
       getIconFromDataProvider()
    }
    
    func getIconFromDataProvider() {
        DispatchQueue.global().async {
            DataProvider.instance.getFile(file: self, completionHandler: {
                [weak self] in
                self?.postIconUpdatedNotification()
            })
        }
    }
    
    func postIconUpdatedNotification() {
        DispatchQueue.main.async {
            [weak self] in
            NotificationCenter.default.post(name: .iconUpdated, object: self)
        }
    }
}
