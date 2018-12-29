//
//  UIImageViewExtensions.swift
//  youtube
//
//  Created by noriki.iwamatsu on 2018/12/26.
//  Copyright © 2018 noriki.iwamatsu. All rights reserved.
//

import Kingfisher
import UIKit

extension UIImageView {
    func loadImage(url: String, placeholder: UIImage? = nil, options: KingfisherOptionsInfo? = nil) {
        self.image = nil
        guard let url = URL(string: url) else {
            return
        }
        self.kf.setImage(with: url, placeholder: placeholder, options: options)
    }

    func loadImage(_ loadable: Loadable?) {
        self.image = nil
        guard let url = loadable?.url else {
            return
        }
        self.loadImage(url: url)
    }

    func circle() -> UIImageView {
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = true
        return self
    }
}

/** Resizer function for uploads */
extension UIImage {
    static func createCircleImage(size: CGSize, color: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        let context = UIGraphicsGetCurrentContext()
        context?.setStrokeColor(color.cgColor)
        context?.strokeEllipse(in: CGRect(x: 1, y: 1, width: size.width - 2, height: size.height - 2))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image
    }
    
    func resizedImage(newSize: CGSize) -> UIImage {
        // Guard newSize is different
        guard self.size != newSize else { return self }
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func cropSquare() -> UIImage {
        guard self.size.height != self.size.width else { return self }
        
        var rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        if self.size.height < self.size.width {
            rect.origin.x = (self.size.width - self.size.height) / 2
            rect.size.width = self.size.height
        } else {
            rect.origin.y = (self.size.height - self.size.width) / 2
            rect.size.height = self.size.width
        }
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        self.draw(at: CGPoint(x: -rect.origin.x, y: -rect.origin.y))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func resizedRoundedImage(newSize: CGSize) -> UIImage {
        // Guard newSize is different
        guard self.size != newSize else { return self }
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        UIBezierPath(roundedRect: rect, cornerRadius: newSize.width).addClip()
        self.draw(in: rect)
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func overlay(image: UIImage) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)
        
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        image.draw(in: CGRect(x: (self.size.width - image.size.width) / 2,
                              y: (self.size.height - image.size.height) / 2,
                              width: image.size.width,
                              height: image.size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image
    }
    
    func resizedImageWithinRect(rectSize: CGSize) -> UIImage {
        let widthFactor = size.width / rectSize.width
        let heightFactor = size.height / rectSize.height
        
        var resizeFactor = widthFactor
        if size.height > size.width {
            resizeFactor = heightFactor
        }
        
        let newSize = CGSize(width: size.width / resizeFactor, height: size.height / resizeFactor)
        let resized = resizedImage(newSize: newSize)
        return resized
    }
    
    func resizeForUpload() -> UIImage {
        // Make both height and width under 1500:
        let MAX_DIMENSION = CGFloat(1500)
        
        let heightInPoints = size.height
        let heightInPixels = heightInPoints * scale
        let widthInPoints = size.width
        let widthInPixels = widthInPoints * scale
        var newWidthInPixels = widthInPixels
        var newHeightInPixels = heightInPixels
        
        if heightInPixels > MAX_DIMENSION || widthInPixels > MAX_DIMENSION {
            let scale = heightInPixels > widthInPixels ? heightInPixels / MAX_DIMENSION : widthInPixels / MAX_DIMENSION
            newWidthInPixels = widthInPixels / scale
            newHeightInPixels = heightInPixels / scale
        }
        
        let resizedImage = resizedImageWithinRect(rectSize: CGSize(width: newWidthInPixels, height: newHeightInPixels))
        return resizedImage
    }
}

