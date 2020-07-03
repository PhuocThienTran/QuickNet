//
//  WebKitViewController.swift
//  QuickNet
//
//  Created by DTran on 12/25/19.
//  Copyright © 2019 TPT. All rights reserved.
//

import UIKit
import WebKit

class WebKitViewController: UIViewController {
    
    
    
    // MARK: - Constants
    
    let searchData = AppProperties.searchData
    
    
    
    // MARK: - Variables
    
    var language: AppLanguageViewModel {
        return AppLanguageViewModel.init()
    }
    
    var theme: AppThemeViewModel {
        return AppThemeViewModel.init()
    }
    
    var webView: WKWebView!

    
    
    
    // MARK: - @IBOutlet
    
    @IBOutlet weak var backBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var forwardBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var refreshBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var shareBarButtonItem: UIBarButtonItem!
    
    
    
    
    // MARK: - Override Functions

    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if traitCollection.horizontalSizeClass == .compact {
            (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .allButUpsideDown
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if traitCollection.horizontalSizeClass == .compact {
            (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .portrait
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(WKWebView.isLoading) {
            backBarButtonItem.isEnabled = webView.canGoBack
            forwardBarButtonItem.isEnabled = webView.canGoForward
        }
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            progressView.isHidden = webView.estimatedProgress == 1
            progressView.setProgress(Float(webView.estimatedProgress), animated: false)
        }
    }
    
    
    
    // MARK: - Configuration
    
    func configuration() {
        setupView()
        setupWebView()
    }
    
    func setupView() {
        if let word = searchData?.word, let dictionary = searchData?.dictionary {
            self.title = word + " - " + dictionary
        } else {
            self.title = language.dictionary
        }
        view.backgroundColor = theme.systemBackground
    }
    
    func setupWebView() {
        if let stringUrl = searchData?.url, let url = URL(string: stringUrl) {
            webView = WKWebView()
            webView.addObserver(self, forKeyPath: #keyPath(WKWebView.isLoading), options: .new, context: nil)
            webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
            webView.allowsBackForwardNavigationGestures = true
            webView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            webView.backgroundColor = theme.systemBackground
            webView.load(URLRequest(url: url))
            webView.navigationDelegate = self
            webView.frame = self.view.bounds
            view.insertSubview(webView, belowSubview: progressView)
        }
    }
    
    
    
    // MARK: - @IBAction
    
    @IBAction func dismiss(_ sender: UIBarButtonItem) {
        progressView.setProgress(0, animated: false)
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.isLoading))
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress))
        dismissViewController()
    }
    
    @IBAction func goBack(_ sender: Any) {
        webView.goBack()
    }
    
    @IBAction func goForward(_ sender: Any) {
        webView.goForward()
    }
    
    @IBAction func refresh(_ sender: Any) {
        webView.reload()
    }
    
    @IBAction func share(_ sender: UIBarButtonItem) {
        let shareText = searchData?.dictionary != "Yaacoub" ? "\(language.shareDefinitionText1) \"\(searchData?.word ?? "")\" \(language.shareDefinitionText2)" : ""
        self.presentShareSheet(shareItems: [shareText, searchData?.url ?? ""], excludedOptions: [.copyToPasteboard, .assignToContact, .openInIBooks, .saveToCameraRoll], source: shareBarButtonItem)
    }
    
}
