//
//  HistoryExtensions.swift
//  QuickNet
//
//  Created by DTran on 12/25/19.
//  Copyright © 2019 TPT. All rights reserved.
//

import UIKit

extension HistoryTableViewController: UITableViewDragDelegate {
    
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        if let url = NSURL(string: history.reversedHistoryUrls[indexPath.row]) {
            let itemProviderURL = NSItemProvider(object: url)
            let dragItemURL = UIDragItem(itemProvider: itemProviderURL)
            return [dragItemURL]
        } else {
            return []
        }
    }
    
}
