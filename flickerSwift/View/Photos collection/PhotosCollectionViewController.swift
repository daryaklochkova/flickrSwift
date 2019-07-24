//
//  ProfileViewController.swift
//  flickerSwift
//
//  Created by Darya Klochkova on 19/07/2019.
//  Copyright © 2019 Darya Klochkova. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UICollectionViewDataSource {
    
    @IBOutlet weak var photosCollectionView: UICollectionView!
    
    weak var header: ProfileHeaderView?
    
    var user: User?
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(photoUpdated(notification:)), name: .photoUpdated, object: nil)
    }
    
    @objc func photoUpdated(notification: Notification) {
        if let photo = notification.object as? Photo {
            if user != nil, user === photo.owner {
                DispatchQueue.main.async { [weak self] in
                    self?.photosCollectionView.reloadData()
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                                 viewForSupplementaryElementOfKind kind: String,
                                 at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard
                let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: ProfileHeaderView.Identifier,
                    for: indexPath) as? ProfileHeaderView
                else {
                    fatalError("Invalid view type")
            }
            
            headerView.setSize(size: headerView.frame.size)
            if let user = user {
                headerView.setInfo(user: user)
            }
            header = headerView
            return headerView
            
        default:
            assert(false, "Invalid element type")
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        header?.setWidth(photosCollectionView.frame.width)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return user?.photos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath)
        
        if let cell = cell as? PhotoCollectionViewCell,
            let photo = user?.photos?[indexPath[1]] {
            cell.configureWith(photo: photo)
        }
  
        return cell
    }
}
