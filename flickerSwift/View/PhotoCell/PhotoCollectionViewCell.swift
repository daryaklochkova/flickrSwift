//
//  PhotoCollectionViewCell.swift
//  flickerSwift
//
//  Created by Darya Klochkova on 22/07/2019.
//  Copyright © 2019 Darya Klochkova. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    static let Identifier = "PhotoCell"
    
    @IBOutlet var cell: PhotoCollectionViewCell!
    
    @IBOutlet weak var imageView: UIImageView!
    
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
    }
    
    func setSize(_ size: CGSize) {
        cell.frame.size = size
    }
    
    override func prepareForReuse() {
        imageView.image = UIImage(named: "NoPhoto")
    }
    
    func configureWith(photo: Photo) {
        if let iconLocalUrl = photo.localURL {
            do {
                let imageData = try Data(contentsOf: iconLocalUrl)
                imageView.image = UIImage(data: imageData)
            } catch {
                print("Error loading image : \(error)")
            }
        }
    }
}
