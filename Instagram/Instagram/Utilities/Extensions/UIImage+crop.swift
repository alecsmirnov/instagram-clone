//
//  UIImage+crop.swift
//  Instagram
//
//  Created by Admin on 08.02.2021.
//

import UIKit

extension UIImage {
    func crop(toRect cropRect: CGRect, viewWidth: CGFloat, viewHeight: CGFloat) -> UIImage? {
        let imageViewScale = max(size.width / viewWidth, size.height / viewHeight)
        
        let cropZone = CGRect(
            x: cropRect.origin.x * imageViewScale,
            y: cropRect.origin.y * imageViewScale,
            width: cropRect.size.width * imageViewScale,
            height: cropRect.size.height * imageViewScale)

        guard let cutImageRef = cgImage?.cropping(to: cropZone) else { return nil }
        
        let croppedImage = UIImage(cgImage: cutImageRef)
        
        return croppedImage
    }
}
