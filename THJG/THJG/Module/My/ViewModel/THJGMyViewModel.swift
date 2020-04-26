/**
 * 我的VM
 */

/* 成功通知 */
let THJG_NOTIFICATION_MYCENTER_SUCCESS = "THJG_NOTIFICATION_MYCENTER_SUCCESS"

//处理过的数据
struct MyHandledBean {
    var leadIcon: String
    var titile: String
    var msgUnRead: Int?
    var content: String?
    var trailIcon: String?
}

class THJGMyViewModel: THJGBaseViewModel {

    /**
     * 获取个人中心数据
     * @param param   业务参数
     */
    func requestForMyCenterData(param: PARAMETERTYPE?) {
        let request = DQSNetworkManager.sharedInstance.requestForData(methodName: "myCenter", bussinessParam: param, success: { (response) in
            let myBean = THJGMyCenterBean.parse(response)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: THJG_NOTIFICATION_MYCENTER_SUCCESS), object: THJGSuccessBean(bean: myBean, msg: nil))
        }) { (code, message) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: THJG_NOTIFICATION_NETWORK_FAILURE), object: THJGFailureBean(errorCode: code, msg: message))
        }
        requestQueue.append(request)
    }
    
}

extension THJGMyViewModel {
    
     func handleMyData(_ bean: THJGMyCenterBean) -> [MyHandledBean] {
        var handledBeans = [MyHandledBean]()
        handledBeans.append(MyHandledBean(leadIcon: "my_msg", titile: "我的消息", msgUnRead: bean.msgUnRead, content: nil, trailIcon: "project_cost_right_arrow"))
        handledBeans.append(MyHandledBean(leadIcon: "my_pwd", titile: "密码设置", msgUnRead: nil, content: nil, trailIcon: "project_cost_right_arrow"))
        handledBeans.append(MyHandledBean(leadIcon: "my_privacy", titile: "隐私政策", msgUnRead: nil, content: nil, trailIcon: "project_cost_right_arrow"))
        if !bean.upgrades.isEmpty {//有新版本
            handledBeans.append(MyHandledBean(leadIcon: "my_version", titile: "当前版本号", msgUnRead: nil, content: Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String, trailIcon: "my_update"))
        } else {
            handledBeans.append(MyHandledBean(leadIcon: "my_version", titile: "当前版本号", msgUnRead: nil, content: Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String, trailIcon: nil))
        }
        
        return handledBeans
    }
}
