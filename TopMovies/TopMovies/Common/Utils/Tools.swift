//
//  Tools.swift
//  TopMovies
//
//  Created by Oscar Gamiz on 24/5/22.
//

import UIKit

open class Tools: NSObject
{
    public static func resizeImage(_ aImage:UIImage, withSize aSize:CGSize) -> UIImage
    {
        let rect = CGRect(origin: .zero, size: aSize)
        UIGraphicsBeginImageContextWithOptions(aSize, false, 1.0)
        aImage.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? aImage
    }
}
