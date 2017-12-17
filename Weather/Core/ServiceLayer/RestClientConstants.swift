//
//  RestClientConstants.swift
//  Weather
//
//  Created by Ayan Mandal on 12/16/17.
//  Copyright © 2017 Ayan Mandal. All rights reserved.
//

import SwiftyJSON

typealias HTTPHeader = [String: String]
typealias APIParameters = [String: String]
typealias APISuccessHandler = (JSON) -> Void
typealias APIErrorHandler = (RestError) -> Void

struct URLs {
    static let base: String = "http://api.openweathermap.org/"
    static let dashboard: String = "data/2.5/weather"
}

struct URLRequestType {
    static let GET: String = "GET"
    static let POST: String = "POST"
}

struct APIHeaders {
    static let content: String = "Content-Type"
    static let json: String = "application/json"
    static let timeOut: Double = 10.0
}

struct APIParamConstant {
    static let appIdKey: String = "appid"
    static let appIdValue: String = "90415ad958da3510887bd657880b74ef"
    static let dashboardDataSearchKey: String = "q"
}

struct RestErrorCode {
    static let noHTTPResponseStatusCode: Int = 3001
    static let invalidURL: Int = 3002
    static let nullResponse: Int = 3003
    static let noValue: Int = 3004
}

struct RestErrorMessage {
    static let invalidURL: String = "Invalid URL"
    static let nullResponse: String = "Null Response"
    static let noValue: String = "No Value in Response"
}

