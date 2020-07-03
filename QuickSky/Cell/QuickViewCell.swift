//
//  QuickViewCell.swift
//  QuickNet
//
//  Created by DTran on 12/13/19.
//  Copyright © 2019 TPT. All rights reserved.
//

import UIKit

class cityCell: UICollectionViewCell
{
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var lblCountry: UILabel!
    
    
    func bind(model: ModeSearchCity) {
        /// update cell
        cityName.text = model.localizedName
        lblCountry.text = model.country?.localizedName
        
    }
    
}
