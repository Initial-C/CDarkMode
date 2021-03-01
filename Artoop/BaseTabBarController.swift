//
//  BaseTabBarController.swift
//  Artoop
//
//  Created by EROMANGA on 2021/2/2.
//  Copyright © 2021 Artoop. All rights reserved.
//

import UIKit

class BaseTabBarController: UITabBarController {
    fileprivate var lastViewController : UIViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        addAllChildVC()
        setUpTabBar()
        self.delegate = self
        lastViewController = self.children.first
        
    }
    func setUpTabBar() {
        self.tabBar.isTranslucent = false
        self.tabBar.backgroundColor = kNaviColor
        self.tabBar.tintColor = kNaviColor
        self.tabBar.backgroundImage = UIImage.init(color: UIColor.white, size: CGSize.init(width: kZWScreenW, height: kZWTabBarH))
        self.tabBar.shadowImage = UIImage.init(color: UIColor.init("#eee"), size: CGSize.init(width: kZWScreenW, height: 0.5))
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    

}

extension BaseTabBarController {
    func addAllChildVC() {
        // 添加
        addOneChildVC(MainViewController(), nil, nil, "我的课程")
        addOneChildVC(MineViewController(), nil, nil, "我的")
    }
    func addOneChildVC(_ vc : UIViewController?, _ image : UIImage?, _ selectImage : UIImage?, _ title : String?) {
        let nav = BaseNavigationController.init(rootViewController: vc!)
        nav.tabBarItem.title = NSLocalizedString(title ?? "", comment: "")
        nav.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.init("#333"), NSAttributedString.Key.font : UIFont.systemFont(ofSize: 9)], for: .normal)
        nav.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.init("#333")], for: .selected)
        let oriImg = image?.withRenderingMode(.alwaysOriginal)
        nav.tabBarItem.image = oriImg
        let oriSelImg = selectImage?.withRenderingMode(.alwaysOriginal)
        nav.tabBarItem.selectedImage = oriSelImg
        nav.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -1)
//        if vc!.isKind(of: MTMessageController.self) {
//            messageItem = nav.tabBarItem
//            if #available(iOS 10.0, *) {
//                nav.tabBarItem.badgeColor = UIColor.init("#ffaa00")
////                let attri = [NSAttributedStringKey.foregroundColor.rawValue : UIColor.init("#ffcc00")]
////                nav.tabBarItem.setBadgeTextAttributes(attri, for: .normal)
//            }
//        }
        self.addChild(nav)
    }
}
// MARK: - 监听tabBar点击事件代理
extension BaseTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//        guard let topViewC = (viewController as? UINavigationController)?.topViewController else { return }
        if lastViewController! == viewController {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: kCNotificationReloadListKey), object: nil)
        }
        lastViewController = viewController
    }
}
