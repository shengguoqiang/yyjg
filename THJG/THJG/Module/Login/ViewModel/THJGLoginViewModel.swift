/**
 * 登录相关操作
 */
/* 成功通知 */
let THJG_NOTIFICATION_LOGIN_SUCCESS = "THJG_NOTIFICATION_LOGIN_SUCCESS"

class THJGLoginViewModel: THJGBaseViewModel {
    
    /**
     * 请求用户数据
     * @param param   业务参数
     */
    func requestForUserData(param: PARAMETERTYPE?) {
        //发送网络请求
        let request = DQSNetworkManager.sharedInstance.requestForData(methodName: "login", bussinessParam: param, success: { (response) in
            let userBean = THJGUserBean.parse(response)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: THJG_NOTIFICATION_LOGIN_SUCCESS), object: THJGSuccessBean(bean: userBean, msg: nil))
        }) { (code, message) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: THJG_NOTIFICATION_NETWORK_FAILURE), object: THJGFailureBean(errorCode: code, msg: message))
        }
        requestQueue.append(request)
    }
}
