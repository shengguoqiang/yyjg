/**
 * 工具类
 */
import Toast_Swift
import LocalAuthentication

//小数显示逻辑
@objc enum NumberShowStyle: Int {
    /**
     *  正常显示
     */
    case showStyleNormal
    /**
     *  去除无效的零
     */
    case showStyleNoZero
}

class DQSUtils {
    
    //MARK: - 判断是否是iPad
    static func isIpad() -> Bool {
        let device = UIDevice.current.model
        return device.contains("iPad")
    }
    
    //MARK: - 页面跳转
    static func switchPage(from source: THJGNavigationController, to des: Int) {
        //当前控制器清空栈
        source.popToRootViewController(animated: false)
        //切换tab
        ((UIApplication.shared.delegate as! THJGAppDelegate).window?.rootViewController as! THJGTabBarController).selectedIndex = des
    }
    
    //MARK: - 判断应用是否是第一次启动
    static func isFirstLaunched() -> Bool {
        let curVersion =  Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
        let value = UserDefaults.standard.value(forKey: "thjg_isFirst_launched")
        if let value = value as? String {
            if value != (curVersion ?? "") {//新版本启动
               UserDefaults.standard.set(curVersion ?? "", forKey: "thjg_isFirst_launched")
               return true
            }
            return false
        } else {//第一次启动
            UserDefaults.standard.set(curVersion ?? "", forKey: "thjg_isFirst_launched")
            return true
        }
    }
    
    //MARK: - 判断应用是否处于登录状态
    static func isLoginStatus() -> (Bool, THJGUserBean?) {
        let userBean = THJGStorageManager.readUser()
        guard let user = userBean else {
            return (false, nil)
        }
        return (true, user)
    }
    
    //MARK: - 退出登录,做一些数据处理
    static func logout() {
        //清空本地用户数据
        THJGStorageManager.deleteUser()
        
        /* 推送相关 */
        //删除推送别名
        JPUSHService.deleteAlias(nil, seq: 0)
        //删除标签
        JPUSHService.deleteTags([ENVIRONMENT], completion: nil, seq: 0)

        //清空密码设置相关
        saveGuesture("")
        setTouchID(false)
    }
    
    //MARK: - 处理字符串中的特殊字符显示
    /**
     * @param sourceString 需要处理的字符串
     * @param neededHandledString 需要处理的特殊字符
     * @param neededHandledParam 需要处理的特殊字符样式
     */
     static func showString(sourceString: String,
                                 neededHandledString: String,
                                 neededHandledParam: [NSAttributedString.Key: Any]) -> NSMutableAttributedString {
        let source = sourceString as NSString
        let range = source.range(of: neededHandledString)
        let attStr = NSMutableAttributedString(string: sourceString)
        attStr.addAttributes(neededHandledParam, range: range)
        return attStr
    }
    
    /**
     * @param sourceString 需要处理的字符串
     * @param neededHandledString 需要处理的特殊字符数组
     * @param neededHandledParam 需要处理的特殊字符样式数组
     */
     static func showString(sourceString: String,
                                 neededHandledStrings: [String],
                                 neededHandledParams: [[NSAttributedString.Key: Any]]) -> NSMutableAttributedString {
        let source = sourceString as NSString
        let attStr = NSMutableAttributedString(string: sourceString)
        for (neededHandledStrIndex, _) in neededHandledStrings.enumerated() {
            let range = source.range(of: neededHandledStrings[neededHandledStrIndex])
            attStr.addAttributes(neededHandledParams[neededHandledStrIndex], range: range)
        }
        return attStr
    }
    
