//
//  LanguageTableViewController.swift
//  QuickNet
//
//  Created by DTran on 12/25/19.
//  Copyright © 2019 TPT. All rights reserved.
//

import UIKit

class LanguageTableViewController: UITableViewController {
    
    
    
    // MARK: - Variables
    
    var language: AppLanguageViewModel {
        return AppLanguageViewModel.init()
    }
    
    var theme: AppThemeViewModel {
        return AppThemeViewModel.init()
    }
    
    weak var delegate: MainViewControllerDelegate?
    
    
    
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return language.languages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = theme.secondarySystemGroupedBackground
        cell.textLabel?.textColor = theme.label
        cell.textLabel?.text = language.languages[indexPath.row]
        for index in 0..<language.languages.count {
            if language.languagesAlpha2[index] == defaults.string(forKey: AppDefaults.language) {
                cell.accessoryType = index == indexPath.row ? .checkmark : .none
                break
            }
        }
        tableView.separatorColor = theme.systemGroupedBackground
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        for row in 0 ..< tableView.numberOfRows(inSection: indexPath.section) {
            if let cell = tableView.cellForRow(at:IndexPath(row: row, section: indexPath.section)) {
                cell.accessoryType = row == indexPath.row ? .checkmark : .none
                if row == indexPath.row {
                    defaults.set([0, language.languagesAlpha2[indexPath.row]], forKeys: [AppDefaults.dictionaryIndex, AppDefaults.language])
                }
                DispatchQueue.main.async {
                    self.configuration()
                }
            }
        }
        
    }
    
    
    
    // MARK: - Configuration
    
    func configuration() {
        setupTableView()
    }
    
    func setupTableView() {
        self.title = language.language
        tableView.backgroundColor = theme.systemGroupedBackground
        tableView.separatorColor = theme.systemGroupedBackground
        tableView.tableFooterView = UIView()
    }
    
    
    
    // MARK: - @IBAction
    
    @IBAction func dismiss(_ sender: UIBarButtonItem) {
        delegate?.backgroundBlur(isHidden: true)
        delegate?.delegateConfiguration()
        delegate?.delegateSetupTextField(isUserInteractionEnabled: true)
        dismissViewController()
    }

}
