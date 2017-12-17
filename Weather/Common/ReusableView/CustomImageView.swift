//
//  CustomImageView.swift
//  Weather
//
//  Created by Ayan Mandal on 12/17/17.
//  Copyright © 2017 Ayan Mandal. All rights reserved.
//

import UIKit

class CustomImageView: UIImageView {

    private var activityIndicator: UIActivityIndicatorView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupStyle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupStyle()
    }
    
    private func setupStyle() {
        backgroundColor = .clear
    }
    
    /// Download image with URL, display placeholder image depending on the flag
    ///
    /// - Parameters:
    ///   - urlString: image URL string
    ///   - placeHolderImage: placeholder image name (should be present in main bundle)
    ///   - shouldShowDefaultImage: whether to show default image or not
    public func setImage(urlString: String?, placeHolderImage: String?, shouldShowDefaultImage: Bool = true) {
        
        guard let urlStr = urlString  else {
            self.image = UIImage(named: Constants.placeholderImage)
            return
        }
        
        if urlStr.isEmpty {
            self.image = UIImage(named: Constants.placeholderImage)
        } else if let url = URL(string: urlStr) {
            
            let name = placeHolderImage ?? Constants.placeholderImage
            self.image = shouldShowDefaultImage ? UIImage(named: name) : nil
            self.addIndicator()
            
            let defaultSession = URLSession(configuration: .default)
            let urlRequest = URLRequest.init(url: url)
            
            let dataTask = defaultSession.dataTask(with: urlRequest) { [weak self] (data, response, error) in
                
                self?.removeIndicator()
                
                if error != nil {
                    //Log or print error
                    return
                }
                
                if let imageData = data {
                    if let image = UIImage.init(data: imageData) {
                        DispatchQueue.main.async {
                            self?.image = image
                        }
                    }
                }
            }
            dataTask.resume()
        }
    }
    
    /// Add Activity Indicator while image download is in progress
    func addIndicator() {
        
        if (self.activityIndicator == nil) {
            
            self.activityIndicator = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
            self.activityIndicator?.hidesWhenStopped = true
            
            self.activityIndicator?.translatesAutoresizingMaskIntoConstraints = false
            self.activityIndicator?.transform = CGAffineTransform.init(scaleX: 1.4, y: 1.4)
            
            if let indicator = activityIndicator {
                
                self.addSubview(indicator)
                self.activityIndicator?.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
                self.activityIndicator?.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            }
        }
        self.activityIndicator?.startAnimating()
    }
    
    /// Remove Activity Indicator once image download completes (success/fail)
    func removeIndicator() {
        DispatchQueue.main.async {
            self.activityIndicator?.stopAnimating()
        }
    }

}
