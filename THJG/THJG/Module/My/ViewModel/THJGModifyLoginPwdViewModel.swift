/**
 * 修改登录密码VM
 */

let THJG_NOTIFICATION_MODIFY_LOGINPWD_SUCCESS = "THJG_NOTIFICATION_MODIFY_LOGINPWD_SUCCESS"

class THJGModifyLoginPwdViewModel: THJGBaseViewModel {

    /**
     * 修改登录密码
     * @param param   业务参数
     */
    func requestForModifyLoginPwd(param: PARAMETERTYPE?) {
        let request = DQSNetworkManager.sharedInstance.requestForData(methodName: "modifyLoginPwd", bussinessParam: param, success: { (response) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: THJG_NOTIFICATION_MODIFY_LOGINPWD_SUCCESS), object: THJGSuccessBean(bean: nil, msg: response["msg"].string))
        }) { (code, message) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: THJG_NOTIFICATION_NETWORK_FAILURE), object: THJGFailureBean(errorCode: code, msg: message))
        }
        requestQueue.append(request)
    }
}
