//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  ___COPYRIGHT___
//

import Moya
import Result

#if DEBUG
    internal var apiUrl = "http://"
#else
    internal var apiUrl = "http://"
#endif

protocol APITargetType: TargetType {
    var parameters: [String: Any] { get }
}

extension APITargetType {
    var baseURL: URL {
        return URL(string: apiUrl)!
    }
    
    var parameterEncoding: ParameterEncoding {
        switch method {
        case .put, .post, .patch:
            return JSONEncoding.default
        default:
            return URLEncoding.default
        }
    }
    
    var task: Task {
        return .requestPlain
    }
    
    var sampleData: Data {
        return Data()
    }
}
