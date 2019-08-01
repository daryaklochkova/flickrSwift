//
//  PhotoCollectionViewCell.swift
//  flickerSwift
//
//  Created by Darya Klochkova on 22/07/2019.
//  Copyright © 2019 Darya Klochkova. All rights reserved.
//

import UIKit


class PhotoCollectionViewCell: UICollectionViewCell, UIScrollViewDelegate {
    static let Identifier = "PhotoCell"
    
    @IBOutlet var cell: PhotoCollectionViewCell!
    
    var imageView: UIImageView?
    @IBOutlet weak var scrollView: UIScrollView!
    
    //MARK: Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("PhotoCollectionViewCell", owner: self, options: nil)
        addSubview(cell)
        
        cell.frame = frame
        NSLayoutConstraint(item: cell!, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: cell!, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: cell!, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: cell!, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
        
        scrollView.delegate = self
        
        if let image = UIImage(named: "NoPhoto") {
            createImageViewWith(image: image)
        }
    }
    
    //MARK: Cell reusing
    override func prepareForReuse() {
        super.prepareForReuse()
        
        if let image = UIImage(named: "NoPhoto") {
            createImageViewWith(image: image)
        }
    }
    
    func setSize(_ size: CGSize) {
        cell.frame.size = size
    }
    
    func configureWith(photo: Photo, and size: CGSize) {
        cell.frame.size = size
        
        if let localUrl = photo.localURL {
            do {
                let imageData = try Data(contentsOf: localUrl)
                if let image = UIImage(data: imageData) {
                    createImageViewWith(image: image)
                }
            } catch {
                print("Error loading image : \(error)")
            }
        }
    }
    

    func scaleToFill() {
        guard let imageSize = imageView?.image?.size else {
            return
        }
        let boundsSize = cell.frame.size
        
        let yScale = boundsSize.height / imageSize.height
        let xScale = boundsSize.width / imageSize.width
     
        scrollView.minimumZoomScale = max(xScale, yScale)
        scrollView.zoomScale = scrollView.minimumZoomScale
        
        scrollImageToCenter()
    }
    
    func scrollImageToCenter() {
        guard let imageView = imageView else {
            return
        }
        
        let boundsSize = bounds.size
        let frameToCenter = imageView.frame
        let x = (frameToCenter.size.width - boundsSize.width) / 2
        let y = (frameToCenter.size.height - boundsSize.height) / 2
        
        print(x, y)
        scrollView.contentOffset = CGPoint(x: x, y: y)
    }
    
    func moveToCenterImageFrame() {
        
        guard let imageView = imageView else {
            return
        }
        
        let boundsSize = bounds.size
        var frameToCenter = imageView.frame
        
        if frameToCenter.size.width < boundsSize.width {
            frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2
        }
        else {
            frameToCenter.origin.x = 0
        }
        
        if frameToCenter.size.height < boundsSize.height {
            frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height)/2
        }
        else {
            frameToCenter.origin.y = 0
        }
        
        imageView.frame = frameToCenter
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        moveToCenterImageFrame()
    }
    
    func calculateMinScale() {
        guard let imageSize = imageView?.image?.size else {
            return
        }
        let boundsSize = cell.frame.size
        
        let yScale = boundsSize.height / imageSize.height
        let xScale = boundsSize.width / imageSize.width
        
        scrollView.minimumZoomScale = min(xScale, yScale) - 0.001
    }
    
    func enableZoom(zoomScale: CGFloat) {
        scrollView.maximumZoomScale = zoomScale
        cell.isUserInteractionEnabled = true
        calculateMinScale()
        scrollView.zoomScale = scrollView.minimumZoomScale
        moveToCenterImageFrame()
    }
    
    //MARK: UIScrollViewDelegate
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        moveToCenterImageFrame()
    }
    
    
    //MARK: User actions
    @IBAction func doubleTap(_ sender: UITapGestureRecognizer) {
        if scrollView.zoomScale < scrollView.maximumZoomScale {
            let touchPoint = sender.location(in: scrollView)
            scrollView.zoomTo(point: touchPoint, scale: scrollView.maximumZoomScale, animated: true)
        } else {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
            moveToCenterImageFrame()
        }
    }
    
    //MARK: private function
    fileprivate func createImageViewWith(image: UIImage) {
        imageView?.removeFromSuperview()
        imageView = UIImageView(image: image)
        calculateMinScale()
        scrollView.zoomScale = scrollView.minimumZoomScale
        moveToCenterImageFrame()
        scrollView.addSubview(imageView!)
    }
}
