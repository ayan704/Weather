//
//  DashboardViewModel.swift
//  Weather
//
//  Created by Ayan Mandal on 12/16/17.
//  Copyright © 2017 Ayan Mandal. All rights reserved.
//

import Foundation

protocol DashboardProtcol: class {
    func refreshDashboard()
    func displayError(errorMessage: String)
}

class DashboardViewModel {
    
    weak var delegate: DashboardProtcol?
    var dashboard: Dashboard?
    
    /// Retrieve data for any city
    ///
    /// - Parameter searchCity: searched city
    func getDashboardData(searchCity: String) {
        RestClientManager.dataRequest(requestUrl: URLs.dashboard,
                                      parameters: [APIParamConstant.dashboardDataSearchKey : searchCity],
                                      onSuccess: { [unowned self] (response) in
                                        
                                        if let dashboard = Dashboard.init(response: response) {
                                            
                                            if let errorMessage = dashboard.message, !errorMessage.isEmpty {
                                                DispatchQueue.main.async {
                                                    self.delegate?.displayError(errorMessage: errorMessage)
                                                }
                                                return
                                                //return here, since we are displaying error message in alert view, UI
                                                //update may not be required.
                                            }
                                            self.dashboard = dashboard
                                            DispatchQueue.main.async {
                                                self.delegate?.refreshDashboard()
                                            }
                                            CommonUtility.saveRecentlySearchedCity(city: searchCity)
                                            
                                        } else {
                                            DispatchQueue.main.async {
                                                self.delegate?.displayError(errorMessage: CustomErrorString.noDashboardDetail)
                                            }
                                        }
                                        
        }) { [unowned self] (restError) in
            DispatchQueue.main.async {
                self.delegate?.displayError(errorMessage: restError.errorMessage)
            }
        }
    }
    
}
