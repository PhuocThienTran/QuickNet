//
//  ContactViewController.swift
//  QuickNet
//
//  Created by DTran on 1/19/20.
//  Copyright © 2020 TPT. All rights reserved.
//

import UIKit
import MessageUI
import SafariServices

class ContactUsViewController: UIViewController{

    @IBAction func emailButtonTapped(_ sender: Any) {
        // This needs to be ran on a device
        showMailComposer()
    }
    
    func showMailComposer() {
        
        guard MFMailComposeViewController.canSendMail() else {
            //Show alert informing the user
            return
        }
        
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        composer.setToRecipients(["donnyquickinc@gmail.com"])
        composer.setSubject("QuickNet Inquiry")
        composer.setMessageBody("This Email will be directly sent to Quick Apps regarding QuickNet. If this is about an another inquiry, please state clearly what it is below this auto-generated message and in the Email's subject. We will respond to you as soon as possible. Thank You.", isHTML: false)
        
        present(composer, animated: true)
    }
}


extension ContactUsViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        if let _ = error {
            //Show error alert
            controller.dismiss(animated: true)
            return
        }
        
        switch result {
        case .cancelled:
            print("Cancelled")
        case .failed:
            print("Failed to send")
        case .saved:
            print("Saved")
        case .sent:
            print("Email Sent")
        @unknown default:
            break
        }
        
        controller.dismiss(animated: true)
    }
}
