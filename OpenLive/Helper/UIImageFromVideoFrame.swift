//
//  UIImageFromVideoFrame.swift
//  OpenLive
//
//  Created by Sky Xu on 3/18/18.
//  Copyright © 2018 Agora. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

//get img from first second of video
extension UIImage {
    class func getVideoThumbnil(atPath url: URL) -> UIImage? {
        let asset = AVURLAsset(url: url as URL)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        do {
            let cgImage  = try generator.copyCGImage(at: CMTimeMake(0, 1), actualTime: nil)
            return UIImage(cgImage: cgImage)
        }
        catch let error as NSError {
            print("image generation failed with \(error)")
            return nil
        }
    }
}

extension UIImage {
     class func convertViewToImg(view: UIView) -> UIImage? {
        UIGraphicsBeginImageContext(view.frame.size)
        do {
            view.layer.render(in:UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            let convertedImg = image
            return convertedImg
        }
        catch let err as NSError {
            print("convert to img failed with \(err)")
            return nil
        }
    }
}
