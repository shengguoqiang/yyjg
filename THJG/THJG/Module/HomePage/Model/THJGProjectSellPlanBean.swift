/**
 * 项目销售信息-计划与进度
 */

struct THJGProjectSellPlanBean: THJGBaseBean {

    var plans: [ProjectSellPlanBean]
    
    static func parse(_ data: JSONTYPE) -> THJGProjectSellPlanBean {
        var plans = [ProjectSellPlanBean]()
        if let plansArray = data["plans"].array {
            for plan in plansArray {
                plans.append(ProjectSellPlanBean.parse(plan))
            }
        }
        return THJGProjectSellPlanBean(plans: plans)
    }
}

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
