//
//  QuickTap.swift
//  QuickNet
//
//  Created by DTran on 12/11/19.
//  Copyright © 2019 TPT. All rights reserved.
//

import UIKit

class QuickTap: UIViewController {
    @IBOutlet weak var bottonLabel: UILabel!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var endTopLabel: UILabel!
    @IBOutlet weak var endBottomLabel: UILabel!
    @IBOutlet weak var endBtn: UIButton!
    
    var score = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topLabel.text = "\(score)"
        bottonLabel.text = "\(score)"
        
        endBtn.isHidden = true
        endTopLabel.isHidden = true
        endBottomLabel.isHidden = true
        
        topLabel.transform = CGAffineTransform(rotationAngle: 3.14)
        endTopLabel.transform = CGAffineTransform (rotationAngle: 3.14)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func topBtn(_ sender: Any) {
        score += 1
        topLabel.text = "\(score)"
        bottonLabel.text = "\(score)"
        testScore()
    }
    @IBAction func bottomBtn(_ sender: Any) {
        score -= 1
        topLabel.text = "\(score)"
        bottonLabel.text = "\(score)"
        testScore()
    }
    
    func testScore (){
        if score>=10 {
            
            
            endBtn.isHidden = false
            endTopLabel.isHidden = false
            endBottomLabel.isHidden = false
            
            endTopLabel.text = "Winner"
            endBottomLabel.text = "Loser"
            
        } else if score <= -10 {
            
            
            endBtn.isHidden = false
            endTopLabel.isHidden = false
            endBottomLabel.isHidden = false
            
            endTopLabel.text = "Loser"
            endBottomLabel.text = "Winner"
    
    }
    
}
    @IBAction func endBtn(_ sender: Any) {
        
        endBtn.isHidden = true
        endTopLabel.isHidden = true
        endBottomLabel.isHidden = true
        
        score = 0
        topLabel.text = "\(score)"
        bottonLabel.text = "\(score)"
        
    }
    
   }
