//
//  File.swift
//  
//
//  Created by ailu on 2024/7/1.
//

import Foundation


enum ImageAspectRatio: Int16 {
    case square = 1
    case widescreen = 2
    case portrait = 3
    case cinema = 4

    var ratio: (width: Int, height: Int) {
        switch self {
        case .square:
            return (1, 1)
        case .widescreen:
            return (16, 9)
        case .portrait:
            return (3, 4)
        case .cinema:
            return (21, 9)
        }
    }

    var description: String {
        switch self {
        case .square:
            return "1:1"
        case .widescreen:
            return "16:9"
        case .portrait:
            return "3:4"
        case .cinema:
            return "21:9"
        }
    }
}
