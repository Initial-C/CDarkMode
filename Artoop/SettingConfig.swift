//
//  SettingConfig.swift
//  Artoop
//
//  Created by EROMANGA on 2021/2/1.
//  Copyright © 2021 Artoop. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import MGJRouter


private let settingKey = "setting_overall_key"
private let testNetworkConfigKey = "artoop.set.kTestNetworkConfigKey"
private let cellularKey = "artoop.set.cellular"
private let wlanKey = "artoop.set.wlan"
private let firstLaunchKey = "artoop.set.firstLaunchKey"
private let pushServiceKey = "artoop.set.pushServiceKey"
private let deviceTokenKey = "artoop.set.deviceTokenKey"
private let lastPhoneKey = "artoop.set.lastPhoneKey"
private let supportDarkModeKey = "artoop.set.supportDarkModeKey"
private let customDarkModeKey = "artoop.set.customDarkModeKey"

@objc(SettingConfig)
class SettingConfig : NSObject  {
    @UserDefaultStorage(keyName: "General_Setting_Config")
    
    static var _style: Int?

    static var style: Theme {
        get { return Theme(rawValue: (_style ?? 0)) ?? .none }
        set { _style = newValue.rawValue }
    }

    /// 创造颜色, 核心方法
    static func makeColor(light: UIColor, dark: UIColor) -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor { $0.userInterfaceStyle == .light ? light : dark }
        } else {
            return SettingConfig.style == .light ? light : dark
        }
    }

    /// 创造 img, 核心方法
    static func makeImage(light: UIImage, dark: UIImage) -> UIImage {
        if #available(iOS 13.0, *) {
            let image = UIImage()
            image.imageAsset?.register(light, with: .init(userInterfaceStyle: .light))
            image.imageAsset?.register(dark, with: .init(userInterfaceStyle: .dark))
            return image
        } else {
            return SettingConfig.style == .light ? light : dark
        }
    }
    static private var setID : String {
        get {
            return "_" + settingKey
        }
    }
    static var isAllowCellular : Bool = false
    static var isAllowWLAN : Bool = false
    static var isFirstLaunched : Bool = false
    static var isOpenPushService : Bool = false
    static var deviceToken : String = ""
    static var lastPhoneNumber : String = ""
    static var isTestEnvironment : Bool = false
    static var isCurrentDarkMode : Bool  {
        get {
            if #available(iOS 13.0, *) {
                return UITraitCollection.current.userInterfaceStyle == .dark
            } else {
                return false
            }
        }
    }
    static var tabbar : BaseTabBarController?
    /// 是否登录状态(辅助判断)
//    var isSignInStatus : Bool {
//        return UserInfoMaster.share != nil
//    }
//    var isBinded : Bool {
//        get {
//            let phoneStr = UserInfoMaster.share?.phoneNumber ?? ""
//            return !isSpaceNULLString(phoneStr)
//        }
//    }
//    var userIdentifier : String {
//        if let master = UserInfoMaster.share {
//            return "\(master.uid)"
//        } else {
//            return "General_Visitors"
//        }
//    }
    //    private
