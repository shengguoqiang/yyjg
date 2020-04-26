/**
 * 项目相关操作
 */

/* 成功通知 */
let THJG_NOTIFICATION_HOMEPAGE_SUCCESS = "THJG_NOTIFICATION_HOMEPAGE_SUCCESS"
let THJG_NOTIFICATION_VERSION_UPDATE_SUCCESS = "THJG_NOTIFICATION_VERSION_UPDATE_SUCCESS"
let THJG_NOTIFICATION_EMERGENT_MSG_SUCCESS = "THJG_NOTIFICATION_EMERGENT_MSG_SUCCESS"

class THJGHomePageViewModel: THJGBaseViewModel {

    /**
     * 获取项目数据
     * @param param   业务参数
     */
    func requestForHomePageData(param: PARAMETERTYPE?) {
        let request = DQSNetworkManager.sharedInstance.requestForData(methodName: "homePage", bussinessParam: param, success: { (response) in
            let homePageBean = THJGHomePageBean.parse(response)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: THJG_NOTIFICATION_HOMEPAGE_SUCCESS), object: THJGSuccessBean(bean: homePageBean, msg: nil))
        }) { (code, message) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: THJG_NOTIFICATION_NETWORK_FAILURE), object: THJGFailureBean(errorCode: code, msg: message))
        }
        requestQueue.append(request)
    }
    
    /**
     * 获取版本更新数据
     * @param param   业务参数
     */
    func requestForVersionUpdateData(param: PARAMETERTYPE?) {
        let request = DQSNetworkManager.sharedInstance.requestForData(methodName: "updateVersion", bussinessParam: param, success: { (response) in
            let updateVersionBean = THJGAppUpgradeBean.parse(response)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: THJG_NOTIFICATION_VERSION_UPDATE_SUCCESS), object: THJGSuccessBean(bean: updateVersionBean, msg: nil))
        }) { (code, message) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: THJG_NOTIFICATION_NETWORK_FAILURE), object: THJGFailureBean(errorCode: code, msg: message))
        }
        requestQueue.append(request)
    }
    
    /**
     * 获取紧急公告数据
     * @param param   业务参数
     */
    func requestForEmergentMsgData(param: PARAMETERTYPE?) {
        let request = DQSNetworkManager.sharedInstance.requestForData(methodName: "emergentMsg", bussinessParam: param, success: { (response) in
            let emergentMsgBean = THJGEmergentMsgBean.parse(response)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: THJG_NOTIFICATION_EMERGENT_MSG_SUCCESS), object: THJGSuccessBean(bean: emergentMsgBean, msg: nil))
        }) { (code, message) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: THJG_NOTIFICATION_NETWORK_FAILURE), object: THJGFailureBean(errorCode: code, msg: message))
        }
        requestQueue.append(request)
    }
    
    
    
}
