/**
 * 修改绑定手机号VM
 */

/* 成功通知 */
let THJG_NOTIFICATION_MY_MODIFYPHONE_SUCCESS = "THJG_NOTIFICATION_MY_MODIFYPHONE_SUCCESS"

class THJGModifyPhoneViewModel: THJGBaseViewModel {

    /**
     * 修改绑定手机号
     * @param param   业务参数
     */
    func requestForModifyPhone(param: PARAMETERTYPE?) {
        let request = DQSNetworkManager.sharedInstance.requestForData(methodName: "modifyPhone", bussinessParam: param, success: { (response) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: THJG_NOTIFICATION_MY_MODIFYPHONE_SUCCESS), object: THJGSuccessBean(bean: nil, msg: response["msg"].string))
        }) { (code, message) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: THJG_NOTIFICATION_NETWORK_FAILURE), object: THJGFailureBean(errorCode: code, msg: message))
        }
        requestQueue.append(request)
    }
}
