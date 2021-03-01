//
//  Universal.swift
//  Artoop
//
//  Created by EROMANGA on 2021/2/1.
//  Copyright © 2021 Artoop. All rights reserved.
//

import Foundation
import UIKit
import UIColor_Hex_Swift
import MJRefresh
import YYWebImage

let kCNotificationLogoutKey = "reloadAndShowLogout"
let kCNotificationSignedKey = "reloadAndShowSigned"
let kCNotificationReloadListKey = "muta_reloadListData"       // 用于tab bar重复点击
let kCNotificationStatusBarClickKey = "StatusBarDidClickedNotificationName" // statusBar点击

let kNaviColor = UIColor.init("#FFF")
let kNaviOldColor = UIColor.init("#22252a")
let kMainBackColor = UIColor.init("#f7f7f7")
let kMainTintColor = UIColor.init("#ffcc00") // ZWColor(r: 255, g: 204, b: 0, a: 1.0)
let kRefreshTintColor = UIColor.init("#333")
let kCuttingLineColor = UIColor.init("#eee")
let kNaviTintColor = UIColor.init("#333")
let kMainTextColor = UIColor.init("#333")
let kDefaultNaviShadowImage = UIImage.init(color: UIColor.init(white: 0.0, alpha: 0.3), size: CGSize.init(width: kZWScreenW, height: 0.5))
// font
let kSemiboldFont = "PingFangSC-Semibold"
let kMediumFont = "PingFangSC-Medium"
let kRegularFont = "PingFangSC-Regular"
// size
let kZWScreenW = UIScreen.main.bounds.size.width
let kZWScreenH = UIScreen.main.bounds.size.height
let kZWScreenBounds = UIScreen.main.bounds
let kIsIPhoneXSpec = kZWScreenH/kZWScreenW > 1.8
let kZWNavH : CGFloat = kIsIPhoneXSpec ? 88 : 64
let kZWTabBarH : CGFloat = kIsIPhoneXSpec ? 83 : 49
let kIsSpecNavInset : CGFloat = kIsIPhoneXSpec ? 44 : 20
let kIsSpecNavMargin : CGFloat = kIsIPhoneXSpec ? 44 : 0
let kIsSpecTabMargin : CGFloat = kIsIPhoneXSpec ? 34 : 0
let kZWCenter = CGPoint.init(x: kZWScreenW * 0.5, y: kZWScreenH * 0.5)
let kSizeRatio = UIScreen.main.scale
// ratio
let kIPhoneHeightRatio = kZWScreenH / 667
let kIPhoneWidthRatio = kZWScreenW / 375
let kIPhoneXWidthRatio = kIsIPhoneXSpec ? 1.0 : kIPhoneWidthRatio
let kIPhoneXHeightRatio = kIsIPhoneXSpec ? 1.0 : kIPhoneHeightRatio

func kConvertHeight(_ h : CGFloat) -> CGFloat {
    return kIPhoneXHeightRatio * h
}
func kConvertWidth(_ w : CGFloat) -> CGFloat {
    return kIPhoneXWidthRatio * w
}
func kConvertX(_ x : CGFloat) -> CGFloat {
    return kIPhoneXWidthRatio * x
}
func kConvertY(_ y : CGFloat) -> CGFloat {
    return kIPhoneXHeightRatio * y
}

let kIPhoneUsefulHeight = kZWScreenH - kIsSpecNavMargin - kIsSpecTabMargin

func keyWindow() -> UIWindow? {
    if #available(iOS 13.0, *) {
        let window = UIApplication.shared.connectedScenes
        .filter({$0.activationState == .foregroundActive})
        .map({$0 as? UIWindowScene})
        .compactMap({$0})
        .first?.windows
        .filter({$0.isKeyWindow}).first
        return window
    } else {
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        return window
    }
}

func getCurrentVC() -> UIViewController? {
    if let rootViewController = keyWindow()?.rootViewController {
        let currentVC = getCurrentFrom(rootViewController)
        return currentVC
    } else {
        return nil
    }
}
func getCurrentFrom(_ rootVC : UIViewController) -> UIViewController {
    var rootVCC = rootVC
    var currentVC : UIViewController
    if rootVC.presentedViewController != nil {
        rootVCC = rootVC.presentedViewController!
    }
    if rootVCC.isKind(of: UITabBarController.self) {
        if let selectedVC = (rootVCC as! UITabBarController).selectedViewController {
            currentVC = getCurrentFrom(selectedVC)
        } else {
            currentVC = rootVCC
        }
    } else if rootVCC.isKind(of: UINavigationController.self){
        currentVC = getCurrentFrom((rootVCC as! UINavigationController).visibleViewController!)
    } else {
        currentVC = rootVCC;
    }
    return currentVC
}

