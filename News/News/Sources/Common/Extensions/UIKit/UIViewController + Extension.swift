//
//  UIViewController + Extension.swift
//  NewsTFS
//
//  Created by Александр Джегутанов on 2/4/23.
//

import UIKit

// MARK: - Activity Indicator

extension UIViewController {
    
    func addActivityIndicator(to place: ActivityIndicatorPlace, needToStart: Bool = false, needToDisableUserInteractions: Bool = false) {
        DispatchQueue.main.async {
            var activityIndicator: BlueActivityIndicator?
            
            activityIndicator = BlueActivityIndicator(style: .large)
            
            if let activityIndicator = activityIndicator {
                self.view.addSubview(activityIndicator)
                switch place {
                case .center:
                    self.makeActivityIndicatorContraintsToCenter(indicator: activityIndicator)
                }
                
                if needToStart {
                    self.startActivityIndicatorAnimation()
                }
                
                if needToDisableUserInteractions {
                    self.view.isUserInteractionEnabled = false
                }
            }
        }
    }
    
    func startActivityIndicatorAnimation() {
        DispatchQueue.main.async {
            guard let view = self.view.subviews.first(where: {$0 is BlueActivityIndicator}) as? BlueActivityIndicator else {return}
            view.startAnimating()
        }
    }
    
    func stopAndRemoveActivityIndicator() {
        DispatchQueue.main.async {
            self.view.isUserInteractionEnabled = true
            self.stopActivityIndicatorAnimation()
            self.removeFirstView(ofClass: BlueActivityIndicator.self)
        }
    }
    
    func stopActivityIndicatorAnimation() {
        DispatchQueue.main.async {
            guard let view = self.view.subviews.first(where: {$0 is BlueActivityIndicator}) as? BlueActivityIndicator else {return}
            view.stopAnimating()
        }
    }
    
    func removeFirstView<View: UIView>(ofClass: View.Type, complition: ((View)-> Void)? = nil) {
        DispatchQueue.main.async {
            guard let view = self.view.subviews.first(where: {$0 is View}) as? View else { return }
            view.removeConstraints(view.constraints)
            view.removeFromSuperview()
            complition?(view)
        }
    }
}

//MARK: private method ActivityIndicator

private extension UIViewController {
    
    func makeActivityIndicatorContraintsToCenter(indicator: BlueActivityIndicator) {
        let safeArea = view.safeAreaLayoutGuide
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor).isActive = true
    }
}


// MARK: - Alerts

extension UIViewController {
    
    func showAlert(title: String?, message: String?, actionArray: [UIAlertAction]) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        for action in actionArray {
            alertController.addAction(action)
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
}
