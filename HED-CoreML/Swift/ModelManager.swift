//
//  ModelManager.swift
//  HED-CoreML
//
//  Created by He on 2018/2/8.
//  Copyright © 2018年 s1ddok. All rights reserved.
//

import UIKit
import CoreML

class ModelManager: NSObject {
    static let hedMain = HED_fuse()
    static let hedSO = HED_so()

    @objc
    static func predication(_ inputImage: UIImage)-> UIImage {
        let inputW = 500
        let inputH = 500
        guard let inputPixelBuffer = inputImage.resized(width: inputW, height: inputH)
            .pixelBuffer(width: inputW, height: inputH) else {
                fatalError("Couldn't create pixel buffer.")
        }
        
        // Use different models based on what output we need
        let featureProvider: MLFeatureProvider
      
        featureProvider = try! hedMain.prediction(data: inputPixelBuffer)

        // Retrieve results
        guard let outputFeatures = featureProvider.featureValue(for: "upscore-fuse")?.multiArrayValue else {
            fatalError("Couldn't retrieve features")
        }
        
        // Calculate total buffer size by multiplying shape tensor's dimensions
        let bufferSize = outputFeatures.shape.lazy.map { $0.intValue }.reduce(1, { $0 * $1 })
        
        // Get data pointer to the buffer
        let dataPointer = UnsafeMutableBufferPointer(start: outputFeatures.dataPointer.assumingMemoryBound(to: Double.self),
                                                     count: bufferSize)
        
        // Prepare buffer for single-channel image result
        var imgData = [UInt8](repeating: 0, count: bufferSize)
        
        // Normalize result features by applying sigmoid to every pixel and convert to UInt8
        for i in 0..<inputW {
            for j in 0..<inputH {
                let idx = i * inputW + j
                let value = dataPointer[idx]
                
                let sigmoid = { (input: Double) -> Double in
                    return 1 / (1 + exp(-input))
                }
                
                let result = sigmoid(value)
                imgData[idx] = UInt8(result * 255)
//                print("value >> \(imgData[idx])")

            }
        }
        
        // Create single chanel gray-scale image out of our freshly-created buffer
        let cfbuffer = CFDataCreate(nil, &imgData, bufferSize)!
        let dataProvider = CGDataProvider(data: cfbuffer)!
        let colorSpace = CGColorSpaceCreateDeviceGray()
        let cgImage = CGImage(width: inputW, height: inputH, bitsPerComponent: 8, bitsPerPixel: 8, bytesPerRow: inputW, space: colorSpace, bitmapInfo: [], provider: dataProvider, decode: nil, shouldInterpolate: true, intent: .defaultIntent)
        let resultImage = UIImage(cgImage: cgImage!)
        return resultImage
    }
}
