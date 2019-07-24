//
//  ProfileViewController.swift
//  flickerSwift
//
//  Created by Darya Klochkova on 19/07/2019.
//  Copyright © 2019 Darya Klochkova. All rights reserved.
//

import UIKit

class ProfileViewController: BasePhotoViewController, UICollectionViewDelegate {
    
    @IBOutlet weak var photosCollectionView: UICollectionView!
    
    weak var header: ProfileHeaderView?
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photos = user?.photos
    }
    
    @objc override func photoUpdated(notification: Notification) {
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
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath)
        
        if let cell = cell as? PhotoCollectionViewCell {
            cell.imageView.contentMode = .scaleAspectFill
        }
        
        return cell
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        header?.setWidth(photosCollectionView.frame.width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "PhotoViewer", bundle: nil)
        if let viewController = storyboard.instantiateInitialViewController() as? PhotoViewerViewController  {

            viewController.photos = user?.photos
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
