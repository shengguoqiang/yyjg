/**
 * 萤石视频VM
 */

typealias EZOpenSuccessBlock = (String) -> Void

class THJGEZOpenViewModel: THJGBaseViewModel {

    /**
     * 获取萤石视频accessToken
     * @param param   业务参数
     * @param success 成功回调
     * @param failure 失败回调
     */
    func requestForEZOpenAccessToken(param: PARAMETERTYPE?,
                                success: @escaping EZOpenSuccessBlock,
                                failure: @escaping FailureBlock) {
        DQSNetworkManager.sharedInstance.requestForData(methodName: "appMonitorToken", bussinessParam: param, success: { (response) in
            success(response["accessToken"].string ?? "")
        }) { (code, message) in
            failure(code, message)
        }
    }
}
