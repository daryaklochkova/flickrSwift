//
//  ProfileViewController.swift
//  flickerSwift
//
//  Created by Darya Klochkova on 19/07/2019.
//  Copyright © 2019 Darya Klochkova. All rights reserved.
//

import UIKit

class ProfileViewController: BasePhotoViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var photosCollectionView: UICollectionView!
    
    weak var header: ProfileHeaderView?
    weak var footer: ActivityViewFooter?
    
    var user: User?
    
    var cellSizeProvider: CellSizeProvider!
    
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    
        photos = user?.photos
        
        configurateCellSizeProvider()
        subscribeToNotifications()
    }

    override func viewDidLayoutSubviews() {
        cellSizeProvider?.recalculateCellSize(photosCollectionView.frame.size)
        super.viewDidLayoutSubviews()
    }

    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        photosCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        photosCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    //MARK: Notifications handlers
    fileprivate func subscribeToNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(photoUpdated(notification:)), name: .photoUpdated, object: nil)
    }
    
    @objc override func photoUpdated(notification: Notification) {
        photos = user?.photos
        
        DispatchQueue.main.async {
            [weak self] in
            self?.footer?.isHidden = true
        }
        
        if let photo = notification.object as? Photo {
            if user != nil, user === photo.owner {
                DispatchQueue.main.async { [weak self] in
                    self?.photosCollectionView.reloadData()
                }
            }
        }
    }
    
    //MARK: UICollectionViewDelegate implementation
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        var returnElement = UICollectionReusableView()
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
            returnElement = headerView
            
        case UICollectionView.elementKindSectionFooter:
            guard let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ActivityViewFooter", for: indexPath) as? ActivityViewFooter else {
                fatalError("Invalid view type")
            }
            
            footerView.setSize(footerView.frame.size)
            footer = footerView
            
            if let photoCount = photos?.count, photoCount > 0 {
                footerView.startActivityIndicator()
            } else {
                footerView.showNoPhotosLable()
            }
 
            returnElement = footerView
        default:
            assert(false, "Invalid element type")
        }
        
        return returnElement
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath)
        
        if let cell = cell as? PhotoCollectionViewCell {
            cell.scaleToFill() 
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "PhotoViewer", bundle: nil)
        if let viewController = storyboard.instantiateInitialViewController() as? PhotoViewerViewController  {

            viewController.photos = user?.photos
            viewController.currentCellIndexPath = indexPath
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    //MARK: UICollectionViewDelegateFlowLayout realization
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSizeProvider.getCellSize()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return cellSizeProvider.getEdgeInsets();
    }
    
    //MARK: private functions
    fileprivate func configurateCellSizeProvider() {
        let layout = photosCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        cellSizeProvider = CellSizeProvider.init(minCellSize: layout.itemSize, minSpacing: Int(layout.minimumLineSpacing))
    }
    
    fileprivate func resizeHeaderAndFooter() {
        header?.setWidth(photosCollectionView.frame.width)
        footer?.setWidth(photosCollectionView.frame.width)
    }
}
