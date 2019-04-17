//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  ___COPYRIGHT___
//


import ObjectMapper

// For transform into ObjectMapper (parsing and convetible)
class CustomURLTransform: TransformType {

    typealias Object = URL
    typealias JSON = String
    
    let fileURL = "http://87.236.23.68:8000/files"
    
    func transformFromJSON(_ value: Any?) -> URL? {
        guard let urlString = value as? String else { return nil }
        return URL(string: fileURL + urlString)
    }
    
    func transformToJSON(_ value: URL?) -> String? {
        guard let url = value else {
            return nil
        }
        return url.absoluteString.replacingOccurrences(of: fileURL, with: "")
    }
}
