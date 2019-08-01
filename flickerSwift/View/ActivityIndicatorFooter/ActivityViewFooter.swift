//
//  ActivityViewFooter.swift
//  flickerSwift
//
//  Created by Darya Klochkova on 29/07/2019.
//  Copyright © 2019 Darya Klochkova. All rights reserved.
//

import UIKit

class ActivityViewFooter: UICollectionReusableView {

    @IBOutlet var cell: UICollectionReusableView!
    
    @IBOutlet weak var noPhotosLable: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
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
    
    func setSize(_ size: CGSize) {
        cell.frame.size = size
    }
    
    func setWidth(_ width: CGFloat) {
        setSize(CGSize(width: width, height: cell.frame.size.height))
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("ActivityViewFooter", owner: self, options: nil)
        addSubview(cell)
        
        cell.frame = frame
    }
    
    func startActivityIndicator() {
        activityIndicator.startAnimating()
    }
    
    func stopActivityIndicator() {
        activityIndicator.stopAnimating()
    }
    
    func showNoPhotosLable() {
        stopActivityIndicator()
        noPhotosLable.isHidden = false
    }
}
