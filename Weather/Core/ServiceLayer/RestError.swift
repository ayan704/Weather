//
//  RestError.swift
//  Weather
//
//  Created by Ayan Mandal on 12/16/17.
//  Copyright © 2017 Ayan Mandal. All rights reserved.
//

class RestError {
    
    let errorCode: Int
    let errorMessage: String
    
    init(code: Int, message: String) {
        self.errorCode = code
        self.errorMessage = message
    }
}
