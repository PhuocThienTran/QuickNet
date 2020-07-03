//
//  MainViewController.swift
//  QuickNet
//
//  Created by DTran on 12/25/19.
//  Copyright © 2019 TPT. All rights reserved.
//

import SafariServices
import StoreKit
import UIKit

class MainViewController: UIViewController {
    
    
    
    // MARK: - Variables
    
    var history: MainViewModelHistory {
        return MainViewModelHistory.init()
    }
    
    var language: AppLanguageViewModel {
        return AppLanguageViewModel.init()
    }
    
    var theme: AppThemeViewModel {
        return AppThemeViewModel.init()
    }
    
    var blurEffectView: UIVisualEffectView!
    var historyOneUrl: String!
    var historyTwoUrl: String!
    
    
    
    // MARK: - @IBOutlet
    
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var textFieldView: UIView!
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var historyAndLanguageView: UIView!
    @IBOutlet weak var historyLabel: UILabel!
    @IBOutlet weak var historyView: UIView!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var languageView: UIView!
    
    @IBOutlet weak var historyOneDictionaryLabel: UILabel!
    @IBOutlet weak var historyOneView: UIView!
    @IBOutlet weak var historyOneWordLabel: UILabel!
    
    @IBOutlet weak var historyTwoDictionaryLabel: UILabel!
    @IBOutlet weak var historyTwoView: UIView!
    @IBOutlet weak var historyTwoWordLabel: UILabel!
    
    
    