    //MARK: - 根据地址获取经纬度
    static func geocoder(address: String?,
                         completeBlock: @escaping (CLLocationCoordinate2D)->Void) {
        guard isNotBlank(address) else {
            return
        }
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address!) { (placemarks, error) in
            guard placemarks != nil, !placemarks!.isEmpty, error == nil else {
                return
            }
            if let location = placemarks![0].location {
                completeBlock(CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude))
            }
        }
    }
    
    //MARK: - 本地通过keyChain存取密码
    static func savePwd(_ pwd: String) {
        let keyChainWrapper = KeychainWrapper()
        keyChainWrapper.mySetObject(pwd, forKey: kSecValueData)
        keyChainWrapper.writeToKeychain()
    }
    
    static func readPwd() -> String? {
        let keyChainWrapper = KeychainWrapper()
        return keyChainWrapper.myObject(forKey: kSecValueData) as? String
    }
    
    //MARK: - 存取手势密码
    static func saveGuesture(_ pwd: String) {
        UserDefaults.standard.set(pwd, forKey: "thjg_guesturePwd_key")
    }
    
    static func readGuesture() -> String? {
        let value = UserDefaults.standard.value(forKey: "thjg_guesturePwd_key")
        if let guesture = value as? String {
            return isNotBlank(guesture) ? guesture : nil
        }
        return nil
    }
    
    //MARK: - Touch ID设置
    static func setTouchID(_ val: Bool) {
        UserDefaults.standard.set(val, forKey: "thjg_touch_id_key")
    }
    
    static func touchIDIsSet() -> Bool {
        let res = UserDefaults.standard.value(forKey: "thjg_touch_id_key")
        if let resuslt = res as? Bool {
            return resuslt
        }
        return false    
    }
    
    static func isSupportTouchID() -> Bool {
        //初始化上下文
        let context = LAContext()
        //判断设备支持状态
        var error: NSError?
        context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        if error != nil {
            switch error!.code {
            case LAError.touchIDNotAvailable.rawValue:
                return false
            default:
                return false
            }
        }
        if #available(iOS 11.0, *) {
            if (UIApplication.shared.delegate as! THJGAppDelegate).window!.safeAreaInsets.top > 20 {// iPhone X及以上机型无指纹密码
                return false
            }
        } else {
            return true
        }
        return true
    }
    
    static func showTouchID(_ tip: String) {
        //初始化上下文
        let context = LAContext()
        context.localizedFallbackTitle = ""
        //判断设备支持状态
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            //支持指纹
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: tip) { (success, resError) in
                if success {
                    //验证成功，主线程处理UI
                    DispatchQueue.main.async {
                      DQSUtils.log("验证成功")
                        NotificationCenter.default.post(name: NSNotification.Name(THJG_NOTIFICATION_TOUCHID_VALIDATE_SUCCESS), object: nil)
                    }
                } else {
                    //验证失败，查看具体原因(操作需在主线程中进行)
                    let failureError = resError! as NSError
                    switch failureError.code {
                    case LAError.systemCancel.rawValue:
                        DQSUtils.log("systemCancel")
                    case LAError.userCancel.rawValue:
                        DQSUtils.log("userCancel")
                        DispatchQueue.main.async {
                            NotificationCenter.default.post(name: NSNotification.Name(THJG_NOTIFICATION_TOUCHID_VALIDATE_FAILURE), object: nil)
                        }
                    default:
                        break
                    }
                }
            }
        } else {
            //不支持指纹
            switch error!.code {
            case LAError.touchIDNotAvailable.rawValue:
                DQSUtils.log("touchIDNotAvailable")
            case LAError.touchIDNotEnrolled.rawValue:
                DQSUtils.log("touchIDNotEnrolled")
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: NSNotification.Name(THJG_NOTIFICATION_TOUCHID_SETTING_NOTAVAILABLE), object: nil)
                }
            case LAError.passcodeNotSet.rawValue:
                DQSUtils.log("passcodeNotSet")
            default:
                break
            }
        }
    }
    
    //MARK: - 计算固定宽度下的文本高度
    /**
     * @param text       目标文本
     * @param fixedWidth 固定宽度
     * @param fixedFont  固定字体大小
     */
    static func heightForText(text: String,
                              fixedWidth: CGFloat,
                              fixedFont: UIFont) -> CGFloat {
        let size = (text as NSString).boundingRect(with: CGSize(width: fixedWidth, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : fixedFont], context: nil).size
        return size.height
    }
    
    //MARK: - 根据时间间隔和特定时间格式显示时间
    /**
     * @param interval    时间间隔
     * @param timeFormate 时间显示格式
     */
    static func showTime(interval: TimeInterval,
                         timeFormate: String?) -> String {
        let date = Date(timeIntervalSince1970: interval)
        let dateFormatter = DateFormatter()
        var format = timeFormate
        if format == nil {// 默认显示年月日时分秒
            format = "yyyy-MM-dd HH:mm:ss"
        }
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    
    /**
     * 显示当前是周几
     * @param interval    时间字符串
     * @param timeFormate 时间显示格式
     */
    static func showWeekDay(dateStr: String,
                            dateFormate: String?=nil) -> String? {
        var formate = dateFormate
        if isBlank(formate) {
            formate = "yyyy-MM-dd"
        }
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = formate
        let date = dateFormate.date(from: dateStr)
        guard date != nil else {
            return nil
        }
        dateFormate.dateFormat = "EEEE"
        return dateFormate.string(from: date!)
    }
    
    //MARK: - 校验字符串是否非空
    static func isBlank(_ source: String?) -> Bool {
        guard let source = source else {
            return true
        }
        return source.isEmpty
    }
    
    static func isNotBlank(_ source: String?) -> Bool {
        return !isBlank(source)
    }
    
    //MARK: - 校验手机号的有效性
    static func isValidMobile(_ mobile: String?) -> Bool {
        guard isNotBlank(mobile) else {
            return false
        }
        let regex = NSPredicate(format: "SELF MATCHES %@", "^1(3|4|5|6|7|8|9)\\d{9}$")
        return regex.evaluate(with: mobile!)
    }
    
    //MARK: - 校验密码的有效性
    // 6~18位字母数字或组合
    static func isValidPassword(_ password: String?) -> Bool {
        guard isNotBlank(password) else {
            return false
        }
        let regex = NSPredicate(format: "SELF MATCHES %@", "^[0-9a-zA-Z]{6,18}$")
        return regex.evaluate(with: password!)
    }
    
    //MARK: - loading
    /**
     * 显示loading
     * @param parView 父视图
     */
    static func showLoading(_ parView: UIView) {
        parView.makeToastActivity(.center)
    }
    
    /**
     * 隐藏loading
     * @param parView 父视图
     */
    static func hideLoading(_ parView: UIView,
                            _ delay: UInt64 = 0) {
        if delay > 0 {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime(uptimeNanoseconds: delay)) {
                parView.hideToastActivity()
            }
            return
        }
        parView.hideToastActivity()
    }
    
    //MARK: - toast
    /**
     * toast
     * @param msg     展示的消息
     * @param parView 父视图
     */
    static func showToast(_ msg: String,
                          _ parView: UIView) {
        parView.hideToastActivity()
        parView.makeToast(msg, point: parView.center, title: nil, image: nil, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now()+0.8) {
            parView.hideToast()
        }
    }
    
    static func showToast(_ msg: String,
                          _ parView: UIView,
                          completion: @escaping ()->Void) {
        parView.hideToastActivity()
        parView.makeToast(msg, point: parView.center, title: nil, image: nil, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now()+2) {
            parView.hideToast()
            completion()
        }
    }
    
    //MARK: - 默认占位图
    
    /**
     * 显示默认占位图
     * @param parView       父视图
     * @param centerYOffSet 偏移量
     * @param msg           提示语
     */
    static func showPlaceholderImg(_ parView: UIView,
                                   _ centerYOffSet: CGFloat = 0,
                                   _ msg: String = "暂无内容") {
        let bgView = UIView(frame: CGRect(x: 0, y: 0, width: parView.bounds.width, height: parView.bounds.height))
        bgView.backgroundColor = UIColor.white
        bgView.tag = 123321
        let imgView = UIImageView(image: UIImage(named: "common_nodata"))
        bgView.addSubview(imgView)
        imgView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-30+centerYOffSet)
        }
        let tipLabel = UILabel(frame: CGRect(origin: .zero, size: CGSize(width: 80, height: 40)))
        tipLabel.textAlignment = .center
        tipLabel.font = UIFont.systemFont(ofSize: 13)
        tipLabel.text = msg
        tipLabel.textColor = rgbColor(150, 150, 150)
        bgView.addSubview(tipLabel)
        tipLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(imgView).offset(30)
            make.centerX.equalTo(imgView)
        }
        parView.addSubview(bgView)
    }
    
    /**
     * 隐藏默认占位图
     * @param parView父视图
     */
    static func hidePlaceholderImg(_ parView: UIView) {
        for sub in parView.subviews {
            if sub.tag == 123321 {
                sub.removeFromSuperview()
            }
        }
    }
    
    //MARK: - 日志打印
    static func log(_ items: Any...) {
        debugPrint(items)
    }
    
    //MARK: - 颜色
    /**
     * @param r
     * @param g
     * @param b
     */
    static func rgbColor(_ r: CGFloat,
                         _ g: CGFloat,
                         _ b: CGFloat) -> UIColor {
        return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
    }
    
    //MARK: - 显示浮点数
    /**
     * @param sourceDouble 需要处理的小数
     * @param floatNum 需要保留的小数位数
     * @param showStyle 显示方式
     */
    static func showDoubleNum(sourceDouble: Double,
                              floatNum: Int,
                              showStyle: NumberShowStyle/*?*/) -> String {
        let source = String(format: "%.\(floatNum)f", sourceDouble /** 100*/)
        guard floatNum != 0 else {//取整
            return "\(Int(source) ?? 0)"
        }
        switch showStyle {
        case .showStyleNormal://正常显示
            return source
        case .showStyleNoZero://去除无效的零
            return handle(targetStr: source)
        }
    }
    
    //MARK: - 显示数值，以逗号（,）分割
    /**
     *  @param num 需要处理的num字符串
     */
    static func showNumWithComma(num: String) -> String {
        //判断是否已经处理过
        guard !num.contains(",") else {
            return num
        }
        //判断是否大于等于1000
        if let actualNum = Double(num), actualNum < 1000.0 {
            return num
        }
        //进行正常处理
        var intNum: String?     //整数
        var doubleNum: String?  //小数
        var sectionOne: String? //整数经过处理显示
        var sectionTwo: String? //小数经过处理显示
        //判断是否有小数
        if num.contains(".") {
            intNum = num.components(separatedBy: ".")[0]
            doubleNum = num.components(separatedBy: ".")[1]
        } else {
            intNum = num.components(separatedBy: ".")[0]
        }
        //处理整数
        if let num = intNum {
            if Int(num)! > 0 {
                sectionOne = handleIntNum(num: num)
            } else {
                sectionOne = "0"
            }
        }
        //处理小数
        if let num = doubleNum {
            sectionTwo = handleDoubleNum(num: num)
        }
        guard sectionTwo != nil else {
            return sectionOne ?? ""
        }
        return "\(sectionOne ?? "").\(sectionTwo ?? "")"
    }
    
    //MARK: - 以【万】为单位显示数值
    /**
     * @param sourceDouble 需要处理的浮点数
     * @param floatNum 小数需要保留几位
     * @param showStyle 小数显示格式
     */
    static func showNumWithUnit(sourceDouble: Double,
                                floatNum: Int,
                                showStyle: NumberShowStyle) -> String {
        if sourceDouble < 10000.0 {//小于一万，正常显示
            let str = showDoubleNum(sourceDouble: sourceDouble, floatNum: floatNum, showStyle: showStyle)
            return "\(showNumWithComma(num: str))元"
        } else {//大于一万，以【万】为单位显示
            let str = showDoubleNum(sourceDouble: sourceDouble / 10_000, floatNum: floatNum, showStyle: showStyle)
            return "\(showNumWithComma(num: str))万"
        }
    }
    
    //MARK: - 跳转AppStore
    static func switchAppStore() {
        let address = "https://itunes.apple.com/cn/app/id1459474114?mt=8"
        UIApplication.shared.openURL(URL(string: address)!)
    }
    
    //MARK: - 手机号加*显示
    static func showPhoneNum(_ phone: String) -> String? {
        guard phone.count == 11 else {
            return nil
        }
        let phoneStr = NSMutableString(string: phone)
        phoneStr.replaceCharacters(in: NSRange(location: 3, length: 4), with: "****")
        return phoneStr as String
    }
}

