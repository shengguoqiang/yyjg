/**
 * 忘记密码相关操作
 */

/* 成功通知 */
let THJG_NOTIFICATION_FORGETPWD_SUCCESS = "THJG_NOTIFICATION_FORGETPWD_SUCCESS"

class THJGForgetPwdViewModel: THJGBaseViewModel {

    /**
     * 重置登录密码
     * @param param   业务参数
     */
    func requestForResettingPwd(param: PARAMETERTYPE?) {
        let request = DQSNetworkManager.sharedInstance.requestForData(methodName: "resetPwd", bussinessParam: param, success: { (response) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: THJG_NOTIFICATION_FORGETPWD_SUCCESS), object: THJGSuccessBean(bean: nil, msg: response["msg"].string))
        }) { (code, message) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: THJG_NOTIFICATION_NETWORK_FAILURE), object: THJGFailureBean(errorCode: code, msg: message))
        }
        requestQueue.append(request)
    }
}
