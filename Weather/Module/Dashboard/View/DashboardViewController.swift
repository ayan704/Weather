//
//  DashboardViewController.swift
//  Weather
//
//  Created by Ayan Mandal on 12/16/17.
//  Copyright © 2017 Ayan Mandal. All rights reserved.
//

import UIKit

class DashboardViewController: BaseViewController {
    
    @IBOutlet private weak var searchbar: UISearchBar!
    @IBOutlet private weak var currentTemparatureLabel: UILabel!
    @IBOutlet private weak var weatherDescriptionLabel: UILabel!
    @IBOutlet private weak var weatherImageView: CustomImageView!
    @IBOutlet private weak var temparatureRangeLabel: UILabel!
    @IBOutlet private weak var pressureLabel: UILabel!
    @IBOutlet private weak var humidityLabel: UILabel!
    @IBOutlet private weak var windSpeedLabel: UILabel!
    @IBOutlet private weak var locationLabel: UILabel!
    @IBOutlet private weak var visibilityLabel: UILabel!
    @IBOutlet fileprivate weak var noSearchAvailableView: UIView!
    @IBOutlet fileprivate weak var cancelButtonWidth: NSLayoutConstraint!
    
    private var viewModel: DashboardViewModel = DashboardViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Dashboard"
        self.configureUI()
        self.configureDelegates()
        self.loadRecentlySearchedCity()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /// configure default UI elements, can be used to setup font, color etc
    private func configureUI() {
        self.cancelButtonWidth.constant = 0.0
    }
    
    /// set all necessary delegates
    private func configureDelegates() {
        self.viewModel.delegate = self
        self.searchbar.delegate = self
    }
    
    /// Auto populate data for recently searched city
    private func loadRecentlySearchedCity() {
        if let recentCity = CommonUtility.getRecentlySearchedCity() {
            self.viewModel.getDashboardData(searchCity: recentCity)
        } else {
            self.noSearchAvailableView.isHidden = false
        }
    }
    
    @IBAction func cancelButtonClick(_ sender: Any) {
        if self.searchbar.canResignFirstResponder {
            self.searchbar.resignFirstResponder()
        }
    }
    
}

// MARK: - Search bar delegate
extension DashboardViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.cancelButtonWidth.constant = 75.0
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.cancelButtonWidth.constant = 0.0
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchbar.text, !searchText.isEmpty else {
            self.showError(errorMessage: Constants.emptySearchString)
            return
        }
        self.viewModel.getDashboardData(searchCity: searchText)
        searchBar.resignFirstResponder()
    }
}

extension DashboardViewController: DashboardProtcol {
    
    /// Update UI elements after getting the data back from the API
    func refreshDashboard() {
        
        self.noSearchAvailableView.isHidden = true
        self.currentTemparatureLabel.text = self.viewModel.dashboard?.mainDetail?.temparature
        self.weatherDescriptionLabel.text = self.viewModel.dashboard?.weather?.weatherDescription
        self.temparatureRangeLabel.text = (self.viewModel.dashboard?.mainDetail?.maximumTemparature ?? "") + "/" +
            (self.viewModel.dashboard?.mainDetail?.minimumTemparature ?? "")
        self.pressureLabel.text = self.viewModel.dashboard?.mainDetail?.pressure
        self.humidityLabel.text = self.viewModel.dashboard?.mainDetail?.humidity
        self.windSpeedLabel.text = self.viewModel.dashboard?.wind?.speed
        self.locationLabel.text = self.viewModel.dashboard?.name
        self.visibilityLabel.text = self.viewModel.dashboard?.visibility
        
        self.weatherImageView.setImage(urlString: CommonUtility.getURLforImage(imageIconId: self.viewModel.dashboard?.weather?.icon),
                                       placeHolderImage: Constants.placeholderImage)
    }
    
    /// Display error mesage
    ///
    /// - Parameter errorMessage: error message string
    func displayError(errorMessage: String) {
        self.showError(errorMessage: errorMessage)
    }
}

