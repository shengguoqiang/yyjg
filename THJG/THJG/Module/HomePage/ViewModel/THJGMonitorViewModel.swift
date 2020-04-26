/**
 * 监控VM
 */

/* 成功通知 */
let THJG_NOTIFICATION_DEVICE_WARNING_NEWDATA_SUCCESS = "THJG_NOTIFICATION_DEVICE_WARNING_NEWDATA_SUCCESS"
let THJG_NOTIFICATION_DEVICE_WARNING_NEWDATA_FAILURE = "THJG_NOTIFICATION_DEVICE_WARNING_NEWDATA_FAILURE"
let THJG_NOTIFICATION_DEVICE_WARNING_MOREDATA_SUCCESS = "THJG_NOTIFICATION_DEVICE_WARNING_MOREDATA_SUCCESS"
let THJG_NOTIFICATION_DEVICE_WARNING_MOREDATA_FAILURE = "THJG_NOTIFICATION_DEVICE_WARNING_MOREDATA_FAILURE"

class THJGMonitorViewModel: THJGBaseViewModel {

    /**
     * 获取设备告警(第一页)
     * @param param   业务参数
     */
    func requestForNewDeviceWarning(param: PARAMETERTYPE?) {
        let request = DQSNetworkManager.sharedInstance.requestForData(methodName: "projectVideoRec", bussinessParam: param, success: { (response) in
            let monitorBean = THJGMonitorBean.parse(response)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: THJG_NOTIFICATION_DEVICE_WARNING_NEWDATA_SUCCESS), object: THJGSuccessBean(bean: monitorBean, msg: nil))
        }) { (code, message) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: THJG_NOTIFICATION_DEVICE_WARNING_NEWDATA_FAILURE), object: THJGFailureBean(errorCode: code, msg: message))
        }
        requestQueue.append(request)
    }
    
    /**
     * 获取设备告警(更多)
     * @param param   业务参数
     */
    func requestForMoreDeviceWarning(param: PARAMETERTYPE?) {
        let request = DQSNetworkManager.sharedInstance.requestForData(methodName: "projectVideoRec", bussinessParam: param, success: { (response) in
            let monitorBean = THJGMonitorBean.parse(response)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: THJG_NOTIFICATION_DEVICE_WARNING_MOREDATA_SUCCESS), object: THJGSuccessBean(bean: monitorBean, msg: nil))
        }) { (code, message) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: THJG_NOTIFICATION_DEVICE_WARNING_MOREDATA_FAILURE), object: THJGFailureBean(errorCode: code, msg: message))
        }
        requestQueue.append(request)
    }
}
