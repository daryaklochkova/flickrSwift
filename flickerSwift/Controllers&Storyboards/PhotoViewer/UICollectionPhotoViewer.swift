//
//  UICollectionPhotoViewer.swift
//  flickerSwift
//
//  Created by Darya Klochkova on 29/07/2019.
//  Copyright © 2019 Darya Klochkova. All rights reserved.
//

import UIKit

class UICollectionPhotoViewer: UICollectionView {
    
    func getPrimaryVisibleCell() -> UICollectionViewCell {
        
        var targetCell = visibleCells[0]
        for cell in visibleCells {
            var visibleArea: CGFloat
            if cell.frame.origin.x < contentOffset.x {
                visibleArea = cell.frame.origin.x + cell.frame.width - contentOffset.x
            } else {
                visibleArea = contentOffset.x + cell.frame.width - cell.frame.origin.x
            }
            
            if visibleArea > (cell.frame.width / 2) {
                targetCell = cell
            }
        }
        return targetCell
    }
}
