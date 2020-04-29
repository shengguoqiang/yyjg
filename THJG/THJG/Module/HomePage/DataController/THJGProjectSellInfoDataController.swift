/**
 * 销售信息DataController
 */

class THJGProjectSellInfoDataController {

    //MARK: 外部所需数据
    /**
     * 销售明细
     */
    var detailBean: THJGProjectSellDetailBean!
    /**
     * 七日销售明细
     */
    var weekBean: THJGProjectSellWeekDetailsBean!
    /**
     * 销售进度
     */
    var planBean: THJGProjectSellPlanBean!
}

//MARK: - 请求相关
extension THJGProjectSellInfoDataController {
    
    /**
     * 请求销售明细
     * @param param 业务参数
     */
    func requestForSellDetailData(_ param: PARAMETERTYPE?,
                                  _ successBlock: @escaping SuccessBlock,
                                  _ failureBlock: FailureBlock?) {
        let group = DispatchGroup()
        group.enter()
        requestForProjectSellDetailData(param, { (bean, msg) in
            group.leave()
        }, failureBlock)
        group.enter()
        requestForProjectWeekSellDetailData(param, { (bean, msg) in
            group.leave()
        }, failureBlock)
        group.notify(queue: .main) {
            successBlock(nil, nil)
        }
    }
    
    /**
     * 获取销售明细数据
     * @param param   业务参数
     */
    fileprivate func requestForProjectSellDetailData(_ param: PARAMETERTYPE?,
                                                     _ successBlock: @escaping SuccessBlock,
                                                     _ failureBlock: FailureBlock?) {
        _ = DQSNetworkManager.sharedInstance.requestForData(methodName: "projectSellDetail", bussinessParam: param, success: { (response) in
            let sellDetailBean = THJGProjectSellDetailBean.parse(response)
            self.detailBean = sellDetailBean
            successBlock(nil, nil)
        }) { (code, message) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: THJG_NOTIFICATION_NETWORK_FAILURE), object: THJGFailureBean(errorCode: code, msg: message))
        }
    }
    
    /**
     * 获取七日销售明细
     * @param param   业务参数
     */
    fileprivate func requestForProjectWeekSellDetailData(_ param: PARAMETERTYPE?,
                                                     _ successBlock: @escaping SuccessBlock,
                                                     _ failureBlock: FailureBlock?) {
        _ = DQSNetworkManager.sharedInstance.requestForData(methodName: "projectSellWeekTotalAndDetail", bussinessParam: param, success: { (response) in
            let weekBean = THJGProjectSellWeekDetailsBean.parse(response)
            self.weekBean = weekBean
            successBlock(nil, nil)
        }) { (code, message) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: THJG_NOTIFICATION_NETWORK_FAILURE), object: THJGFailureBean(errorCode: code, msg: message))
        }
    }
    
    /**
     * 获取销售进度
     * @param param   业务参数
     */
    func requestForProjectSellPlanData(_ param: PARAMETERTYPE?,
                                                     _ successBlock: @escaping SuccessBlock,
                                                     _ failureBlock: FailureBlock?) {
        _ = DQSNetworkManager.sharedInstance.requestForData(methodName: "projectSellPlan", bussinessParam: param, success: { (response) in
            let planBean = THJGProjectSellPlanBean.parse(response)
            self.planBean = planBean
            successBlock(nil, nil)
        }) { (code, message) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: THJG_NOTIFICATION_NETWORK_FAILURE), object: THJGFailureBean(errorCode: code, msg: message))
        }
    }
    
}
