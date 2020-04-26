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

//计划与进度
enum ProjectSellPlanCellPostion {
    case left
    case right
}
enum ProjectSellPlanCellStatus {
    case ahead
    case normal
    case delay
    case unFinished
}
struct ProjectSellPlanHandledBean {
    var cellBean: ProjectSellPlanBean
    var cellHeight: CGFloat
    var cellPosition: ProjectSellPlanCellPostion
    var cellStatus: ProjectSellPlanCellStatus
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
    
    //处理计划与进度数据
     func handleSellPlanData(_ bean: THJGProjectSellPlanBean) -> [ProjectSellPlanHandledBean] {
        var handledBeans = [ProjectSellPlanHandledBean]()
        let plans = bean.plans
        for (index, plan) in plans.enumerated() {
            //计算行高
            var cellHeight: CGFloat = 90
            if DQSUtils.isNotBlank(plan.planRemark) {
               let textHeight = DQSUtils.heightForText(text: plan.planRemark, fixedWidth: SCREEN_WIDTH/2-35, fixedFont: UIFont.systemFont(ofSize: 14)) + 20
                cellHeight += textHeight
            }
            //计算位置
            let position: ProjectSellPlanCellPostion = (index % 2 == 0) ?  .right : .left
            //计算状态
            var status: ProjectSellPlanCellStatus = .normal
            if DQSUtils.isNotBlank(plan.planActual) {//超前
                if (Double(plan.planExpect) ?? 0) < (Double(plan.planActual) ?? 0) {
                    status = .ahead
                } else if (Double(plan.planExpect) ?? 0) == (Double(plan.planActual) ?? 0) {//正常
                    status = .normal
                } else {//延迟
                    status = .delay
                }
            } else {//待完成
                status = .unFinished
            }
            handledBeans.append(ProjectSellPlanHandledBean(cellBean: plan, cellHeight: cellHeight, cellPosition: position, cellStatus: status))
        }
        return handledBeans
    }
}
