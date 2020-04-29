/**
 * 日销售DataController
 */

class THJGProjectSellDayDetailDataController {

    //MARK: 外部所需数据
    /**
     * 月销售明细
     */
    var detailBean: THJGProjectSellDayDetailBean!
    
}

//MARK: - 请求相关
extension THJGProjectSellDayDetailDataController {
    
    /**
     * 获取数据
     * @param param   业务参数
     */
    func requestForData(_ param: PARAMETERTYPE?,
                        _ successBlock: @escaping SuccessBlock,
                        _ failureBlock: FailureBlock?) {
        _ = DQSNetworkManager.sharedInstance.requestForData(methodName: "projectSellDailyList", bussinessParam: param, success: { (response) in
            let sellDetailBean = THJGProjectSellDayDetailBean.parse(response)
            self.detailBean = sellDetailBean
            successBlock(nil, nil)
        }) { (code, message) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: THJG_NOTIFICATION_NETWORK_FAILURE), object: THJGFailureBean(errorCode: code, msg: message))
        }
    }
    
}
