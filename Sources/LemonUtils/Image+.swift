//
//  File.swift
//
//
//  Created by ailu on 2024/4/21.
//

import Foundation
import SwiftUI

public extension Image {
    static func thumbnailImage(_ uiImage: UIImage, sizeMax width: Int = 300) -> UIImage {
        let height = uiImage.size.height * CGFloat(width) / uiImage.size.width
        let thumbnailSize = CGSize(width: width, height: Int(height))
        return uiImage.preparingThumbnail(of: thumbnailSize)!
    }

    static func thumbnailImage2(_ uiImage: UIImage, sizeMax height: Int = 300) -> UIImage {
        let width = uiImage.size.width * CGFloat(height) / uiImage.size.height
        let thumbnailSize = CGSize(width: Int(width), height: height)
        return uiImage.preparingThumbnail(of: thumbnailSize)!
    }

    static func thumbnailImageFixWidth(_ imageName: String, width: Int = 300) -> Image {
        print(imageName)
        let uiImage = UIImage(named: imageName)!
        return Image(uiImage: thumbnailImage(uiImage, sizeMax: width))
    }

    static func thumbnailImageFixHeight(_ imageName: String, height: Int = 300) -> Image {
        print("fix height \(imageName)")
        let uiImage = UIImage(named: imageName)!
        return Image(uiImage: thumbnailImage2(uiImage, sizeMax: height))
    }
}
