/**
 * 项目销售信息-销售明细
 */

struct THJGProjectSellDetailBean: THJGBaseBean {
    
    var projectName: String
    var projectAvgPrice: Double
    var projectAllSquare: Double
    var projectSelledSquare: Double
    var projectSold: Int
    var projectAll: Int
    var projectDealAll: Double
    var projectRecBack: Double
    var projectOnWay: Double
    var projectSellDetails: [ProjectSellDetailBean]
    
    static func parse(_ data: JSONTYPE) -> THJGProjectSellDetailBean {
        var projectSold: Int = 0
        var projectAll: Int = 0
        var projectDealAll: Double = 0
        var projectRecBack: Double = 0
        var projectOnWay: Double = 0
        var projectSellDetails = [ProjectSellDetailBean]()
        if let projectSellDetailsArray = data["projectSellDetails"].array {
            for detail in projectSellDetailsArray {
                projectSold += detail["proSold"].int ?? 0
                projectAll += detail["proSellable"].int ?? 0
                projectDealAll += detail["proDealTotal"].double ?? 0
                projectRecBack += detail["proRecBack"].double ?? 0
                projectOnWay += detail["proOnWay"].double ?? 0
                projectSellDetails.append(ProjectSellDetailBean.parse(detail))
            }
        }
        return THJGProjectSellDetailBean(projectName: data["projectName"].string ?? "",
                                         projectAvgPrice: data["projectAvgPrice"].double ?? 0,
                                         projectAllSquare: data["projectAllSquare"].double ?? 0,
                                         projectSelledSquare: data["projectSelledSquare"].double ?? 0,
                                         projectSold: projectSold,
                                         projectAll: projectAll,
                                         projectDealAll: projectDealAll,
                                         projectRecBack: projectRecBack,
                                         projectOnWay: projectOnWay,
                                         projectSellDetails: projectSellDetails)
    }
}

struct ProjectSellDetailBean: THJGBaseBean {
    
    var projectId: String
    var proBlock: String
    var proSellable: Int
    var proSold: Int
    var proRecBack: Double
    var proDealTotal: Double
    var proOnWay: Double
    
    static func parse(_ data: JSONTYPE) -> ProjectSellDetailBean {
        return ProjectSellDetailBean(projectId: data["projectId"].string ?? "",
                                     proBlock: data["proBlock"].string ?? "",
                                     proSellable: data["proSellable"].int ?? 0,
                                     proSold: data["proSold"].int ?? 0,
                                     proRecBack: data["proRecBack"].double ?? 0,
                                     proDealTotal: data["proDealTotal"].double ?? 0,
                                     proOnWay: data["proOnWay"].double ?? 0)
    }
}

//MARK: - 幢销售详情
struct THJGProjectBlockSellDetailBean: THJGBaseBean {
    
    var blockDetails: [ProjectBlockSellDetailBean]
    
    static func parse(_ data: JSONTYPE) -> THJGProjectBlockSellDetailBean {
        var blockDetails = [ProjectBlockSellDetailBean]()
        if let blockDetailsArray = data["blockDetails"].array {
            for detail in blockDetailsArray {
                blockDetails.append(ProjectBlockSellDetailBean.parse(detail))
            }
        }
        return THJGProjectBlockSellDetailBean(blockDetails: blockDetails)
    }
}

struct ProjectBlockSellDetailBean: THJGBaseBean {
    
    var projectId: String
    var blockNum: String
    var blockUnit: String
    var unitRoom: String
    var roomSquare: Double
    var roomSellStatus: Int // 10 待售 20 认购 30 网签 40 不可售
    
    static func parse(_ data: JSONTYPE) -> ProjectBlockSellDetailBean {
        return ProjectBlockSellDetailBean(projectId: data["projectId"].string ?? "",
                                          blockNum: data["blockNum"].string ?? "",
                                          blockUnit: data["blockUnit"].string ?? "",
                                          unitRoom: data["unitRoom"].string ?? "",
                                          roomSquare: data["roomSquare"].double ?? 0,
                                          roomSellStatus: data["roomSellStatus"].int ?? 0)
    }
}

//MARK: - 室销售详情
struct THJGProjectRoomSellDetailBean: THJGBaseBean {
    
    var projectName: String
    var resList: [ProjectRoomSellDetailBean]
    
    static func parse(_ data: JSONTYPE) -> THJGProjectRoomSellDetailBean {
        var resList = [ProjectRoomSellDetailBean]()
        if let resListArray = data["resList"].array {
            for res in resListArray {
                resList.append(ProjectRoomSellDetailBean.parse(res))
            }
        }
        return THJGProjectRoomSellDetailBean(projectName: data["projectName"].string ?? "",
                                             resList: resList)
    }
}

struct ProjectRoomSellDetailBean: THJGBaseBean {
    
    var typeName: String
    var infos: [ProjectRoomSellDetailCellBean]
    
    static func parse(_ data: JSONTYPE) -> ProjectRoomSellDetailBean {
        var infos = [ProjectRoomSellDetailCellBean]()
        if let infosArray = data["infos"].array {
            for info in infosArray {
                infos.append(ProjectRoomSellDetailCellBean.parse(info))
            }
        }
        return ProjectRoomSellDetailBean(typeName: data["typeName"].string ?? "",
                                         infos: infos)
    }
}

struct ProjectRoomSellDetailCellBean: THJGBaseBean {
    
    var infoTitle: String
    var infoContent: Any
    
    static func parse(_ data: JSONTYPE) -> ProjectRoomSellDetailCellBean {
        return ProjectRoomSellDetailCellBean(infoTitle: data["infoTitle"].string ?? "",
                                             infoContent: data["infoContent"].rawValue)
    }
}

