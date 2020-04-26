/**
 * 资讯VM
 */

/* 成功通知 */
let THJG_NOTIFICATION_NEWS_NEWDATA_SUCCESS = "THJG_NOTIFICATION_NEWS_NEWDATA_SUCCESS"
let THJG_NOTIFICATION_NEWS_NEWDATA_FAILURE = "THJG_NOTIFICATION_NEWS_NEWDATA_FAILURE"

let THJG_NOTIFICATION_NEWS_MOREDATA_SUCCESS = "THJG_NOTIFICATION_NEWS_MOREDATA_SUCCESS"
let THJG_NOTIFICATION_NEWS_MOREDATA_FAILURE = "THJG_NOTIFICATION_NEWS_MOREDATA_FAILURE"


class THJGNewsViewModel: THJGBaseViewModel {

    /**
     * 获取资讯数据(第一页)
     * @param param   业务参数
     */
    func requestForNewsNewData(param: PARAMETERTYPE?) {
        let request = DQSNetworkManager.sharedInstance.requestForData(methodName: "newsInfoList", bussinessParam: param, success: { (response) in
            let newsInfoBean = THJGNewsInfoBean.parse(response)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: THJG_NOTIFICATION_NEWS_NEWDATA_SUCCESS), object: THJGSuccessBean(bean: newsInfoBean, msg: nil))
        }) { (code, message) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: THJG_NOTIFICATION_NEWS_NEWDATA_FAILURE), object: THJGFailureBean(errorCode: code, msg: message))
        }
        requestQueue.append(request)
    }
    
    /**
     * 获取资讯数据(更多)
     * @param param   业务参数
     */
    func requestForNewsMoreData(param: PARAMETERTYPE?) {
        let request = DQSNetworkManager.sharedInstance.requestForData(methodName: "newsInfoList", bussinessParam: param, success: { (response) in
            let newsInfoBean = THJGNewsInfoBean.parse(response)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: THJG_NOTIFICATION_NEWS_MOREDATA_SUCCESS), object: THJGSuccessBean(bean: newsInfoBean, msg: nil))
        }) { (code, message) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: THJG_NOTIFICATION_NEWS_MOREDATA_FAILURE), object: THJGFailureBean(errorCode: code, msg: message))
        }
        requestQueue.append(request)
    }
}
