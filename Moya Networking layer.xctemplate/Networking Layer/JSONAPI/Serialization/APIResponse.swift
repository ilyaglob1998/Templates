//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  ___COPYRIGHT___
//

import ObjectMapper
import Moya

class APIResponse {
    
    private let response: Moya.Response?
    private let serializedDataObject: APISerializedObject?
    
    private(set) var meta: Meta?
    
    var serializedData: Any? {
        return serializedDataObject?.serializedObject
    }
    
    var data: Any? {
        return response?.data
    }
    
    var error: DataError? {
        do {
            guard let moyaResponse = response else { return .noData }
            _ = try moyaResponse.filterSuccessfulStatusCodes()
            return nil
        } catch let moyaError {
            if let jsonAPIError = serializedDataObject?.message, let status = serializedDataObject?.status {
                return .APIError(APIError(message: jsonAPIError, status: status))
            } else {
                guard let moyaError = moyaError as? MoyaError else { return .noData }
                return .moyaError(moyaError)
            }
        }
    }
    
    var statusCode: Int? {
        return response?.statusCode
    }
    
    init(_ response: Moya.Response?) {
        self.response = response
        
        guard let json = try? response?.mapJSON() else {
            self.serializedDataObject = nil
            return
        }
        self.meta = Mapper<Meta>().map(JSONObject: json)
        self.serializedDataObject = Mapper<APISerializedObject>().map(JSONObject: json)
    }
}
