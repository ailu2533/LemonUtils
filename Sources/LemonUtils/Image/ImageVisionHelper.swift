import CoreImage
import Foundation
import Vision

import VisionKit

public struct ImageVisionHelper {
    public init() {}

    public func render(ciImage img: CIImage) -> CGImage {
        guard let cgImage = CIContext(options: nil).createCGImage(img, from: img.extent) else {
            fatalError("failed to render CIImage")
        }
        return cgImage
    }

    public func removeBackground(from image: CIImage, croppedToInstanceExtent: Bool) -> CIImage? {
        let request = VNGenerateForegroundInstanceMaskRequest()
        let handler = VNImageRequestHandler(ciImage: image)

        do {
            try handler.perform([request])
        } catch {
            print("Failed to perform vison request \(error)")
            return nil
        }

        guard let result = request.results?.first else {
            print("No subject observations found")
            return nil
        }

        do {
            let maskedImage = try result.generateMaskedImage(ofInstances: result.allInstances, from: handler, croppedToInstancesExtent: croppedToInstanceExtent)
            return CIImage(cvPixelBuffer: maskedImage)
        } catch {
            print("Failed to generate masked image")
            return nil
        }
    }

    public func extractAllInstances(from image: CIImage, croppedToInstanceExtent: Bool) -> [CIImage] {
        let request = VNGenerateForegroundInstanceMaskRequest()
        let handler = VNImageRequestHandler(ciImage: image)

        do {
            try handler.perform([request])
        } catch {
            print("Failed to perform vison request \(error)")
            return []
        }

        guard let result = request.results?.first else {
            print("No subject observations found")
            return []
        }

        var maskedImages: [CIImage] = []

        for instance in result.allInstances {
            do {
                let maskedImage = try result.generateMaskedImage(ofInstances: [instance], from: handler, croppedToInstancesExtent: croppedToInstanceExtent)
                maskedImages.append(CIImage(cvPixelBuffer: maskedImage))
            } catch {
                print("Failed to generate masked image for instance: \(error)")
            }
        }

        return maskedImages
    }
}
