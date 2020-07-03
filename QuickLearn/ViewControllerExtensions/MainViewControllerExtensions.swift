//
//  MainViewControllerExtensions.swift
//  QuickNet
//
//  Created by DTran on 12/25/19.
//  Copyright © 2019 TPT. All rights reserved.
//

import UIKit

extension MainViewController: MainViewControllerDelegate {
    
    func backgroundBlur(isHidden: Bool) {
        if traitCollection.horizontalSizeClass == .regular {
            if isHidden == true {
                blurEffectView?.isHidden = isHidden
            } else if isHidden == false {
                let blurEffect = UIBlurEffect(style: theme.blurStyle)
                blurEffectView = UIVisualEffectView(effect: blurEffect)
                blurEffectView?.frame = UIScreen.main.bounds
                blurEffectView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                self.navigationController?.view.addSubview(blurEffectView)
                blurEffectView?.isHidden = false
            }
        }
    }
    
    func delegateConfiguration() {
        configuration()
    }
    
    func delegateSetupTextField(isUserInteractionEnabled: Bool) {
        self.textField.isUserInteractionEnabled = isUserInteractionEnabled
    }
    
}

extension MainViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return language.dictionariesName.count
    }
    
}

extension MainViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 120
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 120, height: 100))
        let title = UILabel(frame: CGRect(x: 0, y: view.frame.height - (15 + 1), width: view.frame.width, height: 15))
        title.text = language.dictionariesName[row]
        title.textAlignment = .center
        title.textColor = theme.secondaryLabel
        title.font = UIFont.systemFont(ofSize: 11, weight: .heavy)
        let image = UIImageView(frame: CGRect(x: view.frame.width/2 - 78/2, y: (view.frame.width - (15 + 1 + 30))/2 - 78/2, width: 78, height: 78))
        image.image = language.dictionariesIcon[row]
        image.setShadow(radius: 2.6, color: .white, offset: .zero, opacity: 0.25)
        view.addSubviews([title, image])
        view.transform = CGAffineTransform(rotationAngle: 90 * (.pi/180))
        return view
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        defaults.set(row, forKey: AppDefaults.dictionaryIndex)
    }
  
}

extension MainViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.textFieldView.setShadow(radius: 2.6, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), offset: .zero, opacity: 0.25)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.textFieldView.setShadow(radius: 0, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), offset: .zero, opacity: 0)
    }
    
}
