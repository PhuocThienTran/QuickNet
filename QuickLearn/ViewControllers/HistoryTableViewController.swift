//
//  HistoryTableViewController.swift
//  QuickNet
//
//  Created by DTran on 12/25/19.
//  Copyright © 2019 TPT. All rights reserved.
//

import UIKit

class HistoryTableViewController: UITableViewController {
    
    
    
    // MARK: - Variables
    
    var history: HistoryViewModelHistory {
        return HistoryViewModelHistory.init()
    }
    
    var language: AppLanguageViewModel {
        return AppLanguageViewModel.init()
    }
    
    var theme: AppThemeViewModel {
        return AppThemeViewModel.init()
    }
    
    weak var delegate: MainViewControllerDelegate?
    
    
    
    // MARK: - @IBOutlet
    
    @IBOutlet weak var barButton: UIBarButtonItem!
    @IBOutlet weak var emptyHistoryImage: UIImageView!
    @IBOutlet weak var emptyHistoryLabel: UILabel!
    @IBOutlet var emptyHistoryView: UIView!
    
    
    
    // MARK: - Override Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
        delegate?.backgroundBlur(isHidden: false)
        delegate?.delegateSetupTextField(isUserInteractionEnabled: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = history.reversedHistoryWords[indexPath.row]
        cell.detailTextLabel?.text = history.reversedHistoryDictionaries[indexPath.row]
        cell.backgroundColor = theme.secondarySystemGroupedBackground
        cell.textLabel?.textColor = theme.label
        tableView.separatorColor = theme.systemGroupedBackground
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.presentWebsite(word: history.reversedHistoryWords[indexPath.row], dictionary: history.reversedHistoryDictionaries[indexPath.row], url: history.reversedHistoryUrls[indexPath.row], language: language, theme: theme)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { action, index in
            self.removeFromHistory(tableView: tableView, indexPath: indexPath)
            self.setupBackgroundView()
            self.setupBarButton()
        }
        let share = UITableViewRowAction(style: .normal, title: "Share") { action, index in
            let shareText = "\(self.language.shareDefinitionText1) \"\(self.history.reversedHistoryWords[indexPath.row])\" \(self.language.shareDefinitionText2)"
            if let cell = tableView.cellForRow(at:IndexPath(row: indexPath.row, section: indexPath.section)) {
                self.presentShareSheet(shareItems: [shareText, URL(string: self.history.reversedHistoryUrls[indexPath.row]) ?? ""], excludedOptions: [.copyToPasteboard, .assignToContact, .openInIBooks, .saveToCameraRoll], source: cell)
            }
            tableView.setEditing(false, animated: true)
        }
        share.backgroundColor = self.view.tintColor
        return [delete, share]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history.historyWords.count
    }
    
    
    
    // MARK: - Configuration
    
    func configuration() {
        setupBackgroundView()
        setupBarButton()
        setupEmptyHistoryViewAndLabel()
        setupTableView()
    }
    
    func setupBackgroundView() {
        tableView.backgroundView = history.historyWords.isEmpty ? emptyHistoryView : nil
    }
    
    func setupBarButton() {
        barButton.isEnabled = history.historyWords.isEmpty ? false : true
    }
    
    func setupEmptyHistoryViewAndLabel() {
        emptyHistoryImage.tintColor = #colorLiteral(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
        emptyHistoryLabel.text = language.itsEmptyInHere
        emptyHistoryView.backgroundColor = theme.systemGroupedBackground
    }
    
    func setupTableView() {
        self.title = language.history
        tableView.backgroundColor = theme.systemGroupedBackground
        tableView.separatorColor = theme.systemGroupedBackground
        tableView.tableFooterView = UIView()
        if #available(iOS 11.0, *) {
            tableView.dragDelegate = self as UITableViewDragDelegate
        }
    }
    
    
    
    // MARK: - Functions
    
    func removeFromHistory(tableView: UITableView, indexPath: IndexPath) {
        
        var updatedWords = history.reversedHistoryWords
        var updatedDictionaries = history.reversedHistoryDictionaries
        var updatedUrls = history.reversedHistoryUrls
        
        updatedWords.remove(at: indexPath.row)
        updatedDictionaries.remove(at: indexPath.row)
        updatedUrls.remove(at: indexPath.row)
        
        defaults.set([Array<String>(updatedWords.reversed()), Array<String>(updatedDictionaries.reversed()), Array<String>(updatedUrls.reversed())], forKeys: [AppDefaults.historyWords, AppDefaults.historyDictionaries, AppDefaults.historyUrls])
        
        tableView.deleteRows(at: [indexPath], with: .left)
        
    }
    
    
    
    // MARK: - @IBAction
    
    @IBAction func clearAll(_ sender: UIBarButtonItem) {
        self.presentAlert(title: language.alert, message: language.clearHistoryText, actionTitles: [language.cancel, language.clearAll], actionStyles: [.cancel, .destructive], actionHandlers: [nil, {action in
            defaults.set([[] as [String], [] as [String], [] as [String]], forKeys: [AppDefaults.historyWords, AppDefaults.historyDictionaries, AppDefaults.historyUrls])
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.setupBackgroundView()
                self.setupBarButton()
            }
            }])
    }
    
    @IBAction func dismiss(_ sender: UIBarButtonItem) {
        delegate?.backgroundBlur(isHidden: true)
        delegate?.delegateConfiguration()
        delegate?.delegateSetupTextField(isUserInteractionEnabled: true)
        dismissViewController()
    }
    
}
