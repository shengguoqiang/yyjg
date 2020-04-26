/**
 * 推送VM
 */

class THJGPushViewModel: THJGBaseViewModel {

    /**
     * 将某一条推送消息置为已读
     * @param param   业务参数
     * @param success 成功回调
     * @param failure 失败回调
     */
    func requestForPushMsgRead(param: PARAMETERTYPE?,
                           success: @escaping SuccessBlock,
                           failure: @escaping FailureBlock) {
        DQSNetworkManager.sharedInstance.requestForData(methodName: "pushMsgRead", bussinessParam: param, success: { (response) in
            success(nil, response["msg"].string)
        }) { (code, message) in
            failure(code, message)
        }
    }
}
