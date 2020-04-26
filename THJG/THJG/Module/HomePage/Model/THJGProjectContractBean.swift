/**
 * 项目合同台账实体
 */

struct THJGProjectContractBean: THJGBaseBean {

    var contracts: [ProjectContractBean]
    
    static func parse(_ data: JSONTYPE) -> THJGProjectContractBean {
        var contracts = [ProjectContractBean]()
        if let contractsArray = data["contracts"].array {
            for contract in contractsArray {
                contracts.append(ProjectContractBean.parse(contract))
            }
        }
        return THJGProjectContractBean(contracts: contracts)
    }
}

struct ProjectContractBean: THJGBaseBean {
    
    var conProjectId: String
    var conDepartmentName: String
    var conName: String
    var conSum: Double
    var conAppointAmount: Double
    var conActualAmount: Double
    var conContentUrl: String
    
    static func parse(_ data: JSONTYPE) -> ProjectContractBean {
        return ProjectContractBean(conProjectId: data["conProjectId"].string ?? "",
                                   conDepartmentName: data["conDepartmentName"].string ?? "",
                                   conName: data["conName"].string ?? "",
                                   conSum: data["conSum"].double ?? 0,
                                   conAppointAmount: data["conAppointAmount"].double ?? 0,
                                   conActualAmount: data["conActualAmount"].double ?? 0,
                                   conContentUrl: data["conContentUrl"].string ?? "")
    }
}

//MARK: - 合同台账明细实体
struct THJGProjectContractDetailBean: THJGBaseBean {
    
    var appointDetails: [ProjectContractAppointDetailBean]
    var actualDetails: [ProjectContractActualDetailBean]
    var actualSum: Double
    
    static func parse(_ data: JSONTYPE) -> THJGProjectContractDetailBean {
        var appointDetails = [ProjectContractAppointDetailBean]()
        var actualDetails = [ProjectContractActualDetailBean]()
        var actualSum: Double = 0
        if let appointDetailsArray = data["appointDetails"].array {
            for appoint in appointDetailsArray {
                appointDetails.append(ProjectContractAppointDetailBean.parse(appoint))
            }
        }
        if let actualDetailsArray = data["actualDetails"].array {
            for actual in actualDetailsArray {
                actualDetails.append(ProjectContractActualDetailBean.parse(actual))
                actualSum += actual["conActualAmount"].double ?? 0
            }
        }
        return THJGProjectContractDetailBean(appointDetails: appointDetails,
                                             actualDetails: actualDetails,
                                             actualSum: actualSum)
    }
}

// 合同台账-预计付款明细
struct ProjectContractAppointDetailBean: THJGBaseBean {
    
    var conAppointNode: String
    var cellHeight: CGFloat
    
    static func parse(_ data: JSONTYPE) -> ProjectContractAppointDetailBean {
        var cellHeight: CGFloat = 45
        if let node = data["conAppointNode"].string {
           let textHeight = DQSUtils.heightForText(text: node, fixedWidth: SCREEN_WIDTH-80, fixedFont: UIFont.systemFont(ofSize: 14))
           cellHeight += textHeight
        }
        return ProjectContractAppointDetailBean(conAppointNode: data["conAppointNode"].string ?? "",
                                                cellHeight: cellHeight)
    }
}

// 合同台账-实际付款明细
struct ProjectContractActualDetailBean: THJGBaseBean {
 
    var conActualTime: Int64
    var conActualAmount: Double
    
    static func parse(_ data: JSONTYPE) -> ProjectContractActualDetailBean {
        return ProjectContractActualDetailBean(conActualTime: data["conActualTime"].int64 ?? 0,
                                               conActualAmount: data["conActualAmount"].double ?? 0)
    }
}


