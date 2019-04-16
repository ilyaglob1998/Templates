//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//___COPYRIGHT___
//

import Foundation

protocol ___VARIABLE_productName:identifire___View: class {
    
    var presenter: ___VARIABLE_productName:identifier___Presentation? { get set }
}

protocol ___VARIABLE_productName:identifier___Presentation  { }


class ___VARIABLE_productName:identifier___Presenter {
    
    weak var view: ___VARIABLE_productName:identifier___View?
    
    init(view: ___VARIABLE_productName:identifier___View) {
        self.view = view
    }
    
}

extension ___VARIABLE_productName:identifire___Presenter: ___VARIABLE_productName:identifire___Presentation {
    
}