/// 根据字符串/url获取二维码
func getQRCode(_ str : String) -> UIImage? {
    let filter = CIFilter.init(name: "CIQRCodeGenerator")
    filter?.setDefaults()
    let data = str.data(using: .utf8)
    filter?.setValue(data, forKey: "inputMessage")
    if let image = filter?.outputImage {
        return UIImage.init(ciImage: image)
    } else {
        return nil
    }
}

/// 获取振动反馈
@available(iOS 10.0, *)
func getFeedbackGenerator(_ mini : Bool) -> UIImpactFeedbackGenerator {
    return UIImpactFeedbackGenerator.init(style: mini ? UIImpactFeedbackGenerator.FeedbackStyle.light : UIImpactFeedbackGenerator.FeedbackStyle.medium)
}

/// 个性化时间格式
func getGeneralTimeFormats(_ timeStr : String, _ isSpec : Bool) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
    if let date = formatter.date(from: timeStr) {
        let timeStr = isSpec ? NSDate.timeInfo(withSpecDate: date)! : NSDate.timeInfo(with: date)!
        return timeStr
    } else {
        return ""
    }
}
/// 获取当前时间戳
func getNowTimeStamp() -> Int {
    let time = Date.init()
    let nowStamp = time.timeIntervalSince1970
    return Int(nowStamp)
}
// 13位
func getNowTimeStampMoreBit() -> String {
    let time = Date.init()
    let nowStamp = time.timeIntervalSince1970 * 1000
    return String(format: "%.lf", nowStamp)
}
func getNowTimeFormatString() -> String {
    let nowDate = Date()
    let dateFormatter = DateFormatter()
    //dateFormatter.locale = Locale.current
    dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
    let currentDataString = dateFormatter.string(from: nowDate)
    return currentDataString
}

// 判空字符串
func isSpaceNULLString(_ text: String?) -> Bool {
    guard let text = text else { return true }
    let tempName = text.replacingOccurrences(of: " ", with: "")
    return tempName == ""
}
// 字符串制表符处理
func replaceTabsString(_ text : String) -> String {
    var txt = text
    txt = txt.replacingOccurrences(of: " ", with: "")
    txt = txt.replacingOccurrences(of: "\r\n", with: "")
    txt = txt.replacingOccurrences(of: "\n", with: "")
    txt = txt.replacingOccurrences(of: "\t", with: "")
    return txt
}
// 双角滑动线
func getSlideLineView(_ rect: CGRect) -> UIView {
    let slideLineView = UIView()
    slideLineView.backgroundColor = .yellow
    let slideOriX = rect.origin.x
    slideLineView.frame = CGRect.init(x: slideOriX, y: rect.origin.y, width: rect.width, height: 2.0)
    let slideCornerPath = UIBezierPath.init(roundedRect: slideLineView.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize.init(width: 2, height: 2))
    let slideMaskLayer = CAShapeLayer.init()
    slideMaskLayer.frame = slideLineView.bounds
    slideMaskLayer.path = slideCornerPath.cgPath
    slideLineView.layer.mask = slideMaskLayer
    return slideLineView
}
// 原图
func getOriImage(_ image: UIImage) -> UIImage {
    let newImage = image.withRenderingMode(.alwaysOriginal)
    return newImage
}
// 通用高斯模糊
func getBlurImage(_ image: UIImage, _ radius : CGFloat?, _ blackRadius : CGFloat?, _ isWhiteTintColor : Bool) -> UIImage {
    let img = image.yy_image(byBlurRadius: radius ?? 5.0, tintColor: UIColor.init(white: isWhiteTintColor ? 1.0 : 0.0, alpha: blackRadius ?? 0.1), tintMode: CGBlendMode.normal, saturation: 1, maskImage: nil)
    return img!
}
// 导航栏处理
func hideNavigationShadowImage(_ isHidden: Bool, _ view : UIView) {
    if let shadowImage = findShadowImageView(view) {
        shadowImage.isHidden = isHidden
    }
}
func findShadowImageView(_ view: UIView) -> UIImageView?{
    if view.isKind(of: UIImageView.self) && view.bounds.height <= 1.0 {
        return view as? UIImageView
    }
    for subview in view.subviews {
        if let imageView = findShadowImageView(subview) {
            return imageView
        }
    }
    return nil
}
func setNavigationbarColorClear(_ isClear: Bool, _ naviBar: UIView, _ backImg : UIImage?) {
    let navColor = isClear ? UIColor.clear : kNaviColor
    var navImg = UIImage.init(color: navColor)
    if let back = backImg {
        navImg = back
    }
    (naviBar as? UINavigationBar)?.setBackgroundImage(navImg, for: .default)
    hideNavigationShadowImage(isClear, naviBar)
}

