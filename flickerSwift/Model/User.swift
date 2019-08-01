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
    
    //MARK: Photos property
    private var _photos: [Photo]?
    private let photoAccessQueue = DispatchQueue(label: "FlickrSwift.photoAccessQueue", qos: .background, attributes: .concurrent)
    
    var photos: [Photo]? {
        get {
            var photosCopy: [Photo]?
            photoAccessQueue.sync {
                [unowned self] in
                photosCopy = self._photos
            }
            
            return photosCopy
        }
        
        set {
            photoAccessQueue.async(flags: .barrier) {
                 [unowned self] in
                self._photos = newValue
            }
        }
    }
    
    func addPhoto(_ photo: Photo) {
        photoAccessQueue.async(flags: .barrier) {
            [unowned self] in
            
            if self._photos == nil {
                self._photos = [Photo]()
            }
            
            self._photos?.append(photo)
        }
    }
    
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
        
        if let realName = userInfo["realname"] as? NSDictionary,
            let content = realName["_content"] as? String, content != "" {
            self.realName = content
        }
        
        
        icon = Icon(dictionary: userInfo, owner: self)
        getPhotosFromDataProvider()
        
        NotificationCenter.default.addObserver(self, selector: #selector(photoUpdated(notification:)), name: .iconUpdated, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    fileprivate func parseReceivedPhotosInfo(_ receivedPhotos: NSArray) {
        for photo in receivedPhotos {
            if  let photoDictionary = photo as? NSDictionary,
                let photo = Photo(dictionary: photoDictionary, owner: self) {
                self.addPhoto(photo)
            }
        }
    }
    
    func getPhotosFromDataProvider() {
        DataProvider.instance.getPhotosInfoForUser(user: self) {
            [weak self] (dictionary) in
   
            if let photosInfo = dictionary["photos"] as? NSDictionary,
                let receivedPhotos = photosInfo["photo"] as? NSArray {
                self?.parseReceivedPhotosInfo(receivedPhotos)
            }
        }
    }
    
    @objc func photoUpdated(notification: Notification) {
        if let object = notification.object as? Icon, icon === object {
            NotificationCenter.default.post(name: .userUpdated, object: self)
        }
    }
    
}
