//
//  CommonUtility.swift
//  Weather
//
//  Created by Ayan Mandal on 12/16/17.
//  Copyright © 2017 Ayan Mandal. All rights reserved.
//

import Foundation

class CommonUtility {
    
    /// Method to save recently searched city
    ///
    /// - Parameter city: successfully searched city
    class func saveRecentlySearchedCity(city: String) {
        
        //There are other ways also to save city other than UserDefaults. We can store it in Keychain, Plist, or Coredata
        //If we use core data, we can store the response as well, so that we dont need to make the webservice call again
        //during relaunch
        UserDefaults.standard.set(city, forKey: Constants.recentSearchedCityKey)
    }
    
    /// Method to retrieve last saved city
    ///
    /// - Returns: last city, returns nil otherwise
    class func getRecentlySearchedCity() -> String? {
        return UserDefaults.standard.string(forKey: Constants.recentSearchedCityKey)
    }
    
    /// Method to construct URL for image download
    ///
    /// - Parameter imageIconId: image icon id
    /// - Returns: returns complete URL as String
    class func getURLforImage(imageIconId: String?) -> String {
        return ImageURLConstants.baseURL + (imageIconId ?? "") + ImageURLConstants.imageType
    }
    
}
