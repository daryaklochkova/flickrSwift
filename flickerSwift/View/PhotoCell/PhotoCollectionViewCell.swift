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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
    }
    
    func setSize(_ size: CGSize) {
        cell.frame.size = size
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView?.removeFromSuperview()
        imageView = nil
    }
    
    func configureWith(photo: Photo, and size: CGSize) {
        cell.frame.size = size
        
        if let localUrl = photo.localURL {
            do {
                let imageData = try Data(contentsOf: localUrl)
                imageView = UIImageView(image: UIImage(data: imageData))
                calculateMinScale()
                scrollView.zoomScale = scrollView.minimumZoomScale
                centerImage()
                scrollView.addSubview(imageView!)
            } catch {
                print("Error loading image : \(error)")
            }
        }
    }
    
    func centerImage() {
        
        // center the zoom view as it becomes smaller than the size of the screen
        let boundsSize = self.bounds.size
        var frameToCenter = imageView?.frame ?? CGRect.zero
        
        // center horizontally
        if frameToCenter.size.width < boundsSize.width {
            frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width)/2
        }
        else {
            frameToCenter.origin.x = 0
        }
        
        // center vertically
        if frameToCenter.size.height < boundsSize.height {
            frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height)/2
        }
        else {
            frameToCenter.origin.y = 0
        }
        
        imageView?.frame = frameToCenter
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        centerImage()
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
    
    func setPhoto(photo: Photo) {
        if let iconLocalUrl = photo.localURL {
            do {
                let imageData = try Data(contentsOf: iconLocalUrl)
                imageView?.image = UIImage(data: imageData)
            } catch {
                print("Error loading image : \(error)")
            }
        }
    }
    
    func enableZoom(zoomScale: CGFloat) {
        scrollView.maximumZoomScale = zoomScale
        cell.isUserInteractionEnabled = true
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerImage()
    }
}
