/**
 * 项目销售信息VM
 */

/* 成功通知 */
let THJG_NOTIFICATION_SELLINFO_DETAIL_SUCCESS = "THJG_NOTIFICATION_SELLINFO_DETAIL_SUCCESS"
let THJG_NOTIFICATION_SELLINFO_BLOCK_DETAIL_SUCCESS = "THJG_NOTIFICATION_SELLINFO_BLOCK_DETAIL_SUCCESS"
let THJG_NOTIFICATION_SELLINFO_ROOM_DETAIL_SUCCESS = "THJG_NOTIFICATION_SELLINFO_ROOM_DETAIL_SUCCESS"

let THJG_NOTIFICATION_SELLINFO_PLAN_SUCCESS = "THJG_NOTIFICATION_SELLINFO_PLAN_SUCCESS"

let THJG_NOTIFICATION_SELLINFO_COMPETION_SUCCESS = "THJG_NOTIFICATION_SELLINFO_COMPETION_SUCCESS"

//MARK: - 处理数据
//销售明细
struct ProjectSellDetailHandledBean {
    var headerBean: ProjectSellDetailBean
    var isSelected: (Bool, [ProjectBlockSellDetailBean]?)
}

class THJGProjectSellInfoViewModel: THJGBaseViewModel {

    /**
     * 获取销售明细数据
     * @param param   业务参数
     */
    func requestForProjectSellDetailData(param: PARAMETERTYPE?) {
        let request = DQSNetworkManager.sharedInstance.requestForData(methodName: "projectSellDetail", bussinessParam: param, success: { (response) in
            let sellDetailBean = THJGProjectSellDetailBean.parse(response)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: THJG_NOTIFICATION_SELLINFO_DETAIL_SUCCESS), object: THJGSuccessBean(bean: sellDetailBean, msg: nil))
        }) { (code, message) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: THJG_NOTIFICATION_NETWORK_FAILURE), object: THJGFailureBean(errorCode: code, msg: message))
        }
        requestQueue.append(request)
    }
    
    /**
     * 获取幢销售明细数据
     * @param param   业务参数
     */
    func requestForProjectBlockSellDetailData(param: PARAMETERTYPE?) {
        let request = DQSNetworkManager.sharedInstance.requestForData(methodName: "projectBlockSellDetail", bussinessParam: param, success: { (response) in
            let blockDetailBean = THJGProjectBlockSellDetailBean.parse(response)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: THJG_NOTIFICATION_SELLINFO_BLOCK_DETAIL_SUCCESS), object: THJGSuccessBean(bean: blockDetailBean, msg: nil))
        }) { (code, message) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: THJG_NOTIFICATION_NETWORK_FAILURE), object: THJGFailureBean(errorCode: code, msg: message))
        }
        requestQueue.append(request)
    }
    
    /**
     * 获取室销售明细数据
     * @param param   业务参数
     */
    func requestForProjectRoomSellDetailData(param: PARAMETERTYPE?) {
        let request = DQSNetworkManager.sharedInstance.requestForData(methodName: "projectRoomSellDetail", bussinessParam: param, success: { (response) in
            let roomDetialBean = THJGProjectRoomSellDetailBean.parse(response)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: THJG_NOTIFICATION_SELLINFO_ROOM_DETAIL_SUCCESS), object: THJGSuccessBean(bean: roomDetialBean, msg: nil))
        }) { (code, message) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: THJG_NOTIFICATION_NETWORK_FAILURE), object: THJGFailureBean(errorCode: code, msg: message))
        }
        requestQueue.append(request)
    }
    
    /**
     * 获取计划与进度数据
     * @param param   业务参数
     * @param success 成功回调
     * @param failure 失败回调
     */
    func requestForProjectPlanData(param: PARAMETERTYPE?) {
        let request = DQSNetworkManager.sharedInstance.requestForData(methodName: "projectSellPlan", bussinessParam: param, success: { (response) in
            let planBean = THJGProjectSellPlanBean.parse(response)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: THJG_NOTIFICATION_SELLINFO_PLAN_SUCCESS), object: THJGSuccessBean(bean: planBean, msg: nil))
        }) { (code, message) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: THJG_NOTIFICATION_NETWORK_FAILURE), object: THJGFailureBean(errorCode: code, msg: message))
        }
        requestQueue.append(request)
    }
    
    /**
     * 获取竞品楼盘数据
     * @param param   业务参数
     */
    func requestForProjectCompetionData(param: PARAMETERTYPE?) {
        let request = DQSNetworkManager.sharedInstance.requestForData(methodName: "projectSellCompetion", bussinessParam: param, success: { (response) in
           let competionBean = THJGProjectSellCompetionBean.parse(response)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: THJG_NOTIFICATION_SELLINFO_COMPETION_SUCCESS), object: THJGSuccessBean(bean: competionBean, msg: nil))
        }) { (code, message) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: THJG_NOTIFICATION_NETWORK_FAILURE), object: THJGFailureBean(errorCode: code, msg: message))
        }
        requestQueue.append(request)
    }

}

//MARK: - METHODS
extension THJGProjectSellInfoViewModel {
    
    //处理销售明细数据
     func handleSellDetailData(_ bean: THJGProjectSellDetailBean) -> [ProjectSellDetailHandledBean] {
        var handledDetails = [ProjectSellDetailHandledBean]()
        let details = bean.projectSellDetails
        for detail in details {
            handledDetails.append(ProjectSellDetailHandledBean(headerBean: detail, isSelected: (false, nil)))
        }
        return handledDetails
    }
}
