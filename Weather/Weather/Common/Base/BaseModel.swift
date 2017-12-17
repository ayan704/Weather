//
//  BaseModel.swift
//  Weather
//
//  Created by Ayan Mandal on 12/16/17.
//  Copyright © 2017 Ayan Mandal. All rights reserved.
//

import Foundation
import SwiftyJSON

class BaseModel {

    var responseCode: String?
    var message: String?

    /// All JSON response has some common fields
    /// Combining all the common attributes in base model
    /// - Parameter response: JSON response
    init(with response: JSON) {
        self.responseCode = response["cod"].stringValue
        self.message = response["message"].stringValue
    }
}

