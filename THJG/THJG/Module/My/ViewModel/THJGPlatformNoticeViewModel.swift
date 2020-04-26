/**
 * 平台公告VM
 */

/* 成功通知 */
let THJG_NOTIFICATION_PLATFORMINFO_NEW_DATA_SUCCESS = "THJG_NOTIFICATION_PLATFORMINFO_NEW_DATA_SUCCESS"
let THJG_NOTIFICATION_PLATFORMINFO_NEW_DATA_FAILURE = "THJG_NOTIFICATION_PLATFORMINFO_NEW_DATA_FAILURE"

let THJG_NOTIFICATION_PLATFORMINFO_MORE_DATA_SUCCESS = "THJG_NOTIFICATION_PLATFORMINFO_MORE_DATA_SUCCESS"
let THJG_NOTIFICATION_PLATFORMINFO_MORE_DATA_FAILURE = "THJG_NOTIFICATION_PLATFORMINFO_MORE_DATA_FAILURE"

class THJGPlatformNoticeViewModel: THJGBaseViewModel {

    /**
     * 获取平台公告(第一页数据)
     * @param param   业务参数
     */
    func requestForNewPlatformNotices(param: PARAMETERTYPE?) {
        DQSNetworkManager.sharedInstance.requestForData(methodName: "platformInfo", bussinessParam: param, success: { (response) in
            let platformBean = THJGPlatformNoticeBean.parse(response)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: THJG_NOTIFICATION_PLATFORMINFO_NEW_DATA_SUCCESS), object: THJGSuccessBean(bean: platformBean, msg: nil))
        }) { (code, message) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: THJG_NOTIFICATION_PLATFORMINFO_NEW_DATA_FAILURE), object: THJGFailureBean(errorCode: code, msg: message))
        }
    }
    
    /**
     * 获取平台公告(更多)
     * @param param   业务参数
     */
    func requestForMorePlatformNotices(param: PARAMETERTYPE?) {
        DQSNetworkManager.sharedInstance.requestForData(methodName: "platformInfo", bussinessParam: param, success: { (response) in
            let platformBean = THJGPlatformNoticeBean.parse(response)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: THJG_NOTIFICATION_PLATFORMINFO_MORE_DATA_SUCCESS), object: THJGSuccessBean(bean: platformBean, msg: nil))
        }) { (code, message) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: THJG_NOTIFICATION_PLATFORMINFO_MORE_DATA_FAILURE), object: THJGFailureBean(errorCode: code, msg: message))
        }
    }
    
}
