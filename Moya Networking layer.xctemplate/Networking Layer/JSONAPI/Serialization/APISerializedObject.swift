//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  ___COPYRIGHT___
//

import ObjectMapper

typealias SerializedObject = [String: Any]

class APISerializedObject: Mappable {
    
    private(set) var data: APISerializationData? = nil
    private(set) var status: Int = 9999
    private(set) var message: String?
    
    /// Returns Serialized JSON, suitable for use with ObjectMapper
    var serializedObject: Any? {
        return data?.serializedData()
    }
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        data <- (map["data"], APISerializationData.Transform())
        status <- map["status"]
        message <- map["message"]
    }
}

enum APISerializationData {
    
    case array([SerializedObject])
    case object(SerializedObject)
    case string(String)
    case arrayString([String])
    
    func serializedData() -> Any? {
        switch self {
        case .array(let objects):
            return objects.map { $0 }
        case .object(let object):
            return object
        case .string(let object):
            return object
        case .arrayString(let objects):
            return objects.map { $0 }
        }
    }
    
    struct Transform: TransformType {
        
        typealias Object = APISerializationData
        typealias JSON = Any?
        
        func transformFromJSON(_ value: Any?) -> Object? {
            guard let value = value else { return nil }
            if let objects = value as? [[String: Any]] {
                return .array(objects)
            }
            if let object = value as? [String: Any] {
                return .object(object)
            }
            else if let objects = value as? [String] {
                return .arrayString(objects)
            } else {
                guard let string = value as? String else { return nil }
                return .string(string)
            }
        }
        
        func transformToJSON(_ value: Object?) -> JSON? {
            return value?.serializedData()
        }
    }
}
