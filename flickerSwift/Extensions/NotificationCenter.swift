//
//  NotificationCenter.swift
//  flickerSwift
//
//  Created by Darya Klochkova on 18/07/2019.
//  Copyright © 2019 Darya Klochkova. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let photoUpdated = Notification.Name("photoUpdated")
    static let userUpdated = NSNotification.Name("userUpdated")
    static let iconUpdated = NSNotification.Name("iconUpdated")
    
    static let fileDownloadFailed = NSNotification.Name("fileDownloadFailed")
}
