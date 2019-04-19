//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  ___COPYRIGHT___
//

import UIKit

class CachingImage {
    
    static let shared = CachingImage()
    let cash = NSCache<NSString, UIImage>()
    
    func getImageFromCach(for url: URL) -> UIImage? {
        return cash.object(forKey: url.absoluteString as NSString)
    }
    
    func addImageInCach(image: UIImage, url: URL) {
        cash.setObject(image, forKey: url.absoluteString as NSString)
    }
}
