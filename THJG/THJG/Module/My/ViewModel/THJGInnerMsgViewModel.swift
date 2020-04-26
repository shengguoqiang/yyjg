/**
 * 站内信VM
 */

/* 成功通知 */
let THJG_NOTIFICATION_INNERMSG_NEW_DATA_SUCCESS = "THJG_NOTIFICATION_INNERMSG_NEW_DATA_SUCCESS"
let THJG_NOTIFICATION_INNERMSG_NEW_DATA_FAILURE = "THJG_NOTIFICATION_INNERMSG_NEW_DATA_FAILURE"

let THJG_NOTIFICATION_INNERMSG_MORE_DATA_SUCCESS = "THJG_NOTIFICATION_INNERMSG_MORE_DATA_SUCCESS"
let THJG_NOTIFICATION_INNERMSG_MORE_DATA_FAILURE = "THJG_NOTIFICATION_INNERMSG_MORE_DATA_FAILURE"

let THJG_NOTIFICATION_INNERMSG_READ_SUCCESS = "THJG_NOTIFICATION_INNERMSG_READ_SUCCESS"

class THJGInnerMsgViewModel: THJGBaseViewModel {

    /**
     * 获取站内信信息(第一页)
     * @param param   业务参数
     */
    func requestForInnerMsgNewData(param: PARAMETERTYPE?) {
        let request = DQSNetworkManager.sharedInstance.requestForData(methodName: "msgInfo", bussinessParam: param, success: { (response) in
            let innerMsgBean = THJGInnerMsgBean.parse(response)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: THJG_NOTIFICATION_INNERMSG_NEW_DATA_SUCCESS), object: THJGSuccessBean(bean: innerMsgBean, msg: nil))
        }) { (code, message) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: THJG_NOTIFICATION_INNERMSG_NEW_DATA_FAILURE), object: THJGFailureBean(errorCode: code, msg: message))
        }
        requestQueue.append(request)
    }
    
    /**
     * 获取站内信信息(更多)
     * @param param   业务参数
     */
    func requestForInnerMsgMoreData(param: PARAMETERTYPE?) {
        let request = DQSNetworkManager.sharedInstance.requestForData(methodName: "msgInfo", bussinessParam: param, success: { (response) in
            let innerMsgBean = THJGInnerMsgBean.parse(response)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: THJG_NOTIFICATION_INNERMSG_MORE_DATA_SUCCESS), object: THJGSuccessBean(bean: innerMsgBean, msg: nil))
        }) { (code, message) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: THJG_NOTIFICATION_INNERMSG_MORE_DATA_FAILURE), object: THJGFailureBean(errorCode: code, msg: message))
        }
        requestQueue.append(request)
    }
    
    /**
     * 将站内信置为【全部已读】
     * @param param   业务参数
     */
    func requestForAllReadMsgs(param: PARAMETERTYPE?) {
        let request = DQSNetworkManager.sharedInstance.requestForData(methodName: "msgInfoAllRead", bussinessParam: param, success: { (response) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: THJG_NOTIFICATION_INNERMSG_READ_SUCCESS), object: THJGSuccessBean(bean: nil, msg: response["msg"].string))
        }) { (code, message) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: THJG_NOTIFICATION_NETWORK_FAILURE), object: THJGFailureBean(errorCode: code, msg: message))
        }
        requestQueue.append(request)
    }
    
}
