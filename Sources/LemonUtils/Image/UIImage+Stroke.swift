//
//  File.swift
//
//
//  Created by ailu on 2024/7/5.
//

import CoreImage
import CoreImage.CIFilterBuiltins
import Foundation
import UIKit

public extension UIImage {
    func stroke(color: UIColor, radius: Float) -> UIImage? {
        guard let image = expandEdges(by: CGFloat(radius)),
              let ciImage = CIImage(image: image),
              let outputImage = myStroke(inputImage: ciImage, color: color, radius: radius),
              let cgImage = CIContext().createCGImage(outputImage, from: outputImage.extent) else {
            return nil
        }
        return UIImage(cgImage: cgImage)
    }

    func expandEdges(by radius: CGFloat) -> UIImage? {
        let contextSize = CGSize(width: size.width + 2 * radius, height: size.height + 2 * radius)
        let format = UIGraphicsImageRendererFormat()
        format.scale = scale // Maintain the same scale factor as the old API

        let renderer = UIGraphicsImageRenderer(size: contextSize, format: format)
        return renderer.image { context in
            context.cgContext.setFillColor(UIColor.clear.cgColor)
            context.cgContext.fill(CGRect(origin: .zero, size: contextSize))
            let origin = CGPoint(x: radius, y: radius)
            draw(at: origin)
        }
    }

    private func morphologyGradient(inputImage: CIImage, radius: Float) -> CIImage? {
        let filter = CIFilter.morphologyGradient()
        filter.inputImage = inputImage
        filter.radius = radius
        return filter.outputImage
    }

    private func sourceOverCompositing(inputImage: CIImage, backgroundImage: CIImage) -> CIImage? {
        let filter = CIFilter.sourceOverCompositing()
        filter.inputImage = inputImage
        filter.backgroundImage = backgroundImage
        return filter.outputImage
    }

    func replaceWithSingleColor(inputImage: CIImage, color: UIColor) -> CIImage? {
        let filter = CIFilter.colorMatrix()
        let ciColor = CIColor(color: color)
        filter.inputImage = inputImage
        filter.rVector = CIVector(x: 0, y: 0, z: 0, w: ciColor.red)
        filter.gVector = CIVector(x: 0, y: 0, z: 0, w: ciColor.green)
        filter.bVector = CIVector(x: 0, y: 0, z: 0, w: ciColor.blue)
        filter.aVector = CIVector(x: 0, y: 0, z: 0, w: 1)
        filter.biasVector = CIVector(x: ciColor.red, y: ciColor.green, z: ciColor.blue, w: 0)
        return filter.outputImage
    }

    private func myStroke(inputImage: CIImage, color: UIColor, radius: Float) -> CIImage? {
        guard let monochromeImage = replaceWithSingleColor(inputImage: inputImage, color: color),
              let gradientImage = morphologyGradient(inputImage: monochromeImage, radius: radius) else {
            return nil
        }
        return sourceOverCompositing(inputImage: inputImage, backgroundImage: gradientImage)
    }
}
