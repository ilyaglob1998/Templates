//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  ___COPYRIGHT___
//

import Moya

enum BaseTarget: APITargetType, AccessTokenAuthorizable {
    
    case login(phone: String, password: String)
    
    var parameters: [String : Any] {
        switch self {
        case let .login(phone, password):
            var params: [String: Any] = [
                "phone": phone,
                "password": password
            ]
            return params
        default: return [:]
        }
    }
    
    var authorizationType: AuthorizationType {
        switch self {
        case .login:
            return .bearer
        default:
            return .none
        }
    }
    
    var path: String {
        switch self {
        case .login:
            return "/users/login"
        default: break
            
        }
    }
    
    var method: Moya.Method {
        switch self {
        default:
            return .post
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var task: Task {
        return Task.requestParameters(parameters: parameters, encoding: parameterEncoding)
    }
}
