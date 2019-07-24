//
//  BasePhotoViewController.swift
//  flickerSwift
//
//  Created by Darya Klochkova on 23/07/2019.
//  Copyright © 2019 Darya Klochkova. All rights reserved.
//

import UIKit

let identifier = "PhotoCell"

class BasePhotoViewController: UIViewController, UICollectionViewDataSource {
    var photos: [Photo]?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        
        if let cell = cell as? PhotoCollectionViewCell,
            let photo = photos?[indexPath[1]] {
            cell.configureWith(photo: photo)
            cell.setSize(cell.frame.size)
        }
        
        return cell
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(photoUpdated(notification:)), name: .photoUpdated, object: nil)
    }
    
    @objc func photoUpdated(notification: Notification) {
     
    }
    
}
