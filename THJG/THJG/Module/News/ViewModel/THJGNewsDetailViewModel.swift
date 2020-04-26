/**
 * 资讯详情VM
 */

/* 成功通知 */
let THJG_NOTIFICATION_NEWS_DETAIL_SUCCESS = "THJG_NOTIFICATION_NEWS_DETAIL_SUCCESS"

class THJGNewsDetailViewModel: THJGBaseViewModel {

    /**
     * 获取资讯详情数据
     * @param param 业务参数
     */
    func requestForNewsDetailData(param: PARAMETERTYPE?) {
        
       let request = DQSNetworkManager.sharedInstance.requestForData(methodName: "newsInfoDetail", bussinessParam: param, success: { (response) in
        let detailBean = THJGNewsDetailBean.parse(response)
            NotificationCenter.default.post(name: NSNotification.Name( THJG_NOTIFICATION_NEWS_DETAIL_SUCCESS), object: THJGSuccessBean(bean: detailBean, msg: nil))
        }) { (code, message) in
            NotificationCenter.default.post(name: NSNotification.Name( THJG_NOTIFICATION_NETWORK_FAILURE), object: THJGFailureBean(errorCode: code, msg: message))
        }
        
        requestQueue.append(request)
    }
}
