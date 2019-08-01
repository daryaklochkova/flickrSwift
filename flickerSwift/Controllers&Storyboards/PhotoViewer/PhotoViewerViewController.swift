//
//  PhotoViewerViewController.swift
//  flickerSwift
//
//  Created by Darya Klochkova on 23/07/2019.
//  Copyright © 2019 Darya Klochkova. All rights reserved.
//

import UIKit

class PhotoViewerViewController: BasePhotoViewController, UICollectionViewDelegate {
    
    //MARK: Outlets
    @IBOutlet weak var smallCollectionView: UICollectionView!
    @IBOutlet weak var bigCollectionView: UICollectionPhotoViewer!
    
    //MARK:
    var currentCellIndexPath = IndexPath(row: 0, section: 0)
    
    
    //MARK: Life cycle functions

    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeToNotifications()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        scrollToItemInBothCollection(at: currentCellIndexPath)
        bigCollectionView.reloadItems(at: [currentCellIndexPath])
    }
    
    fileprivate func subscribeToNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(orientationChanged(notification:)), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    //MARK: User actions handlers
    @IBAction func onceTap(_ sender: Any) {
        if smallCollectionView.isHidden {
            smallCollectionView.isHidden = false
        } else {
            smallCollectionView.isHidden = true
        }
    }
    
    @IBAction func swipeToBottom(_ sender: Any) {
        let transition = createTrancitionAnimation(direction: CATransitionSubtype.fromBottom)
        self.navigationController?.view.layer.add(transition, forKey: nil)
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func swipeToUp(_ sender: Any) {
        let transition = createTrancitionAnimation(direction: CATransitionSubtype.fromTop)
        self.navigationController?.view.layer.add(transition, forKey: nil)
        self.navigationController?.popViewController(animated: false)
    }
    
    //MARK: Trancition animation
    func createTrancitionAnimation(direction: CATransitionSubtype) -> CATransition {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.reveal
        transition.subtype = direction
        
        return transition
    }

    @objc func orientationChanged(notification:Notification) {
        invalidateLayoutForBothCollectionViews()
        scrollToItemInBothCollection(at: currentCellIndexPath, animated: false)
        bigCollectionView.reloadItems(at: [currentCellIndexPath])
    }

    //MARK: UIcrollViewDelegate implementation
    func scrollToItemInBothCollection(at index: IndexPath, animated: Bool = false) {
        bigCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: animated)
        smallCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: animated)
    }
    
    func invalidateLayoutForBothCollectionViews() {
        bigCollectionView.collectionViewLayout.invalidateLayout()
        smallCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        guard let collectionView = scrollView as? UICollectionView,
            collectionView == bigCollectionView else {
                return
        }
        
        var targetOffset: CGPoint?
        
        if velocity.x == 0 {
            let cell = bigCollectionView.getPrimaryVisibleCell()
            targetOffset = cell.frame.origin
            if let indexPath = bigCollectionView.indexPath(for: cell) {
                currentCellIndexPath = indexPath
            }
        } else {
            var row = currentCellIndexPath.row
            
            if velocity.x > 0 {
                row += 1
            } else {
                row -= 1
            }
            
            let nextIndexPath = IndexPath(row: row, section: 0)
            if (nextIndexPath[1] < photos?.count ?? 0) && (nextIndexPath[1] >= 0) {
                let frame = bigCollectionView.collectionViewLayout.layoutAttributesForItem(at: nextIndexPath)?.frame
                targetOffset = frame?.origin
                currentCellIndexPath = nextIndexPath
            }
        }
        
        if let targetOffset = targetOffset {
            targetContentOffset.pointee = targetOffset
            smallCollectionView.scrollToItem(at: currentCellIndexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    //MARK: UICollectionViewDelegate implementation
    func collectionView(_ collectionView: UICollectionView,
                        didHighlightItemAt indexPath: IndexPath) {
        guard collectionView == smallCollectionView else {
            return
        }
        currentCellIndexPath = indexPath
        scrollToItemInBothCollection(at: indexPath)
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView === bigCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
            
            if let cell = cell as? PhotoCollectionViewCell {
                
                if let photo = photos?[indexPath[1]] {
                    cell.configureWith(photo: photo, and: collectionView.frame.size)
                }
                
                cell.enableZoom(zoomScale: 3)
                return cell
            }
        }
        
        
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath)
        
        if let cell = cell as? PhotoCollectionViewCell {
            cell.scaleToFill()
        }
        
        return cell
        
    }
}

extension PhotoViewerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size: CGSize
        
        if collectionView === bigCollectionView {
            size = collectionView.frame.size
        } else {
            let cellSide = collectionView.frame.height - 10
            size = CGSize(width: cellSide, height: cellSide)
        }
        
        return size
    }
}

