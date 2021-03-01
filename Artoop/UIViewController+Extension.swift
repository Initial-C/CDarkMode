//
//  UIViewController+Extension.swift
//  MSinger
//
//  Created by InitialC on 2017/11/10.
//  Copyright © 2017年 InitialC. All rights reserved.
//
import Foundation
import UIKit

typealias ViewControllerRequestCompletion = ()->Void
extension UIViewController {
    
    static var ViewControllerRequestCompletionKey = "muta_ViewControllerRequestCompletionKey"
    fileprivate var requestCompletionHandler : ViewControllerRequestCompletion? {
        set {
            objc_setAssociatedObject(self, &UIViewController.ViewControllerRequestCompletionKey, newValue as ViewControllerRequestCompletion?, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            guard let requestCompletionHandler = objc_getAssociatedObject(self, &UIViewController.ViewControllerRequestCompletionKey) as? ViewControllerRequestCompletion else {
                return nil
            }
            return requestCompletionHandler
        }
    }
    /**
     直接加载 xib，创建 ViewController
     
     - returns: UIViewController
     */
    class func initFromNib() -> UIViewController {
        let hasNib: Bool = Bundle.main.path(forResource: self.nameOfClass, ofType: "nib") != nil
        guard hasNib else {
            assert(!hasNib, "Invalid parameter") // here
            return UIViewController()
        }
        return self.init(nibName: self.nameOfClass, bundle: nil)
    }
    
    public static var TopAboveViewController: UIViewController? {
        var presentedVC = UIApplication.shared.keyWindow?.rootViewController
        while let pVC = presentedVC?.presentedViewController {
            presentedVC = pVC
        }
        
        if presentedVC == nil {
            print("Error: You don't have any views set. You may be calling them in viewDidLoad. Try viewDidAppear instead.")
        }
        return presentedVC
    }
    
    fileprivate func ts_pushViewController(_ viewController: UIViewController, animated: Bool, hideTabbar: Bool) {
        viewController.hidesBottomBarWhenPushed = hideTabbar
        self.navigationController?.pushViewController(viewController, animated: animated)
    }
    
    /**
     push
     */
    public func ts_pushAndHideTabbar(_ viewController: UIViewController) {
        self.ts_pushViewController(viewController, animated: true, hideTabbar: true)
    }
    
    /**
     present
     */
    public func ts_presentViewController(_ viewController: UIViewController, completion:(() -> Void)?) {
        let navigationController = UINavigationController(rootViewController: viewController)
        self.present(navigationController, animated: true, completion: completion)
    }
    
    public func requestCompletion() {
        if let handler = self.requestCompletionHandler {
            handler()
        }
    }
    public func requestCompletion(_ handler : @escaping ()->Void) {
        self.requestCompletionHandler = handler
    }
    
}

extension NSObject {
    class var nameOfClass: String {
        return NSStringFromClass(self).components(separatedBy: ".").last! as String
    }
    
    var classOfName: String {
        return String(describing: self.classForCoder)
    }
    
    //用于获取 cell 的 reuse identifier
    class var identifier: String {
        return String(format: "%@_identifier", self.nameOfClass)
    }
    
    
}
