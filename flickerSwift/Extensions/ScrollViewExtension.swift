//
//  ViewControllerExtension.swift
//  flickerSwift
//
//  Created by Darya Klochkova on 26/07/2019.
//  Copyright © 2019 Darya Klochkova. All rights reserved.
//

import UIKit

extension UIScrollView {
    
    func zoomTo(point: CGPoint, scale: CGFloat, animated: Bool) {
        
        //Normalize current content size back to content scale of 1.0f
        let normalContentSize = CGSize(width: contentSize.width / zoomScale, height: contentSize.height / zoomScale)

        var zoomPoint = point
        zoomPoint.x = (zoomPoint.x / bounds.size.width) * normalContentSize.width
        zoomPoint.y = (zoomPoint.y / bounds.size.height) * normalContentSize.height
        
        
        let newZoomSize = CGSize(width: bounds.size.width / scale, height: bounds.size.height / scale)
        
        var zoomRect = CGRect()
        zoomRect.origin.x = zoomPoint.x - newZoomSize.width / 2
        zoomRect.origin.y = zoomPoint.y - newZoomSize.height / 2
        zoomRect.size = newZoomSize
        
        zoom(to: zoomRect, animated: animated)
        
    }
}