//    static let share : SettingConfig = {
//        let config = SettingConfig()
//        return config
//    }()
    
    public static func initialOriginConfig() {
        SettingConfig.isFirstLaunched = true
        SettingConfig.isOpenPushService = true
        SettingConfig.isAllowWLAN = true
        SettingConfig.isAllowCellular = true
    }
    public static func initialSettingConfig() {
        // 设置Token
//        if isSpaceNULLString(UserInfoMaster.share?.access_token ?? "") {
//            MGJRouter.openURL("msinger://setAccessToken", withUserInfo: ["token" : ""], completion: nil)
//        }
        // 消息采用透传更新机制
//        updateUserMaster()
        // event
        // 签到
        // mini player
        // 启动时记录app设置中的暗黑模式, 若有
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
        } catch {
            print("【AVAudioSession】category error")
        }
        
    }
    public static func logout() {
//        PushServiceConfig.unbindAlias()
        SettingConfig.resetSystemBadge()
        SettingConfig.setTabbarBadge(0)
//        UserInfoMaster.clearUserMaster()
//        MGJRouter.openURL("msinger://setAccessToken", withUserInfo: ["token" : ""], completion: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kCNotificationLogoutKey), object: nil)
    }
    
    class func getSystemBadge() -> Int {
        return UIApplication.shared.applicationIconBadgeNumber
    }
    class func setSystemBadge(_ value : Int) {
        UIApplication.shared.applicationIconBadgeNumber = value
//        PushServiceConfig.setBadge(value)
    }
    class func resetSystemBadge() {
        UIApplication.shared.applicationIconBadgeNumber = 0
//        PushServiceConfig.resetBadge()
    }
    
    /// 必须在AppDelegate中将tabbar赋值保存才可使用此方法
    class func setTabbarBadge(_ value : Int) {
//        if let tab = SettingConfig.share.tabbar {
//            tab.messageItem.badgeValue = value == 0 ? nil : "\(value)"
//        }
    }
    
    class func setDarkMode(_ theme : Theme) {
        if #available(iOS 13.0, *) {
            SettingConfig.style = theme
            let scene = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive}).first?.delegate as? SceneDelegate
            if let scene = scene, let window = scene.window {
                UIView.transition (with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
                    scene.window?.overrideUserInterfaceStyle = theme.mode
                }, completion: nil)
            } else {
                if let window = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window {
                    UIView.transition (with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
                        window.overrideUserInterfaceStyle = theme.mode
                    }, completion: nil)
                }
            }
        }
    }
    
    
    
    // TODO: Router
    public static func configAllRouter() {
        // token设置
        MGJRouter.registerURLPattern("msinger://setAccessToken") { (parameters) -> Void in
            let info = (parameters as! [String : Any])[MGJRouterParameterUserInfo] as! [String : String]
            MGJRouter.openURL("yanxi://SetAuthorizationToken", withUserInfo: ["Authorization" : info["token"] ?? ""], completion: nil)
        }
        
        // token过期, 不弹提示框
//        MGJRouter.registerURLPattern("msinger://AuthorizationTokenInvalid") { (parameters) -> Void in
//            if !(getCurrentVC().isKind(of: Live2DViewController.self) || getCurrentVC().isKind(of: MTMyZoneViewController.self) || getCurrentVC().isKind(of: SignInViewController.self) || getCurrentVC().isKind(of: MTMessageController.self) ) || self.isIntoStudio {     // 除 "我的", "消息中心" 外都弹登录框
//                intoSignInController(nil, .signIn)
//            }
//            self.logout()
//            print("这里弹出登录窗口, 并且退出当前登录, 清除登录信息")
//        }
        // 当前网络状态
//        MGJRouter.registerURLPattern("msinger://getNetworkStatus") { (parameters) -> Any? in
//            return MGJRouter.object(forURL: "yanxi://getReachabilityStatus") // 0、-1无网络, 1蜂窝 2WIFI
//        }
        // 意见反馈
//        MGJRouter.registerURLPattern("msinger://GoToTheFeedback") { (parameters)->Void in
//            let info = (parameters as! [String : Any])[MGJRouterParameterUserInfo] as! [String : Any]
//            if let fromVC = info["from"] as? UIViewController {
//                let feedbackURL = "http://star-fans.com/app/\(kWebHeaderField)/feedback.html"
//                MGJRouter.openURL("msinger://SweetWeb", withUserInfo: ["url" : feedbackURL, "isToken" : true, "from" : fromVC], completion: nil)
//            }
//        }
        // 播放器
//        MGJRouter.registerURLPattern("msinger://GoToThePlayer") { (parameters) -> Void in
//            let info = (parameters as! [String : Any])[MGJRouterParameterUserInfo] as! [String : AnyObject]
//            let songID : Int = info["songid"] as! Int
//            let netStatus = MGJRouter.object(forURL: "msinger://getNetworkStatus") as! Int
//            switch netStatus {
//            case 0,-1:
//                CSVProgressHUD.showError("失去网络连接~")
//                return
//            default:
//                break
//            }
//            BestNetWorkTools.share.checkSongEnable(songID, { (isEnable) in
//                if isEnable {
//                    let player = MutaPlayerViewController.instance
//                    let oriSongID = player.songID
//                    if let progress = info["progress"] as? Int {
//                        player.progress = progress
//                    }
//                    if let albumID = info["albumid"] as? Int, albumID != -1 {
//                        if MutaPlaylistController.share.albumID == albumID && CPlayer.shareInstance().currentSongID == songID {
////                            MutaPlayerViewController
//                            player.isInitialized = false
//                        } else {
//                            player.isInitialized = (songID != player.songID && MutaPlaylistController.share.albumID  == -1) || MutaPlaylistController.share.isInitialFromAlbum == true
//                            MutaPlaylistController.share.albumID = albumID
//                        }
//                    } else {
//                        player.isInitialized = songID != player.songID || MutaPlaylistController.share.albumID != -1
//                        player.lastSongID = MutaPlaylistController.share.albumID != -1 ? 0 : player.songID
//                        MutaPlaylistController.share.albumID = -1
//                    }
//                    if let isEdited = info["isedited"] as? Bool, isEdited == true {
//                        player.isInitialized = true
//                        player.lastSongID = 0
//                    }
//                    let isBackgroundPlayer = (info["background"] as? Bool) ?? false
//                    let isSyncMiniPlayer = (info["sync"] as? Bool) ?? false
//                    player.setDeinit()
//                    player.songID = songID
//                    DispatchQueue.global().async {
//                        var fromNavi : UINavigationController?
//                        if let fromVC = info["from"] as? UINavigationController {
//                            fromNavi = fromVC
//                        } else if let fromVC = info["from"] as? UIViewController {
//                            fromNavi = fromVC.navigationController
//                        }
//                        if let navi = fromNavi {
//                            let childs = navi.viewControllers
//                            var topMusic = false
//                            if let topVC = navi.topViewController, topVC.isKind(of: MutaPlayerViewController.self) {
//                                topMusic = true
//                            }
//                            for (i, _) in childs.enumerated().filter({$1.isKind(of: MutaPlayerViewController.self)}) {
//                                if !topMusic {
//                                    navi.viewControllers.remove(at: i)
//                                }
//                            }
//                            DispatchQueue.main.async {
//                                if !isBackgroundPlayer && !topMusic {
//                                    navi.pushViewController(player, animated: true)
//                                } else {
//                                    player.isSyncMiniPlayer = isSyncMiniPlayer
//                                    if player.isViewLoaded {
//                                        if player.isInitialized && songID == oriSongID {
//                                            player.isInitialized = false
//                                        }
//                                    } else {
//                                    }
//                                    if !player.isInitialized {
//                                        if MutaPlayerHelper.share.isPause {
//                                            MutaPlayerHelper.share.playMusic()
//                                        }
//                                    } else {
//                                        player.willBeginLoadData()
//                                        player.beginLoadData()
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//                if let completion = (parameters as! [String : Any])[MGJRouterParameterCompletion] as AnyObject? {
//                    typealias closure = @convention(block) (_ exist : String)->Void
//                    let blockPtr = UnsafeRawPointer(Unmanaged<AnyObject>.passUnretained(completion).toOpaque())
//                    let handler = unsafeBitCast(blockPtr, to: closure.self)
//                    handler("\(isEnable.intValue)")
//                }
//            })
//
//        }
        // 跳转社区详情
//        MGJRouter.registerURLPattern("msinger://GoToCommunityDetail") { (parameters) -> Void in
//            guard let parameter = parameters as? [String : Any], let info = parameter[MGJRouterParameterUserInfo] as? [String : AnyObject] else {
//                return
//            }
//            let statusPK = info["statuspk"] as! Int
//            var fromNavi : UINavigationController?
//            if let fromVC = info["from"] as? UINavigationController {
//                fromNavi = fromVC
//            } else if let fromVC = info["from"] as? UIViewController {
//                fromNavi = fromVC.navigationController
//            }
//            let communityDetailVC = MTCommunityDetailController()
//            communityDetailVC.parentID = statusPK
//            DispatchQueue.main.async {
//                fromNavi?.pushViewController(communityDetailVC, animated: true)
//            }
//        }
        // 跳转社区
        
        // 跳转版区详情
        
        // 进入live2d
//        MGJRouter.registerURLPattern("msinger://GoToLive2D") { (parameters)-> Void in
//            MutaPlayerHelper.share.pauseMusic()
//            let live2d = MGJRouter.object(forURL: "yanxi://GetLive2DVC", withUserInfo: ["user" : "user"]) as! UIViewController
//            guard let mainWindow = SettingConfig.share.mainWindow, let live2dWindow = SettingConfig.share.live2dWindow else {
//                SettingConfig.share.mainWindow = UIApplication.shared.windows.first
//                SettingConfig.share.live2dWindow = UIWindow.init(frame: kZWScreenBounds)
//                SettingConfig.share.live2dWindow?.backgroundColor = kMainBackColor
//                SettingConfig.share.live2dWindow?.rootViewController = live2d
//                SettingConfig.share.mainWindow?.resignKey()
//                SettingConfig.share.mainWindow?.windowLevel = UIWindowLevelNormal - 1
//                SettingConfig.share.live2dWindow?.makeKeyAndVisible()
//                CSVProgressHUD.resumeDefaultStyle()
//                return
//            }
//            mainWindow.resignKey()
//            mainWindow.windowLevel = UIWindowLevelNormal - 1
//            live2dWindow.isHidden = false
//            live2dWindow.makeKeyAndVisible()
//            live2dWindow.windowLevel = UIWindowLevelNormal
//            CSVProgressHUD.resumeDefaultStyle()
//        }
        // 回到主App
//        MGJRouter.registerURLPattern("msinger://ComebackMainApplication") { (parameters)->Void in
//            if let mainWindow = SettingConfig.share.mainWindow, let live2dWindow = SettingConfig.share.live2dWindow {
//                live2dWindow.resignKey()
//                live2dWindow.windowLevel = UIWindowLevelNormal - 1
//                mainWindow.makeKeyAndVisible()
//                mainWindow.windowLevel = UIWindowLevelNormal
//                live2dWindow.isHidden = true
//
//            }
//            CSVProgressHUD.resumeDefaultStyle()
//        }
    }

}


@propertyWrapper
public struct UserDefaultStorage<T: Codable> {
    var value: T?

    let keyName: String

    let queue = DispatchQueue(label: (UUID().uuidString))

    public init(keyName: String) {
        value = UserDefaults.standard.value(forKey: keyName) as? T
        self.keyName = keyName
    }

    public var wrappedValue: T? {

        get { value }

        set {
            value = newValue
            let keyName = self.keyName
            queue.async {
                if let value = newValue {
                    UserDefaults.standard.setValue(value, forKey: keyName)
                } else {
                    UserDefaults.standard.removeObject(forKey: keyName)
                }
            }
        }
    }
}

enum Theme: Int, CaseIterable {
    case none = 0
    case light = 1
    case dark = 2

    var title: String {
        switch self {
            case .none: return "Follow"
            case .light: return "Light"
            case .dark: return "Dark"
        }
    }

    @available(iOS 13.0, *)
    var mode: UIUserInterfaceStyle {
        switch self {
            case .none: return .unspecified
            case .light: return .light
            case .dark: return .dark
        }
    }
}
