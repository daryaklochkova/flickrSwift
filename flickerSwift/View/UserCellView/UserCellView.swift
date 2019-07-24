//
//  UserCellView.swift
//  flickerSwift
//
//  Created by Darya Klochkova on 15/07/2019.
//  Copyright © 2019 Darya Klochkova. All rights reserved.
//

import Foundation
import UIKit

class UserCellView: UITableViewCell {
    
    @IBOutlet var userCell: UITableViewCell!    
    @IBOutlet weak var userNameLable: UILabel!
    @IBOutlet weak var photosCount: UILabel!
    @IBOutlet weak var photoView: UIImageView!
    
    var userName: String {
        get {
            if let name = userNameLable.text {
                return name
            }
            return ""
        }
        
        set {
            userNameLable.text = newValue
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("UserCell", owner: self, options: nil)
        addSubview(userCell)
        
        userCell.frame = frame
        NSLayoutConstraint(item: userCell!, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: userCell!, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: userCell!, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: userCell!, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
        
        photoView.layer.cornerRadius = photoView.bounds.height / 9
    }
    
    override func prepareForReuse() {
        userName = String()
        userNameLable.text = String()
        photoView.image = UIImage(named: "NoPhoto")
    }
}
