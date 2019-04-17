//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  ___COPYRIGHT___
//

import ObjectMapper

class BaseService {
    
    private let provider = APIProvider<UserTarget>()
    private let providerAttribute = APIProvider<WorkerTarget>()
    
    func login(phone: String, password: String, completion: @escaping ServiceCompletion<Void>) {
        provider.callAPI(.login(phone: phone, password: password.sha256())) { result in
            switch result {
            case .success(let data):
                // Decode data for need`s model
                return completion(.success(()))
            case .failure(let error):
                return completion(.failure(error))
            }
        }
    }
}
