//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  ___COPYRIGHT___
//

import Moya

public struct TokenPlugin: PluginType {
    
    private var accessToken: String? {
        return StorageHelper.loadObjectForKey(.accessToken)
    }

    public func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        guard let authorizable = target as? AccessTokenAuthorizable else { return request }
        
        let authorizationType = authorizable.authorizationType
        
        var request = request
        
        switch authorizationType {
        case .basic, .bearer:
            let authValue = authorizationType.rawValue + " " + (accessToken ?? "")
            request.addValue(authValue, forHTTPHeaderField: "Authorization")
        case .none:
            break
        }
        return request
    }
}
