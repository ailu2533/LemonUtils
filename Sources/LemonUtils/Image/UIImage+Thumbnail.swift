//
//  File.swift
//
//
//  Created by ailu on 2024/7/7.
//

import Foundation
import UIKit

public extension UIImage {
    // Helper function to generate thumbnail data
    func thumbnailData(maxThumbnailHeight: CGFloat = 80, maxThumbnailWidth: CGFloat = 80, format: ImageFormat = .png) -> Data? {
        // Check if the original image is smaller than the required thumbnail size
        guard size.width > maxThumbnailWidth || size.height > maxThumbnailHeight else {
            return format == .png ? pngData() : jpegData(compressionQuality: 0.9)
        }

        // Calculate the scale ratio while maintaining the aspect ratio
        let widthRatio = maxThumbnailWidth / size.width
        let heightRatio = maxThumbnailHeight / size.height
        let scale = min(widthRatio, heightRatio)

        // Define the new size based on the scale ratio
        let newSize = CGSize(width: size.width * scale, height: size.height * scale)

        // Use UIGraphicsImageRenderer for high-quality scaling
        let renderer = UIGraphicsImageRenderer(size: newSize)
        let thumbnail = renderer.image { _ in
            draw(in: CGRect(origin: .zero, size: newSize))
        }

        // Return the image data based on the specified format
        switch format {
        case .png:
            return thumbnail.pngData()
        case .jpeg:
            return thumbnail.jpegData(compressionQuality: 0.9) // Adjust compression quality as needed
        }
    }

    enum ImageFormat {
        case png
        case jpeg
    }
}
