//
//  User.swift
//  flickerSwift
//
//  Created by Darya Klochkova on 18/07/2019.
//  Copyright © 2019 Darya Klochkova. All rights reserved.
//

import UIKit

class User {
    var id: String!
    var username: String?
    var realName: String?
    var following: String?
    var follower: String?
    
    var icon: Icon?
    var photos: [Photo]?
    
    var userFolder: URL {
            var userFolder = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
            userFolder.appendPathComponent(id)
            do {
                try FileManager.default.createDirectory(at: userFolder, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error)
            }
            return userFolder
    }
    
    
    
    
    init?(dictionary: NSDictionary) {
        guard let userInfo = dictionary["person"] as? NSDictionary else {
            return
        }
        
        guard let userID = (userInfo["id"] as? String) else {
            return nil
        }
        
        self.id = userID
        
        if let username = userInfo["username"] as? NSDictionary,
            let content = username["_content"] as? String {
            self.username = content
        }
        realName = userInfo["realname"] as? String
        
        icon = Icon(dictionary: userInfo, owner: self)
        getPhotos()
        
        NotificationCenter.default.addObserver(self, selector: #selector(photoUpdated(notification:)), name: .iconUpdated, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func getPhotos() {
        DataProvider.instance.getPhotosInfoForUser(user: self) { [weak self] (dictionary) in
            //TODO: realization
            print(dictionary)
            
            if let photosInfo = dictionary["photos"] as? NSDictionary,
                let photos = photosInfo["photo"] as? NSArray {
                for photo in photos {
                    if let strongSelf = self,
                        let photoDictionary = photo as? NSDictionary,
                        let photo = Photo(dictionary: photoDictionary, owner: strongSelf) {
                        self?.addPhoto(photo: photo)
                    }
                }
            }
        }
    }
    
    func addPhoto(photo: Photo) {
        if photos == nil {
            photos = [Photo]()
        }
        
        photos?.append(photo)
    }
    
    @objc func photoUpdated(notification: Notification) {
        if let object = notification.object as? Icon {
            if icon === object {
                NotificationCenter.default.post(name: .userUpdated, object: self)
            }
        }
    }
}
