/**
 * 站内信详情VM
 */

/* 成功通知 */
let THJG_NOTIFICATION_INNER_MSG_DETAIL_SUCCESS = "THJG_NOTIFICATION_INNER_MSG_DETAIL_SUCCESS"

class THJGInnerMsgDetailViewModel: THJGBaseViewModel {
    
    /**
     * 查看消息详情
     * @param param   业务参数
     */
    func requestForMsgDetail(param: PARAMETERTYPE?) {
        let request = DQSNetworkManager.sharedInstance.requestForData(methodName: "msgInfoDetail", bussinessParam: param, success: { (response) in
            let detailBean = InnerMsgBean.parse(response)
            NotificationCenter.default.post(name: NSNotification.Name(THJG_NOTIFICATION_INNER_MSG_DETAIL_SUCCESS), object: THJGSuccessBean(bean: detailBean, msg: nil))
        }) { (code, message) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: THJG_NOTIFICATION_NETWORK_FAILURE), object: THJGFailureBean(errorCode: code, msg: message))
        }
        requestQueue.append(request)
    }

    /**
     * 将某一条站内信置为已读
     * @param param   业务参数
     * @param success 成功回调
     * @param failure 失败回调
     */
    func requestForReadMsg(param: PARAMETERTYPE?,
                           success: @escaping SuccessBlock,
                           failure: @escaping FailureBlock) {
        let request = DQSNetworkManager.sharedInstance.requestForData(methodName: "msgInfoRead", bussinessParam: param, success: { (response) in
            success(nil, response["msg"].string)
        }) { (code, message) in
            failure(code, message)
        }
        requestQueue.append(request)
    }
}