/// 返回文件大小字符串, 输入bit参数
///
/// - Returns: 返回大小字符串
func totalSizeStr(_ fileSizeOfBit : Float) -> String {
    var totalSizeStr = ""
    var totalSizeF : Float = 0
    if fileSizeOfBit > 1000 * 1000 {
        totalSizeF = fileSizeOfBit / 1000.0 / 1000.0
        totalSizeStr = String.init(format: "%.1fMB", totalSizeF)
    }else if fileSizeOfBit > 1000 {
        totalSizeF = fileSizeOfBit / 1000.0;
        totalSizeStr = String.init(format: "%.1fKB", totalSizeF)
    }else if fileSizeOfBit > 0 {
        totalSizeStr = String.init(format: "%.1fdB", fileSizeOfBit)
    }
    totalSizeStr = totalSizeStr.replacingOccurrences(of: ".0", with: "")
    return totalSizeStr
}
/// 转换为正确的图url
func translateCharacterWithURLString(_ before : String) -> String {
    let newUrl = before.removingPercentEncoding
    let newUrlStr = newUrl?.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) ?? ""
    return newUrlStr
}
/// 判断是否正确url
func isEnableURL(_ urlString : String) -> Bool {
    guard let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue) else {
        return false
    }
    let results = detector.matches(in: urlString, options: [], range: NSRange(location: 0, length: urlString.count))
    return results.count > 0
}

/// 自偏移ScrollView
func setupAutomatilly(_ scrollView : UIScrollView, _ vc : UIViewController) {
    if #available(iOS 11, *) {
        scrollView.contentInsetAdjustmentBehavior = .never
    } else {
        vc.automaticallyAdjustsScrollViewInsets = false
    }
}
/// 通用上下拉刷新(动画, 白色字体)
func setupRefreshViewWith(_ images : [UIImage]?,_ refreshingImgs : [UIImage]?, _ pullingImgs : [UIImage]?, _ superVC: UIViewController, _ tbView : UIScrollView,newAction: Selector?, moreAction: Selector?) {
    
    if let newAct = newAction {
        let header = MJRefreshGifHeader(refreshingTarget: superVC, refreshingAction: newAct)
        header?.setTitle("下拉刷新", for: .idle)
        header?.setTitle("释放更新", for: .pulling)
        header?.setTitle("没有更多数据了", for: .noMoreData)
        header?.setTitle("加载中", for: .refreshing)
        header?.setImages(images, for: MJRefreshState.idle)
        header?.setImages(pullingImgs, for: MJRefreshState.pulling)
        header?.setImages(refreshingImgs, for: MJRefreshState.refreshing)
        header?.labelLeftInset = 6.0
        header?.pullingPercent = 0.8
        header?.stateLabel.font = UIFont.systemFont(ofSize: 13)
        header?.stateLabel.textColor = .white
        header?.stateLabel.isHidden = true
        header?.lastUpdatedTimeLabel.isHidden = true
        header?.isAutomaticallyChangeAlpha = true
        tbView.mj_header = header
    }
    
    if let moreAct = moreAction {
        let footer = MJRefreshAutoNormalFooter.init(refreshingTarget: superVC, refreshingAction: moreAct)
        footer?.isRefreshingTitleHidden = true
        footer?.setTitle("", for: MJRefreshState.idle)
        footer?.setTitle("-End-", for: .noMoreData)
        footer?.isAutomaticallyHidden = true
        tbView.mj_footer = footer
    }
}

// 初始化主控制器
func initialApp(_ scene : UIResponder?) -> UIWindow {
    let mainVC = BaseTabBarController()
    SettingConfig.tabbar = mainVC
    var window : UIWindow!
    if #available(iOS 13.0, *) {
        if let scene = scene as? UIWindowScene {
            window = UIWindow.init(windowScene: scene)
            window.frame = scene.coordinateSpace.bounds
        }
    } else {
        window = UIWindow.init(frame: kZWScreenBounds)
    }
    window.backgroundColor = kMainBackColor
    window.rootViewController = mainVC
    window.makeKeyAndVisible()
    return window
}

