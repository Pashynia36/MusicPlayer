//
//  FileReader.swift
//  MusicPlayer
//
//  Created by Pavlo Novak on 4/2/18.
//  Copyright © 2018 Pavlo Novak. All rights reserved.
//

import Foundation
import UIKit

// Class for reading our Files(mp3) from Bundle
class FileReader: NSObject {
    
    class func readFiles() -> [String] {
        
        return Bundle.main.paths(forResourcesOfType: "mp3", inDirectory: nil) 
    }
}
