/**
 * 工程计划及进度实体
 */

struct THJGProjectPlanBean: THJGBaseBean {
    
    var proName: String
    var proPlans: [ProPlanBean]
    
    static func parse(_ data: JSONTYPE) -> THJGProjectPlanBean {
        var plans = [ProPlanBean]()
        if let plansArray = data["proPlans"].array {
            for plan in plansArray {
                plans.append(ProPlanBean.parse(plan))
            }
        }
        return THJGProjectPlanBean(proName: data["proName"].string ?? "",
                                   proPlans: plans)
    }

}

//MARK: - CELL实体
struct ProPlanBean: THJGBaseBean {
    
    var planStatus: Int
    var planName: String
    var planExpectDate: Int64
    var planActualDate: Int64
    var planRemark: String
    var planProofs: [ProPlanProofBean]
    
    static func parse(_ data: JSONTYPE) -> ProPlanBean {
        var planProofs = [ProPlanProofBean]()
        if let proofArray = data["planProofs"].array {
            for proof in proofArray {
                planProofs.append(ProPlanProofBean.parse(proof))
            }
        }
        return ProPlanBean(planStatus: data["planStatus"].int ?? 0,
                           planName: data["planName"].string ?? "",
                           planExpectDate: data["planExpectDate"].int64 ?? 0,
                           planActualDate: data["planActualDate"].int64 ?? 0,
                           planRemark: data["planRemark"].string ?? "",
                           planProofs: planProofs)
    }
}

//MARK: - 凭证实体
struct ProPlanProofBean: THJGBaseBean {
    
    var proofName: String
    var proofUrl: String
    
    static func parse(_ data: JSONTYPE) -> ProPlanProofBean {
        return ProPlanProofBean(proofName: data["proofName"].string ?? "",
                                proofUrl: data["proofUrl"].string ?? "")
    }
}
