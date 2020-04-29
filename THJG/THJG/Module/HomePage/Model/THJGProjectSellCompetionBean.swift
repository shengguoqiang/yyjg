/**
 * 销售信息-竞品楼盘实体
 */

struct THJGProjectSellCompetionBean: THJGBaseBean {

    var curProject: CurProjectBean
    var competions: [ProjectSellCompetionBean]
    
    static func parse(_ data: JSONTYPE) -> THJGProjectSellCompetionBean {
        var competions = [ProjectSellCompetionBean]()
        if let competionsArray = data["competions"].array {
            for competion in competionsArray {
                competions.append(ProjectSellCompetionBean.parse(competion))
            }
        }
        return THJGProjectSellCompetionBean(curProject: CurProjectBean.parse(data["curProject"]),
                                            
                                            competions: competions)
    }
}

//MARK: - 当前项目
struct CurProjectBean: THJGBaseBean {
    
    var curProName: String
    var curProLocation: String
    var curProUnitPrice: Double
    var curProTotal: Int
    var curProQHRate: Double
    var curProCoordinate: String
    
    static func parse(_ data: JSONTYPE) -> CurProjectBean {
        return CurProjectBean(curProName: data["curProName"].string ?? "",
                              curProLocation: data["curProLocation"].string ?? "",
                              curProUnitPrice: data["curProUnitPrice"].double ?? 0,
                              curProTotal: data["curProTotal"].int ?? 0,
                              curProQHRate: data["curProQHRate"].double ?? 0,
                              curProCoordinate: data["curProCoordinate"].string ?? "")
    }
}

//MARK: - 竞品楼盘
struct ProjectSellCompetionBean: THJGBaseBean {
    
    var competionName: String
    var competionLocation: String
    var competionSellDate: Int64
    var competionRoom: String
    var competionUnitPrice: Double
    var competionAll: Int
    var competionSellRate: String
    var competionRateThreeMonth: String
    var competionSituation: String
    var competionCoordinate: String
    
    static func parse(_ data: JSONTYPE) -> ProjectSellCompetionBean {
        return ProjectSellCompetionBean(competionName: data["competionName"].string ?? "",
                                        competionLocation: data["competionLocation"].string ?? "",
                                        competionSellDate: data["competionSellDate"].int64 ?? 0,
                                        competionRoom: data["competionRoom"].string ?? "",
                                        competionUnitPrice: data["competionUnitPrice"].double ?? 0,
                                        competionAll: data["competionAll"].int ?? 0,
                                        competionSellRate: data["competionSellRate"].string ?? "",
                                        competionRateThreeMonth: data["competionRateThreeMonth"].string ?? "",
                                        competionSituation: data["competionSituation"].string ?? "",
                                        competionCoordinate: data["competionCoordinate"].string ?? "")
    }
}

struct ProjectSellCompetionDetailBean {
    
    var title: String
    var content: String
    var cellHeight: CGFloat
}
