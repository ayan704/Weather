//
//  Dashboard.swift
//  Weather
//
//  Created by Ayan Mandal on 12/16/17.
//  Copyright © 2017 Ayan Mandal. All rights reserved.
//

import SwiftyJSON

struct Coordinate {
    var latitude: String?
    var longitude: String?
}

struct Weather {
    var weatherId: String?
    var main: String?
    var weatherDescription: String?
    var icon: String?
}

struct Detail {
    var temparature: String?
    var pressure: String?
    var humidity: String?
    var minimumTemparature: String?
    var maximumTemparature: String?
}

struct Wind {
    var speed: String?
    var degree: String?
}

struct SystemDetail {
    var type: String?
    var systemId: String?
    var message: String?
    var country: String?
    var sunrise: String?
    var sunset: String?
}

class Dashboard: BaseModel {
    
    var coordinate: Coordinate?
    var weather: Weather?
    var base: String?
    var mainDetail: Detail?
    var visibility: String?
    var wind: Wind?
    var clouds: String?
    var dt: String?
    var systemDetail: SystemDetail?
    var id: String?
    var name: String?
    
    init?(response: JSON) {
        
        if response.isEmpty {
            return nil
        }
        super.init(with: response)
        self.parseResponse(responseJSON: response)
    }
    
    private func parseResponse(responseJSON: JSON) {
        
        self.coordinate = Coordinate.init(latitude: responseJSON["coord"]["lon"].stringValue,
                                          longitude: responseJSON["coord"]["lat"].stringValue)
        
        if let weatherJSON = responseJSON["weather"].array?.first {
            self.weather = Weather.init(weatherId: weatherJSON["id"].stringValue,
                                        main: weatherJSON["main"].stringValue,
                                        weatherDescription: weatherJSON["description"].stringValue,
                                        icon: weatherJSON["icon"].stringValue)
        }
        
        self.base = responseJSON["base"].stringValue
        self.mainDetail = Detail.init(temparature: responseJSON["main"]["temp"].stringValue,
                                      pressure: responseJSON["main"]["pressure"].stringValue,
                                      humidity: responseJSON["main"]["humidity"].stringValue,
                                      minimumTemparature: responseJSON["main"]["temp_min"].stringValue,
                                      maximumTemparature: responseJSON["main"]["temp_max"].stringValue)
        
        self.visibility = responseJSON["visibility"].stringValue
        self.wind = Wind.init(speed: responseJSON["wind"]["speed"].stringValue,
                              degree: responseJSON["wind"]["deg"].stringValue)
        self.clouds = responseJSON["clouds"]["all"].stringValue
        self.dt = responseJSON["dt"].stringValue
        self.systemDetail = SystemDetail.init(type: responseJSON["sys"]["type"].stringValue,
                                              systemId: responseJSON["sys"]["id"].stringValue,
                                              message: responseJSON["sys"]["message"].stringValue,
                                              country: responseJSON["sys"]["country"].stringValue,
                                              sunrise: responseJSON["sys"]["sunrise"].stringValue,
                                              sunset: responseJSON["sys"]["sunset"].stringValue)
        self.id = responseJSON["id"].stringValue
        self.name = responseJSON["name"].stringValue
    }
}

