/**
 * 工程计划及进度VM
 */

/* 成功通知 */
let THJG_NOTIFICATION_PROJECTPLAN_NEW_DATA_SUCCESS = "THJG_NOTIFICATION_PROJECTPLAN_NEW_DATA_SUCCESS"
let THJG_NOTIFICATION_PROJECTPLAN_NEW_DATA_FAILURE = "THJG_NOTIFICATION_PROJECTPLAN_NEW_DATA_FAILURE"

let THJG_NOTIFICATION_PROJECTPLAN_MORE_DATA_SUCCESS = "THJG_NOTIFICATION_PROJECTPLAN_MORE_DATA_SUCCESS"
let THJG_NOTIFICATION_PROJECTPLAN_MORE_DATA_FAILURE = "THJG_NOTIFICATION_PROJECTPLAN_MORE_DATA_FAILURE"

//工程计划及进度处理过的实体
struct THJGProPlanHandledBean {
    var cellBean: ProPlanBean
    var cellHeight: CGFloat
}

//工程计划及进度回调
typealias ProjectPlanSuccessBlock = (THJGProjectPlanBean, [THJGProPlanHandledBean]) -> Void

class THJGProjectPlanViewModel: THJGBaseViewModel {

    /**
     * 获取工程计划及进度数据(第一页)
     * @param param   业务参数
     */
    func requestForNewProPlanData(param: PARAMETERTYPE?) {
        let request = DQSNetworkManager.sharedInstance.requestForData(methodName: "projectPlan", bussinessParam: param, success: {(response) in
            let proPlanBean = THJGProjectPlanBean.parse(response)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: THJG_NOTIFICATION_PROJECTPLAN_NEW_DATA_SUCCESS), object: THJGSuccessBean(bean: proPlanBean, msg: nil))
        }) { (code, message) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: THJG_NOTIFICATION_PROJECTPLAN_NEW_DATA_FAILURE), object: THJGFailureBean(errorCode: code, msg: message))
        }
        requestQueue.append(request)
    }
    
    /**
     * 获取工程计划及进度数据(更多)
     * @param param   业务参数
     */
    func requestForMoreProPlanData(param: PARAMETERTYPE?) {
        let request = DQSNetworkManager.sharedInstance.requestForData(methodName: "projectPlan", bussinessParam: param, success: {(response) in
            let proPlanBean = THJGProjectPlanBean.parse(response)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: THJG_NOTIFICATION_PROJECTPLAN_MORE_DATA_SUCCESS), object: THJGSuccessBean(bean: proPlanBean, msg: nil))
        }) { (code, message) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: THJG_NOTIFICATION_PROJECTPLAN_MORE_DATA_SUCCESS), object: THJGFailureBean(errorCode: code, msg: message))
        }
        requestQueue.append(request)
    }
    
}

extension THJGProjectPlanViewModel {
    /**
     * 处理原始数据，根据内容计算cell的高度
     *
     */
    func handleData(_ bean: THJGProjectPlanBean) -> [THJGProPlanHandledBean] {
        var handledPlans = [THJGProPlanHandledBean]()
        let plans = bean.proPlans
        for plan in plans {
            //计算cell高度
            var cellHeight: CGFloat = 100 //起始高度（可以包含cell中的前两行元素）
            if plan.planActualDate != 0 {//包含实际日期
                cellHeight += 38
            }
            if DQSUtils.isNotBlank(plan.planRemark) {//包含备注
                let remarkHeight = DQSUtils.heightForText(text: plan.planRemark, fixedWidth: SCREEN_WIDTH - 140 - 16, fixedFont: UIFont.systemFont(ofSize: 14)) + 30
                cellHeight += remarkHeight
            }
            if !plan.planProofs.isEmpty {//包含凭证
                cellHeight += 125
            }
            
            //添加至数组
            handledPlans.append(THJGProPlanHandledBean(cellBean: plan, cellHeight: cellHeight))
        }
        return handledPlans
    }
}
