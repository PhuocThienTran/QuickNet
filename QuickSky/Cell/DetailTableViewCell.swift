//
//  DetailTableViewCell.swift
//  QuickNet
//
//  Created by DTran on 12/13/19.
//  Copyright © 2019 TPT. All rights reserved.
//

import UIKit

class DetailTableView: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var maxDegree: UILabel!
    @IBOutlet weak var minDegree: UILabel!
    @IBOutlet weak var dayIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
