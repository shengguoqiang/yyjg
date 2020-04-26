/**
 * 平台公告详情VM
 */

/* 成功通知 */
let THJG_NOTIFICATION_PLATFORM_DETAIL_SUCCESS = "THJG_NOTIFICATION_PLATFORM_DETAIL_SUCCESS"

class THJGPlatformNoticeDetailViewModel: THJGBaseViewModel {
    
    /**
     * 查看平台公告详情
     * @param param   业务参数
     */
    func requestForPlatformNoticeDetail(param: PARAMETERTYPE?) {
        DQSNetworkManager.sharedInstance.requestForData(methodName: "platformInfoDetail", bussinessParam: param, success: { (response) in
            let detailBean = THJGPlatformNoticeDetailBean.parse(response)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: THJG_NOTIFICATION_PLATFORM_DETAIL_SUCCESS), object: THJGSuccessBean(bean: detailBean, msg: nil))
        }) { (code, message) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: THJG_NOTIFICATION_NETWORK_FAILURE), object: THJGFailureBean(errorCode: code, msg: message))
        }
    }
}