//MARK: - METHODS
extension DQSUtils {
    /*********************显示浮点数************************/
    //MARK: - 去除无效的零
    fileprivate static func handle(targetStr: String) -> String {
        var outStr = targetStr
        var index = 1
        if targetStr.contains(".") {//含小数位
            while index < targetStr.count {
                if outStr.hasSuffix("0") /*|| outStr.hasSuffix(".")*//*10.0的情况处理不了*/ {//去除无效的零
                    outStr.remove(at: outStr.index(before: outStr.endIndex))
                    index += 1
                } else {
                    break
                }
            }
            if outStr.hasSuffix(".") {//去除小数点
                outStr.remove(at: outStr.index(before: outStr.endIndex))
            }
            return outStr
        } else {//不含小数位
            return outStr
        }
    }
    /*********************显示浮点数************************/
    
    /******************显示数值，以逗号（,）分割*******************/
    //MARK: - 处理小数
    fileprivate static func handleDoubleNum(num: String) -> String? {
        return num
    }
    
    //MARK: - 处理整数
    fileprivate static func handleIntNum(num: String) -> String {
        let res =  seperateNum(num: Int(num)!)
        guard res.0 > 0 else {
            return "\(thousandNum(num: res.1))"
        }
        guard !isMoreThanOneThousand(num: res.0) else {
            let str = handleIntNum(num: "\(res.0)")
            return "\(str),\(thousandNum(num: res.1))"
        }
        return "\(res.0),\(thousandNum(num: res.1))"
    }
    
