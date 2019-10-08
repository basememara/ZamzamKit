//
//  UIImage.swift
//  ZamzamKit
//
//  Created by Basem Emara on 5/5/16.
//  Copyright © 2016 Zamzam Inc. All rights reserved.
//

#if os(iOS)
import UIKit

public extension UIImage {

    /// Convenience initializer to handle default parameter value.
    ///
    /// - Parameters:
    ///   - named: The name of the image.
    ///   - bundle: The bundle containing the image file or asset catalog. Specify nil to search the app's main bundle.
    convenience init?(named: String, inBundle bundle: Bundle?) {
        self.init(named: named, in: bundle, compatibleWith: nil)
    }
}

public extension UIImage {
    
    /// Convenience initializer to convert a color to image.
    ///
    ///     let image = UIImage(from: .lightGray)
    ///     button.setBackgroundImage(image, for: .selected)
    ///
    /// - Parameters:
    ///   - color: The target color of the image.
    ///   - size: The size of the image.
    convenience init?(from color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        // https://stackoverflow.com/q/6496441
        UIGraphicsBeginImageContext(size)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.setFillColor(color.cgColor)
        context.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let cgImage = colorImage?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}

public extension UIImage {
    
    /// Save image to disk as PNG.
    func pngToDisk() -> URL? {
        let data = pngData()
        let folder = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        
        do {
            let name = String(random: 12, prefix: "img_")
            let url = folder.appendingPathComponent("\(name).png")
            try data?.write(to: url)
            return url
        } catch {
            return nil
        }
    }
}
#endif
