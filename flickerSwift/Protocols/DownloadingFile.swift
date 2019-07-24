//
//  File.swift
//  flickerSwift
//
//  Created by Darya Klochkova on 22/07/2019.
//  Copyright © 2019 Darya Klochkova. All rights reserved.
//

import Foundation


protocol DownloadingFile {
    var localURL: URL? { get }
    var remoteURL: URL? { get }
}
