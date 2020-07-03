//  SettingsTableViewController.swift
//  QuickNet
//
//  Created by DTran on 12/25/19.
//  Copyright © 2019 TPT. All rights reserved.
//

import SafariServices
import UIKit

class SettingsTableViewController: UITableViewController {
    

    
    // MARK: - Variables
    
    var language: AppLanguageViewModel {
        return AppLanguageViewModel.init()
    }
    
    var theme: AppThemeViewModel {
        return AppThemeViewModel.init()
    }
    
    weak var delegate: MainViewControllerDelegate?
    
    
    
    // MARK: - @IBOutlet
    
    @IBOutlet weak var appCell: UITableViewCell!
    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var appVersionLabel: UILabel!
    @IBOutlet weak var footerCell: UITableViewCell!
    @IBOutlet weak var footerLabel1: UILabel!
    @IBOutlet weak var footerLabel2: UILabel!
    @IBOutlet weak var privacyPolicyCell: UITableViewCell!

    
    
    
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if privacyPolicyCell.isSelected {
            self.presentWebsite(word: "Privacy Policy", dictionary: "QuickNet-3.1", url: "https://sites.google.com/view/quick-apps/Privacy", language: language, theme: theme)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = cell == footerCell ? theme.systemGroupedBackground : theme.secondarySystemGroupedBackground
        cell.imageView?.tintColor = #colorLiteral(red: 0.5723067522, green: 0.5723067522, blue: 0.5723067522, alpha: 1)
        cell.textLabel?.textColor = theme.label
        cell.selectionStyle = cell == appCell || cell == footerCell ? .none : .default
        tableView.separatorColor = theme.systemGroupedBackground
    }
    
    
    
    // MARK: - Configuration
    
    func configuration() {
        setupAppNameLabel()
        setupAppVersionLabel()
        setupCells()
        setupFooterLabels()
        setupTableView()
        
    }
    
    func setupAppNameLabel() {
        appNameLabel.textColor = theme.label
    }
    
    func setupAppVersionLabel() {
        appVersionLabel.text = "\(language.versionText) (\(Bundle.main.buildNumber ?? "123"))"
        appVersionLabel.textColor = theme.label
    }
    
    func setupCells() {
        privacyPolicyCell.textLabel?.text = language.privacyPolicy
    }
    
    func setupFooterLabels() {
        footerLabel1.textColor = .red
        footerLabel2.textColor = theme.secondaryLabel
    }
    
    func setupTableView() {
        self.title = language.settings
        tableView.backgroundColor = theme.systemGroupedBackground
        tableView.separatorColor = theme.systemGroupedBackground
    }
    
    
    
    
    // MARK: - @IBAction
    
    @IBAction func dismiss(_ sender: UIBarButtonItem) {
        delegate?.backgroundBlur(isHidden: true)
        delegate?.delegateConfiguration()
        delegate?.delegateSetupTextField(isUserInteractionEnabled: true)
        dismissViewController()
    }

}
