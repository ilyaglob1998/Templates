//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  ___COPYRIGHT___
//

import UIKit

class ImageDownloader {
    
    fileprivate static let instance = ImageDownloader()
    private init() { }
    
    class func downloadImage(with url: URL?, ignoreCache: Bool = false, completion: @escaping ((UIImage?) -> Void)) {
        guard let url = url else { return }
        if let cachedImage = CachingImage.shared.getImageFromCach(for: url), !ignoreCache {
            DispatchQueue.main.async {
                completion(cachedImage)
            }
        } else {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data = data,
                      let image = UIImage(data: data) else {
                        return
                }
                if !ignoreCache {
                    CachingImage.shared.addImageInCach(image: image, url: url)
                }
                DispatchQueue.main.async {
                    completion(image)
                }
            }.resume()
        }
    }
}

extension UIImageView {
    func downloadImage(with url: URL?) {
        ImageDownloader.downloadImage(with: url) { [weak self] image in
            DispatchQueue.main.async {
                self?.image = image
            }
        }
    }
}
