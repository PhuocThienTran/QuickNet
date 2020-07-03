//
//  UIViewControllerExtension.swift
//  QuickNet
//
//  Created by DTran on 12/25/19.
//  Copyright © 2019 TPT. All rights reserved.
//

import SafariServices
import UIKit

extension UIViewController {
    
    func dismissViewController(animated: Bool = true, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            self.dismiss(animated: animated, completion: completion)
        }
    }
    
    func presentViewController(_ viewController: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            self.present(viewController, animated: animated, completion: completion)
        }
    }
    
    func presentShareSheet(shareItems: [Any], excludedOptions: [UIActivity.ActivityType], source: NSObject) {
        let activityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        activityViewController.excludedActivityTypes = excludedOptions
        if let source = source as? UIView {
            activityViewController.popoverPresentationController?.sourceView = source
            activityViewController.popoverPresentationController?.sourceRect = source.bounds
        } else if let source = source as? UIBarButtonItem {
            activityViewController.popoverPresentationController?.barButtonItem = source
        }
        presentViewController(activityViewController)
    }
    
    func presentAlert(title: String, message: String, actionTitles: [String], actionStyles: [UIAlertAction.Style]? = nil, actionHandlers: [((UIAlertAction) -> Void)?]? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if (actionTitles.count == actionStyles?.count || actionStyles == nil) && (actionStyles?.count == actionHandlers?.count || actionHandlers == nil) {
            for index in 0..<actionTitles.count {
                alert.addAction(UIAlertAction(title: actionTitles[index], style: actionStyles?[index] ?? .default, handler: actionHandlers?[index] ?? nil))
            }
        } else {
            fatalError("The number of values for actionTitles, newActionStyles and newActionHandlers are not equal.")
        }
        presentViewController(alert)
    }
    
    func presentWebsite(word: String, dictionary: String, url: String, language: AppLanguageViewModel, theme: AppThemeViewModel) {
        var viewController: UIViewController
        if #available(iOS 11.0, *), let url = URL(string: url) {
            let safariViewController = SFSafariViewController(url: url, configuration: SFSafariViewController.Configuration())
            safariViewController.modalPresentationCapturesStatusBarAppearance = true
            safariViewController.preferredBarTintColor = theme.systemBackground
            safariViewController.preferredControlTintColor = #colorLiteral(red: 1, green: 0.3490196078, blue: 0.3176470588, alpha: 1)
            viewController = safariViewController
        } else {
            AppProperties.searchData = (word: word, dictionary: dictionary, url: url)
            viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NavWebKitID")
        }
        if !Reachability.isConnectedToNetwork() {
            presentAlert(title: language.error, message: language.checkInternetText, actionTitles: [language.close], actionStyles: [.default])
        } else {
            viewController.modalPresentationStyle = .overFullScreen
            presentViewController(viewController)
        }
    }
    
}
