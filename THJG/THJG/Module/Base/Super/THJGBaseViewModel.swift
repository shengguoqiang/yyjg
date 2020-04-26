/**
 * ViewModel基类 处理通用请求
 */

import Alamofire

/* 成功通知 */
let THJG_NOTIFICATION_AUTHCODE_SUCCESS = "THJG_NOTIFICATION_AUTHCODE_SUCCESS"
let THJG_NOTIFICATION_AUTHCODE_FAILURE = "THJG_NOTIFICATION_AUTHCODE_FAILURE"

class THJGBaseViewModel: NSObject {

    /* 请求数组 */
    var requestQueue = [DataRequest?]()
    
    /**
     * 获取验证码
     * @param param   业务参数
     */
    func requestForAuthCode(param: PARAMETERTYPE) {
        let request = DQSNetworkManager.sharedInstance.requestForData(methodName: "authCode", bussinessParam: param, success: { (response) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: THJG_NOTIFICATION_AUTHCODE_SUCCESS), object: THJGSuccessBean(bean: nil, msg: response["msg"].string))
        }) { (code, message) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: THJG_NOTIFICATION_AUTHCODE_FAILURE), object: THJGFailureBean(errorCode: code, msg: message))
        }
        requestQueue.append(request)
    }
    
    deinit {
        DQSUtils.log("\(self) was already deallocated!")
        /* 取消请求 */
        for request in requestQueue {
            request?.cancel()
        }
    }
}
