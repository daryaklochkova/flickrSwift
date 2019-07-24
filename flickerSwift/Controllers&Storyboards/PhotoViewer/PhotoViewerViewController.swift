//
//  PhotoViewerViewController.swift
//  flickerSwift
//
//  Created by Darya Klochkova on 23/07/2019.
//  Copyright © 2019 Darya Klochkova. All rights reserved.
//

import UIKit

class PhotoViewerViewController: BasePhotoViewController, UICollectionViewDelegate {
    
    @IBOutlet weak var smallCollectionView: UICollectionView!
    @IBOutlet weak var bigCollectionView: UICollectionView!
    
    var currentCellIndexPath: IndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if currentCellIndexPath == nil {
            currentCellIndexPath = IndexPath(row: 0, section: 0)
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        var currentCell: UICollectionViewCell?
        
        if velocity.x == 0 {
            let visibleCells = bigCollectionView.visibleCells
            
            currentCell = visibleCells[0]
            for cell in visibleCells {
                if cell.frame.origin.x < scrollView.contentOffset.x {
                    let visibleArea = cell.frame.origin.x + cell.frame.width - scrollView.contentOffset.x
                    
                    if visibleArea > (cell.frame.width / 2) {
                        currentCell = cell
                    }
                }
            }
            
        } else if velocity.x > 0 {
            let row = currentCellIndexPath.row
            let nextIndexPath = IndexPath(row: row + 1, section: 0)
            currentCell = bigCollectionView.cellForItem(at: nextIndexPath)
        } else if velocity.x < 0 {
            let row = currentCellIndexPath.row
            let nextIndexPath = IndexPath(row: row - 1, section: 0)
            currentCell = bigCollectionView.cellForItem(at: nextIndexPath)
        }
        
        if let selectedCell = currentCell, let indexPath = bigCollectionView.indexPath(for: selectedCell) {
            targetContentOffset.pointee = selectedCell.frame.origin
            currentCellIndexPath = indexPath
        }
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

