//
//  BestBaseViewController.swift
//  MSinger
//
//  Created by InitialC on 2017/11/27.
//  Copyright © 2017年 InitialC. All rights reserved.
//

import UIKit


class BestBaseViewController: UIViewController {
    @objc public var pageType : Int = 0
    @objc public var isHiddenNavigationBar : Bool = false
    public var popHandler : ((_ className : String)->Void)?
    var currentIsDarkMode : Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if navigationController?.isNavigationBarHidden != isHiddenNavigationBar {
            navigationController?.setNavigationBarHidden(isHiddenNavigationBar, animated: animated)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(updatedSignedStatus), name: NSNotification.Name.init(rawValue: kCNotificationSignedKey), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updatedLogoutStatus), name: NSNotification.Name.init(rawValue: kCNotificationLogoutKey), object: nil)
        super.viewWillAppear(animated)

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        MutaAnalysisService.intoPageMark(self)
    }
    override func viewWillDisappear(_ animated: Bool) {
//        navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init(rawValue: kCNotificationSignedKey), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init(rawValue: kCNotificationLogoutKey), object: nil)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        MutaAnalysisService.goOutPageMark(self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc dynamic func updatedSignedStatus() {
        print("登录状态")
    }
    @objc dynamic func updatedLogoutStatus() {
        print("退出状态")
    }
    
    
    @objc func backWithPop(_ sender : UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    deinit {
        // 清除播放信息
        print("释放了...\(self.classOfName)")
    }

}
// 暗黑模式适配
extension BestBaseViewController {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        // 每次模式改变的时候, 这里都会执行
//        print("黑暗模式改变了")
    }
}
