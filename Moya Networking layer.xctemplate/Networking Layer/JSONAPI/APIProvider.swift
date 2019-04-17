//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  ___COPYRIGHT___
//

import Moya
import Result

class APIProvider<Target: APITargetType>: MoyaProvider<Target> {
    
    typealias APIResult = Result<APIResponse, DataError>
    typealias APICompletion = (_ result: APIResult) -> Void
    
    let networkActivityPlugin = NetworkActivityPlugin(networkActivityClosure: { state, _ in
        switch state {
        case .began:
            NetworkActivityIndicator.sharedIndicator.visible = true
        case .ended:
            NetworkActivityIndicator.sharedIndicator.visible = false
        }
    })
    
    @discardableResult
    func callAPI(_ target: Target, completion: @escaping APICompletion) -> Cancellable {
        debugPrint("JSON API Started request to path: \(target.path), method: \(target.method)")
        return self.request(target, callbackQueue: nil) { result in
            DispatchQueue(label: "Parsing").async {
                switch result {
                case .success(let response):
                    DispatchQueue.main.async {
                        let jsonAPIResponse = APIResponse(response)
                        if let error = jsonAPIResponse.error {
                            if response.statusCode == 401 {
                                /// handler error
                                return completion(
                                    .failure(
                                        .APIError(
                                            APIError(message: "Необходима авторизация", status: 401)
                                        )
                                    )
                                )
                            }
                            return completion(.failure(error))
                        } else {
                            return completion(.success(jsonAPIResponse))
                        }
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        debugPrint("Moya finished with error: \(error.errorDescription ?? "")")
                        return completion(.failure(.moyaError(error)))
                    }
                }
            }
        }
    }
    
    // Переопределение конструктора провайдера с дефолтными установками
    override init(endpointClosure: @escaping APIProvider<Target>.EndpointClosure = APIProvider.defaultEndpointMapping,
                  requestClosure: @escaping APIProvider<Target>.RequestClosure = APIProvider.defaultRequestMapping,
                  stubClosure: @escaping APIProvider<Target>.StubClosure = APIProvider.neverStub,
                  callbackQueue: DispatchQueue? = .main,
                  manager: Manager = Manager.default,
                  plugins: [PluginType] = [],
                  trackInflights: Bool = false) {
        var plugins = plugins
        plugins.append(networkActivityPlugin)
        plugins.append(TokenPlugin())
        #if DEBUG
        plugins.append(NetworkLoggerPlugin(verbose: true))
        #endif
        
        super.init(endpointClosure: endpointClosure, requestClosure: requestClosure, stubClosure: stubClosure, callbackQueue: callbackQueue, manager: manager, plugins: plugins, trackInflights: trackInflights)
    }
}
