//
//  RestClientManager.swift
//  Weather
//
//  Created by Ayan Mandal on 12/16/17.
//  Copyright © 2017 Ayan Mandal. All rights reserved.
//

import Foundation
import SwiftyJSON

class RestClientManager {
    
    /// Create common header info
    ///
    /// - Returns: HTTP Header Info
    private class func getHeaderInfo() -> HTTPHeader {
        let headers = [APIHeaders.content: APIHeaders.json]
        return headers
    }
    
    /// Configure URL request
    ///
    /// - Parameter url: request URL
    /// - Returns: URLRequest with given URL
    private class func getURLRequest(with url: URL) -> URLRequest {
        
        var request = URLRequest.init(url: url)
        request.httpMethod = URLRequestType.GET
        request.timeoutInterval = APIHeaders.timeOut
        request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringLocalCacheData
        request.allHTTPHeaderFields = self.getHeaderInfo()
        return request
    }
    
    /// Construct complete API parameters including common params
    ///
    /// - Parameter params: request params
    /// - Returns: Combined API Parameters
    private class func constractAPIParameters(params: APIParameters?) -> APIParameters? {
        var requestParams = params
        requestParams?[APIParamConstant.appIdKey] = APIParamConstant.appIdValue
        return requestParams
    }
    
    /// Query String for Get request
    ///
    /// - Parameter parameters: API parameters
    /// - Returns: query strinf
    private class func buildQueryString(fromDictionary parameters: [String: String]?) -> String {
        
        guard let parameters = parameters else {
            return ""
        }
        
        var urlVars:[String] = []
        for (key,value) in parameters {
            if let encodedValue = value.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
                urlVars.append(key + "=" + encodedValue)
            }
        }
        return urlVars.isEmpty ? "" : "?" + urlVars.joined(separator: "&")
    }
    
    /// Common class to invoke REST API
    ///
    /// - Parameters:
    ///   - requestUrl: endURL
    ///   - parameters: parameters to be passed to the API
    ///   - onSuccess: callback for success scanario
    ///   - onFailure: callback for failure scenario
    class func dataRequest(requestUrl: String,
                           parameters: APIParameters?,
                           onSuccess: @escaping APISuccessHandler,
                           onFailure: @escaping APIErrorHandler) {
        
        // Assuming all webservice calls are GET, if we want to make it configurable we can accept it as parameter as well
        
        let urlString = URLs.base + requestUrl + self.buildQueryString(fromDictionary: self.constractAPIParameters(params: parameters))
        
        guard urlString.count > 0,
            let url = URL.init(string: urlString) else {
                
                onFailure(self.restError(errorCode: RestErrorCode.invalidURL,
                                         errorMessage: RestErrorMessage.invalidURL))
            return
        }
        
        let defaultSession = URLSession(configuration: .default)
        let urlRequest = self.getURLRequest(with: url)
        
        let dataTask = defaultSession.dataTask(with: urlRequest) { (data, response, error) in
            
            if let error = error {
                let httpResponse = response as? HTTPURLResponse
                onFailure(self.restError(errorCode: httpResponse?.statusCode ?? RestErrorCode.noHTTPResponseStatusCode,
                                         errorMessage: error.localizedDescription))
                return
            }
            
            guard let data = data else {
                onFailure(self.restError(errorCode: RestErrorCode.nullResponse,
                                         errorMessage: RestErrorMessage.nullResponse))
                return
            }
            let jsonObject = JSON.init(data)
            onSuccess(jsonObject)
        }
        dataTask.resume()
    }
    
    /// Common method to construct custom Rest Error
    ///
    /// - Parameters:
    ///   - errorCode: error code
    ///   - errorMessage: error String
    /// - Returns: ReatError object
    class func restError(errorCode: Int, errorMessage: String) -> RestError {
        return RestError.init(code: errorCode, message: errorMessage)
    }
    
}

