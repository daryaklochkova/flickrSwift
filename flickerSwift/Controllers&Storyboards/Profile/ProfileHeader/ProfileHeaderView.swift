//
//  HeaderView.swift
//  flickerSwift
//
//  Created by Darya Klochkova on 19/07/2019.
//  Copyright © 2019 Darya Klochkova. All rights reserved.
//

import UIKit

class ProfileHeaderView: UICollectionReusableView {
    static let Identifier = "ProfileHeader"
    
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var backgroundeimage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var followersCount: UILabel!
    @IBOutlet weak var userName: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func commonInit() {
        Bundle.main.loadNibNamed("Header", owner: self, options: nil)
        addSubview(headerView)
        
        NSLayoutConstraint(item: headerView!, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: headerView!, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: headerView!, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: headerView!, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
    
    func setSize(size: CGSize) {
        self.headerView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
    }
    
    func setWidth(_ width: CGFloat) {
        setSize(size: CGSize(width: width, height: headerView.frame.height))
    }
    
    func setInfo(user: User) {
        userName.text = user.username
        followersCount.text = "\(user.follower ?? "0") Followers - \(user.following ?? "0") Following"
        
        if let iconLocalUrl = user.icon?.localURL {
            do {
                let imageData = try Data(contentsOf: iconLocalUrl)
                profileImage.image = UIImage(data: imageData)
            } catch {
                print("Error loading image : \(error)")
            }
        }
    }
    
    override func prepareForReuse() {
        backgroundeimage.image = nil
        profileImage.image = UIImage(named: "NoPhoto")
        
        userName.text = nil
        followersCount.text = nil
    }
}
