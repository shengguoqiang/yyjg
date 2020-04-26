/**
 * 云眼监管AppDelegate
 */

import UIKit

@UIApplicationMain
class THJGAppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //MARK: - EZOPENSDK setup
        THJGEZOPENManager.sharedInstance.setup()
        
        //MARK: - Baidu map setup
        THJGBaiduMapManager.sharedInstance.setup()
        
        //MARK: - JPush
        setupJPush(launchOps: launchOptions)
        
        //MARK: - setup the keywindow
        window = UIWindow(frame: UIScreen.main.bounds)
        //避免隐藏导航栏后，pop返回时出现黑条
        window?.backgroundColor = DQSUtils.rgbColor(162, 46, 54)
        
        if DQSUtils.isFirstLaunched(), !DQSUtils.isIpad() {//首次启动或新版本启动
            //如果是新版本启动，则先退出登录
            DQSUtils.logout()
            
            //进入引导页
            window?.rootViewController = THJGGuideController()
        } else {
            if DQSUtils.isLoginStatus().0 {//已登录
                if DQSUtils.readGuesture() != nil
                    || DQSUtils.touchIDIsSet() {//设置了手势密码或指纹
                    window?.rootViewController = THJGNavigationController(rootViewController: THJGValidateGuestureController())
                } else {
                    window?.rootViewController = THJGTabBarController()
                }
            } else {//未登录
                window?.rootViewController = THJGNavigationController(rootViewController: THJGLoginController())
            }
        }
        
        window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
       
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // 清空badge
        application.applicationIconBadgeNumber = 0
        JPUSHService.setBadge(0)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // 清空badge
        application.applicationIconBadgeNumber = 0
        JPUSHService.setBadge(0)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
    }
    
    //MARK: - JPush 注册相关
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        //Required - 注册 DeviceToken
        JPUSHService.registerDeviceToken(deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        DQSUtils.log("did Fail To Register For Remote Notifications With Error: \(error)")
    }
    
    //MARK: - JPush 消息处理
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // Required, iOS 7 Support
        JPUSHService.handleRemoteNotification(userInfo)
        // 处理消息
        handleJPushInfo(userInfo)
        completionHandler(.newData)
    }
    
}

//MARK: - METHODS
extension THJGAppDelegate {
    //JPush初始化
    func setupJPush(launchOps: [UIApplication.LaunchOptionsKey: Any]?) {
        //初始化APNs
        THJGJPushRegister.registerJPush(self)
        
        //关闭日志
        JPUSHService.setLogOFF()
        
        //初始化JPush
        JPUSHService.setup(withOption: launchOps,
                           appKey: "4efcf881f82b0b4df0fdfdfa",
                           channel: "App Store",
                           apsForProduction: false,
                           advertisingIdentifier: nil)
    }
    
    //JPush数据处理
    func handleJPushInfo(_ info: [AnyHashable : Any]) {
        if UIApplication.shared.applicationState == .active {//应用在前台
            let pushView = THJGPushMsgView.showPushView()
            pushView.frame = UIScreen.main.bounds
            window?.addSubview(pushView)
            pushView.bean = info
            pushView.block = {
                [unowned self] in
                let type = "\(info["type"] ?? "")"
                let curNav = ((self.window?.rootViewController as! THJGTabBarController).selectedViewController as! THJGNavigationController)
                switch type {
                case "10"://站内信
                    let innerMsgDetailVC = THJGInnerMsgDetailController()
                    innerMsgDetailVC.msgId = (info["link"] as? String) ?? ""
                    curNav.pushViewController(innerMsgDetailVC, animated: true)
                case "20"://内链公告
                    let platformDetailVC = THJGPlatformNoticeDetailController()
                    platformDetailVC.noticeId = (info["link"] as? String) ?? ""
                    curNav.pushViewController(platformDetailVC, animated: true)
                case "30"://内链链接
                    UIApplication.shared.openURL(URL(string:(info["link"] as? String) ?? "")!)
                case "40"://App首页
                    DQSUtils.switchPage(from: curNav, to: 0)
                default:
                    break
                }
            }
        } else {//应用在后台
            let type = "\(info["type"] ?? "")"
            let curNav = ((self.window?.rootViewController as! THJGTabBarController).selectedViewController as! THJGNavigationController)
            switch type {
            case "10"://站内信
                let innerMsgDetailVC = THJGInnerMsgDetailController()
                innerMsgDetailVC.msgId = (info["link"] as? String) ?? ""
                curNav.pushViewController(innerMsgDetailVC, animated: true)
            case "20"://内链公告
                let platformDetailVC = THJGPlatformNoticeDetailController()
                platformDetailVC.noticeId = (info["link"] as? String) ?? ""
                curNav.pushViewController(platformDetailVC, animated: true)
            case "30"://内链链接
                UIApplication.shared.openURL(URL(string: (info["link"] as? String) ?? "")!)
            case "40"://App首页
                DQSUtils.switchPage(from: curNav, to: 0)
            default:
                break
            }
        }
        //将推送消息置为已读
        THJGPushViewModel().requestForPushMsgRead(param: ["pushId": "\(info["pushId"] ?? "")"], success: { (_, _) in
            
        }) { (_, _) in
            
        }
    }
}

//MARK: - JPUSHRegisterDelegate
extension THJGAppDelegate: JPUSHRegisterDelegate {
    
    /* 处理APNs通知回调方法 */
    // 当程序在前台时，收到推送弹出的通知
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        let userInfo = notification.request.content.userInfo
        if notification.request.trigger != nil, notification.request.trigger!.isKind(of: UNPushNotificationTrigger.self) {
            JPUSHService .handleRemoteNotification(userInfo)
        }
        // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
        completionHandler(2)
        // 处理消息
        handleJPushInfo(userInfo)
    }
    
    // 程序关闭后，通过点击推送弹出的通知
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        let userInfo = response.notification.request.content.userInfo
        if response.notification.request.trigger != nil, response.notification.request.trigger!.isKind(of: UNPushNotificationTrigger.self) {
            JPUSHService.handleRemoteNotification(userInfo)
        }
        completionHandler()
        // 处理消息
        handleJPushInfo(userInfo)
    }
    
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, openSettingsFor notification: UNNotification?) {
        
    }
}
