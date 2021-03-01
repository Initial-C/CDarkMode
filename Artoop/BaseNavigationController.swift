//
//  BaseNavigationController.swift
//  Artoop
//
//  Created by EROMANGA on 2021/2/2.
//  Copyright © 2021 Artoop. All rights reserved.
//

import Foundation
import UIKit

@objc(MutaNavigationController)
class BaseNavigationController: UINavigationController, UIGestureRecognizerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationBar.barTintColor = kNaviColor
        if #available(iOS 11.0, *) {
            (UINavigationBar.appearance()).isTranslucent = false
        } else {
            // Fallback on earlier versions
            navigationBar.isTranslucent = false
        }
//        setNavigationbarColorClear(false, navigationBar, nil)
        // attribute
        let attri = [NSAttributedString.Key.font: UIFont.init(name: kMediumFont, size: 18)!, NSAttributedString.Key.foregroundColor : kNaviTintColor]
        self.navigationBar.titleTextAttributes = attri
        // Do any additional setup after loading the view.
        self.interactivePopGestureRecognizer?.delegate = self
        //
        self.navigationBar.shadowImage = UIImage.init()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//        if let topVC = self.topViewController {
//            if (topVC.isKind(of: MutaPlayerViewController.self)
//                || topVC.isKind(of: MusicPaddingController.self)
//                || topVC.isKind(of: MusicFigureController.self)
//                || topVC.isKind(of: MusicFinalController.self)
//                || topVC.isKind(of: MTKTVCompleteController.self)
//                || topVC.isKind(of: MTMyDraftPageController.self)) {
//                return false
//            }
//        }
        return children.count > 1
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if children.count != 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
//        if children.count >= 1 {
//            let backBtn = UIButton.init(type: .custom)
//            backBtn.setImage(kDefaultNaviBackIcon, for: .normal)
//            backBtn.sizeToFit()
//            backBtn.addTarget(self, action: #selector(back), for: .touchUpInside)
//            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: backBtn)
//        }
//        if let topVC = self.topViewController, topVC.isKind(of: MutaPlayerViewController.self), viewController.isKind(of: MutaPlayerViewController.self)  {
//            return
//        }
        super.pushViewController(viewController, animated: animated)
    }
    override var prefersStatusBarHidden: Bool {
        let topVC = self.topViewController
        if let isHideStatus = topVC?.prefersStatusBarHidden {
            return isHideStatus
        }
        return false
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        let topVC = self.topViewController
        if let statusBarType = topVC?.preferredStatusBarStyle {
            return statusBarType
        }
        return .default
    }
//    @available(iOS 13.0, *)
//    override var overrideUserInterfaceStyle: UIUserInterfaceStyle {
//        get {
//            return .light
//        }
//        set {
//
//        }
//    }
    @objc fileprivate func back() {
        self.popViewController(animated: true)
    }
    
}
