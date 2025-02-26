//
//  UIViewController+Extension.swift
//  CoinRank
//
//  Created by Ntobeko Sikithi on 2025/02/25.
//

import Foundation
import UIKit

extension UIViewController {
    func showActivityIndicatory() {
        let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
        actInd.frame = CGRect(x: 0.0, y: 0.0, width: 50.0, height: 50.0);
        actInd.center = self.view.center
        actInd.hidesWhenStopped = true
        actInd.style =
            UIActivityIndicatorView.Style.large
        actInd.tag = 111
        self.view.addSubview(actInd)
        actInd.startAnimating()
    }
    
    func hideActivityIndicatory() {
        if let actInd = self.view.viewWithTag(111) {
            actInd.removeFromSuperview()
        }
    }
    
    func showPopup(message: String,
                   actionTitle: String = "Retry",
                   completion: (() -> Void)? = nil) {
        let alert = UIAlertController(
            title: "Something went wrong!",
            message: message,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: actionTitle, style: .default) { _ in
            completion?()
        }
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}
