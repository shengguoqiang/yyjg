/**
 * 项目销售信息-计划与进度
 */

struct THJGProjectSellPlanBean: THJGBaseBean {

    
    /**
     * 计划列表
     */
    var plans: [THJGProjectSellPlanBlockBean]
    
    static func parse(_ data: JSONTYPE) -> THJGProjectSellPlanBean {
        var plans = [THJGProjectSellPlanBlockBean]()
        if let planArr = data["plans"].array {
            for plan in planArr {
                plans.append(THJGProjectSellPlanBlockBean.parse(plan))
            }
        }
        return THJGProjectSellPlanBean(plans: plans)
    }
    
}

struct THJGProjectSellPlanBlockBean: THJGBaseBean {
    /**
     * 幢号
     */
    var planBuildingNum: String
    /**
     * 进度列表
     */
    var planDetailList: [THJGProjectSellPlanBlockDetailBean]
    
    static func parse(_ data: JSONTYPE) -> THJGProjectSellPlanBlockBean {
        var planDetailList = [THJGProjectSellPlanBlockDetailBean]()
        if let planArr = data["planDetailList"].array {
            for plan in planArr {
                planDetailList.append(THJGProjectSellPlanBlockDetailBean.parse(plan))
            }
        }
        return THJGProjectSellPlanBlockBean(planBuildingNum: data["planBuildingNum"].string ?? "",
                                            planDetailList: planDetailList)
    }
}

struct THJGProjectSellPlanBlockDetailBean: THJGBaseBean {
    
    /**
     * 时间节点
     */
     var planDate: Int64
    /**
     * 预计进度
     */
     var planExpect: String
    /**
     * 实际日期
     */
     var planActFinishDate: Int64
    /**
     * 节点状态 （1：延迟2：正常，3：超前，4：待完成）
     */
    var planStatus: Int
    /**
     * 备注
     */
     var planRemark: String
    
    static func parse(_ data: JSONTYPE) -> THJGProjectSellPlanBlockDetailBean {
        return THJGProjectSellPlanBlockDetailBean(planDate: data["planDate"].int64 ?? 0,
                                                  planExpect: data["planExpect"].string ?? "",
                                                  planActFinishDate: data["planActFinishDate"].int64 ?? 0,
                                                  planStatus: data["planStatus"].int ?? 0,
                                                  planRemark: data["planRemark"].string ?? "")
    }
    
}

//MARK: 废弃！！！
struct ProjectSellPlanBean: THJGBaseBean {

    var planDate: Int64
    var planExpect: String
    var planActual: String
    var planRemark: String
    
    static func parse(_ data: JSONTYPE) -> ProjectSellPlanBean {
        return ProjectSellPlanBean(planDate: data["planDate"].int64 ?? 0,
                                   planExpect: data["planExpect"].string ?? "",
                                   planActual: data["planActual"].string ?? "",
                                   planRemark: data["planRemark"].string ?? "")
    }
}
