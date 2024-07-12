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

    public func addBorder(to image: CIImage, mask: CIImage, width: CGFloat, color: CGColor) -> CIImage? {
        // Create a larger mask for the border
        let morphologyFilter = CIFilter.morphologyRectangleMaximum()
        morphologyFilter.inputImage = mask
        morphologyFilter.width = Float(width)
        guard let borderMask = morphologyFilter.outputImage else {
            print("Failed to create border mask")
            return nil
        }

        // Create an inverted mask of the original
        let invertFilter = CIFilter.colorInvert()
        invertFilter.inputImage = mask
        guard let invertedMask = invertFilter.outputImage else {
            print("Failed to invert mask")
            return nil
        }

        // Use CIBlendWithMask to create the border
        let blendFilter = CIFilter.blendWithMask()
        blendFilter.inputImage = borderMask
        blendFilter.backgroundImage = CIImage.black
        blendFilter.maskImage = invertedMask
        guard let borderOnly = blendFilter.outputImage else {
            print("Failed to create border")
            return nil
        }

        // Create a colored border image
        let coloredBorder = CIImage(color: CIColor(cgColor: color))

        // Combine the original image with the border
        return image.composited(over: coloredBorder
            .cropped(to: image.extent)
            .applyingFilter("CIBlendWithMask", parameters: [
                kCIInputMaskImageKey: borderOnly,
            ])
        )
    }
}
