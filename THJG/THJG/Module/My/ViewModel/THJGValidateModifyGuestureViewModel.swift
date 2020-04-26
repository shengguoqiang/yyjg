/**
 * 修改手势密码校验VM
 */

/* 成功通知 */
let THJG_NOTIFICATION_VALIDATE_MODIFY_GUESTUREPWD_SUCCESS = "THJG_NOTIFICATION_VALIDATE_MODIFY_GUESTUREPWD_SUCCESS"

class THJGValidateModifyGuestureViewModel: THJGBaseViewModel {

    /**
     * 修改手势密码
     * @param param   业务参数
     */
    func requestForModifyGuesturePwd(param: PARAMETERTYPE?) {
        let request = DQSNetworkManager.sharedInstance.requestForData(methodName: "modifyGuesturePwd", bussinessParam: param, success: { (response) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: THJG_NOTIFICATION_VALIDATE_MODIFY_GUESTUREPWD_SUCCESS), object: THJGSuccessBean(bean: nil, msg: response["msg"].string))
        }) { (code, message) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: THJG_NOTIFICATION_NETWORK_FAILURE), object: THJGFailureBean(errorCode: code, msg: message))
        }
        requestQueue.append(request)
    }
}