    // MARK: - Override Functions & Variables
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
        modifyDefaultsValues()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupGradients()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        textField.resignFirstResponder()
        textFieldDidEndEditing(textField)
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navigationController = segue.destination as? UINavigationController {
            if let viewController = navigationController.topViewController as? SettingsTableViewController {
                viewController.delegate = self
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    
    // MARK: - Configuration
    
    func configuration() {
        setupHistoryAndLanguageLabels()
        setupHistoryAndLanguageViews()
        setupHistoryOneLabels()
        setupHistoryOneView()
        setupHistoryTwoLabels()
        setupHistoryTwoView()
        setupPicker()
        setupTextField()
        setupTextFieldView()
        setupView()
    }
    func setupHistoryAndLanguageLabels() {
        historyLabel.text = language.history
        languageLabel.text = language.language
    }
    
    func setupHistoryAndLanguageViews() {
        historyView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(presentHistoryViewController)))
        languageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(presentLanguageViewController)))
        historyAndLanguageView.layer.cornerRadius = 20
        historyAndLanguageView.setShadow(radius: 6, color: theme.label, offset: .zero, opacity: 0.16)
    }
    
    func setupGradients() {
        historyAndLanguageView.setGradient(with: [#colorLiteral(red: 1, green: 0.7764705882, blue: 0.2745098039, alpha: 1), #colorLiteral(red: 1, green: 0.8235294118, blue: 0.3254901961, alpha: 1)], stopPoints: [0.0, 1.0])
        historyOneView.setGradient(with: [#colorLiteral(red: 0.4, green: 0.8, blue: 0.8980392157, alpha: 1), #colorLiteral(red: 0.4980392157, green: 0.8980392157, blue: 1, alpha: 1)], stopPoints: [0.0, 1.0])
        historyTwoView.setGradient(with: [#colorLiteral(red: 0.4980392157, green: 0.8, blue: 0.6, alpha: 1), #colorLiteral(red: 0.6, green: 0.8980392157, blue: 0.6980392157, alpha: 1)], stopPoints: [0.0, 1.0])
    }
    
    func setupHistoryOneLabels() {
        historyOneWordLabel.text = history.firstHistoryWord
        historyOneDictionaryLabel.text = history.firstHistoryDictionary
        historyOneUrl = history.firstHistoryUrl
    }
    
    func setupHistoryOneView() {
        historyOneView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(presentHistory(sender:))))
        historyOneView.isHidden = history.isFirstEmpty
        historyOneView.layer.cornerRadius = 20
        historyOneView.setShadow(radius: 6, color: theme.label, offset: .zero, opacity: 0.16)
    }
    
    func setupHistoryTwoLabels() {
        historyTwoWordLabel.text = history.secondHistoryWord
        historyTwoDictionaryLabel.text = history.secondHistoryDictionary
        historyTwoUrl = history.secondHistoryUrl
    }
    
    func setupHistoryTwoView() {
        historyTwoView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(presentHistory(sender:))))
        historyTwoView.isHidden = history.isSecondEmpty
        historyTwoView.layer.cornerRadius = 20
        historyTwoView.setShadow(radius: 6, color: theme.label, offset: .zero, opacity: 0.16)
    }
    
    func setupPicker() {
        picker.delegate = self
        picker.dataSource = self
        let pickerY = picker.frame.origin.y
        picker.selectRow(defaults.integer(forKey: AppDefaults.dictionaryIndex), inComponent: 0, animated: false)
        picker.transform = CGAffineTransform(rotationAngle: -90 * (.pi/180))
        picker.frame = CGRect(x: 0, y: pickerY, width: view.frame.width, height: 100)
        picker.autoresizingMask = [.flexibleWidth]
        picker.reloadAllComponents()
    }
    
    func setupTextField() {
        textField.delegate = self
        textField.keyboardAppearance = theme.keyboardAppearence
    }
    
    
    func setupTextFieldView() {
        textFieldView.layer.cornerRadius = 10
        textFieldView.layer.borderWidth = 0
    }
    
    func setupView() {
        self.title = language.dictionary
        view.backgroundColor = theme.systemBackground
        view.endEditing(true)
    }
    
    
    
    // MARK: - Functions
    
    @available(iOS 10.3, *)
    func requestReview() {
        let numberOfSearches = defaults.integer(forKey: AppDefaults.numberOfSearches)
        switch numberOfSearches {
        case 10, 20, 40, 80:
            SKStoreReviewController.requestReview()
        case _ where numberOfSearches % 100 == 0:
            SKStoreReviewController.requestReview()
        default:
            break
        }
    }
    
    @objc func presentHistory(sender: UITapGestureRecognizer) {
        if sender.view == historyOneView {
            self.presentWebsite(word: historyOneWordLabel.text ?? history.firstHistoryWord, dictionary: historyOneDictionaryLabel.text ?? history.firstHistoryDictionary, url: historyOneUrl, language: language, theme: theme)
        } else if sender.view == historyTwoView {
            self.presentWebsite(word: historyTwoWordLabel.text ?? history.secondHistoryWord, dictionary: historyTwoDictionaryLabel.text ?? history.secondHistoryDictionary, url: historyTwoUrl, language: language, theme: theme)
        }
    }
    
    @objc func presentHistoryViewController() {
        if let navigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NavHistoryID") as? UINavigationController, let viewController = navigationController.topViewController as? HistoryTableViewController {
            viewController.delegate = self
            presentViewController(navigationController)
        }
    }
    
    @objc func presentLanguageViewController() {
        if let navigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NavLanguageID") as? UINavigationController, let viewController = navigationController.topViewController as? LanguageTableViewController {
            viewController.delegate = self
            presentViewController(navigationController)
        }
    }
    
    func addToHistory(word: String, url: String) {
        var historyWord = defaults.array(forKey: AppDefaults.historyWords) as? [String] ?? [String]()
        var historyDictionary = defaults.array(forKey: AppDefaults.historyDictionaries) as? [String] ?? [String]()
        var historyUrl = defaults.array(forKey: AppDefaults.historyUrls) as? [String] ?? [String]()
        if historyWord.contains(word) && historyDictionary.contains(language.dictionariesName[self.picker.selectedRow(inComponent: 0)]) && historyUrl.contains(url) {
            if let index = historyUrl.index(of: url) {
                historyWord.remove(at: index)
                historyDictionary.remove(at: index)
                historyUrl.remove(at: index)
            }
        }
        historyWord.append(word)
        historyDictionary.append(language.dictionariesName[self.picker.selectedRow(inComponent: 0)])
        historyUrl.append(url)
        defaults.set([historyWord, historyDictionary, historyUrl], forKeys: [AppDefaults.historyWords, AppDefaults.historyDictionaries, AppDefaults.historyUrls])
        configuration()
    }
    
    func modifyDefaultsValues() {
        if defaults.value(forKey: "historyWord") != nil {
            defaults.set(defaults.value(forKey: "historyWord"), forKey: AppDefaults.historyWords)
            defaults.removeObject(forKey: "historyWord")
        }
        if defaults.value(forKey: "historyDictionary") != nil {
            defaults.set(defaults.value(forKey: "historyDictionary"), forKey: AppDefaults.historyDictionaries)
            defaults.removeObject(forKey: "historyDictionary")
        }
        if defaults.value(forKey: "historyUrl") != nil {
            defaults.set(defaults.value(forKey: "historyUrl"), forKey: AppDefaults.historyUrls)
            defaults.removeObject(forKey: "historyUrl")
        }
        if defaults.value(forKey: "wkWord") != nil {
            defaults.removeObject(forKey: "wkWord")
        }
        if defaults.value(forKey: "wkDictionary") != nil {
            defaults.removeObject(forKey: "wkDictionary")
        }
        if defaults.value(forKey: "wkUrl") != nil {
            defaults.removeObject(forKey: "wkUrl")
        }
    }
    
    func searchWeb(input: String) {
        if input.isEmpty || input.count >= 100 {
            self.presentAlert(title: language.error, message: language.enterAValidWordText, actionTitles: [language.close])
        } else {
            defaults.set(defaults.integer(forKey: AppDefaults.numberOfSearches) + 1, forKey: AppDefaults.numberOfSearches)
            let inputDictionary = language.dictionariesName[self.picker.selectedRow(inComponent: 0)]
            let websiteUrl = language.dictionariesWebsite[self.picker.selectedRow(inComponent: 0)] + input.websiteCompatibility(dictionary: inputDictionary)
            self.addToHistory(word: input.lowercased().capitalized.trimmingCharacters(in: .whitespacesAndNewlines), url: websiteUrl)
            self.presentWebsite(word: input.lowercased().capitalized.trimmingCharacters(in: .whitespacesAndNewlines), dictionary: inputDictionary, url: websiteUrl, language: language, theme: theme)
        }
    }
    
    
    
    // MARK: - @IBAction
    
    @IBAction func clearTextField(_ sender: UIButton) {
        if textField.text == "" {
            textField.resignFirstResponder()
        } else {
            textField.text = ""
        }
    }
    
    @IBAction func textFieldRetrunKey(_ sender: Any) {
        searchWeb(input: textField.text ?? "")
    }
    
    @IBAction func searchWeb(_ sender: UIButton) {
        searchWeb(input: textField.text ?? "")
    }
    
}