    //处理【333,444】中的【444】部分显示
    fileprivate static func thousandNum(num: Int) -> String {
        switch num {
        case let num where num >= 100:
            return "\(num)"
        case let num where num < 100 && num >= 10:
            return "0\(num)"
        case let num where num < 10:
            return "00\(num)"
        default:
            return "0"
        }
    }
    
    //分割千位和万位以上部分
    fileprivate static func seperateNum(num: Int) -> (Int, Int) {
        if isMoreThanOneThousand(num: num) {
            return (num/1000, num%1000)
        }
        return (0, num%1000)
    }
    //判断是否大于1000
    fileprivate static func isMoreThanOneThousand(num: Int) -> Bool {
        return num >= 1000
    }
    /******************显示数值，以逗号（,）分割*******************/
}

//MARK: - 拓展视图，增加圆角及边框便捷设置方法
extension UIView {
    
    //圆角
    @IBInspectable
    var cornerR: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = true
        }
    }
    
    //边框
    @IBInspectable
    var borderW: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderC: UIColor? {
        get {
            guard let borderC = layer.borderColor else {
                return nil
            }
            return UIColor(cgColor: borderC)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}

//MARK: - 导航栏按钮
extension UIBarButtonItem {
    
    /**
     * 自定义导航栏按钮(图片)
     * @param image_nor  正常图片
     * @param image_hl   高亮图片
     * @param target     目标对象
     * @param action     事件
     */
    static func item(image_nor: String,
                     image_hl: String?,
                     target: Any,
                     action: Selector) -> UIBarButtonItem {
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(origin: .zero, size: CGSize(width: 45, height: 45))
        btn.setImage(UIImage(named: image_nor), for: .normal)
        btn.setImage(UIImage(named: image_hl ?? ""), for: .highlighted)
        btn.contentHorizontalAlignment = .left
        btn.adjustsImageWhenHighlighted = false
        btn.addTarget(target, action: action, for: .touchUpInside)
        return UIBarButtonItem(customView: btn)
    }
    
    /**
     * 自定义导航栏按钮(标题)
     * @param title      标题
     * @param target     目标对象
     * @param action     事件
     */
    static func item(title: String,
                     target: Any,
                     action: Selector) -> UIBarButtonItem {
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(origin: .zero, size: CGSize(width: 80, height: 40))
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.adjustsImageWhenHighlighted = false
        btn.addTarget(target, action: action, for: .touchUpInside)
        return UIBarButtonItem(customView: btn)
    }
}
