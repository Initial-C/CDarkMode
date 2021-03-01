//
//  ViewController.swift
//  Artoop
//
//  Created by EROMANGA on 2021/2/1.
//  Copyright © 2021 Artoop. All rights reserved.
//

import UIKit

class MainViewController: BestBaseViewController {
    
    @IBOutlet weak var followSwitch: UISwitch!
    @IBOutlet weak var normalSwitch: UISwitch!
    @IBOutlet weak var darkSwitch: UISwitch!
    @IBOutlet weak var modeLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            followSwitch.isOn = SettingConfig.style.mode == .unspecified
        }
        modeLabel.textColor = UIColor.init("#ffcc00")
        updateSwitch()
        // Do any additional setup after loading the view.
    }
    @IBAction func actionFollow(_ sender: UISwitch) {
        SettingConfig.setDarkMode(sender.isOn ? .none : SettingConfig.isCurrentDarkMode ? .dark : .light)
        updateSwitch()
    }
    @IBAction func normalAction(_ sender: UISwitch) {
        if followSwitch.isOn { return }
        if !sender.isOn {
            sender.isOn = true
            return
        }
        SettingConfig.setDarkMode(.light)
        darkSwitch.isOn = false
    }
    @IBAction func darkAction(_ sender: UISwitch) {
        if followSwitch.isOn { return }
        if !sender.isOn {
            sender.isOn = true
            return
        }
        SettingConfig.setDarkMode(.dark)
        normalSwitch.isOn = false
    }
    
    func updateSwitch() {
        if followSwitch.isOn {
            normalSwitch.isEnabled = false
            darkSwitch.isEnabled = false
            normalSwitch.isOn = false
            darkSwitch.isOn = false
        } else {
            normalSwitch.isEnabled = true
            darkSwitch.isEnabled = true
            normalSwitch.isOn = SettingConfig.style == .light
            darkSwitch.isOn = SettingConfig.style == .dark
        }
    }
    
}

