//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  ___COPYRIGHT___
//


import ObjectMapper
import Moya

struct APIError {
    var message: String = ""
    var status: Int = 9999
}

enum DataError: Swift.Error, CustomStringConvertible {
    case moyaError(MoyaError)
    case customError(description: String)
    case noData
    case serializationError(Any?)
    case APIError(APIError)
    case needConfirm

    var description: String {
        switch self {
        case .moyaError(let error):
            return error.errorDescription ?? ""
        case .serializationError(_):
            return "Ошибка обработки ответа сервера"
        case .APIError(let error):
            return error.message
        case .customError(let description):
            return description
        case .needConfirm:
            return "needConfirm"
        default:
            return "Ошибка сервера"
        }
    }
    
    var localizedDescription: String {
        return description
    }
}
