/**
 * 项目用章登记信息实体
 */

struct THJGProjectCachetBean: THJGBaseBean {

    var projectName: String
    var medalsTotal: Int
    var medals: [ProjectCachetSectionBean]
    
    static func parse(_ data: JSONTYPE) -> THJGProjectCachetBean {
        var medals = [ProjectCachetSectionBean]()
        if let medalsArray = data["medals"].array {
            for medal in medalsArray {
                medals.append(ProjectCachetSectionBean.parse(medal))
            }
        }
        return THJGProjectCachetBean(projectName: data["projectName"].string ?? "",
                                     medalsTotal: data["medalsTotal"].int ?? 0,
                                     medals: medals)
    }
}

struct ProjectCachetSectionBean: THJGBaseBean {
    
    var useTime: Int64
    var useDetails: [ProjectCachetCellBean]
    
    static func parse(_ data: JSONTYPE) -> ProjectCachetSectionBean {
        var useDetails = [ProjectCachetCellBean]()
        if let useDetailsArray = data["useDetails"].array {
            for detail in useDetailsArray {
                useDetails.append(ProjectCachetCellBean.parse(detail))
            }
        }
        return ProjectCachetSectionBean(useTime: data["useTime"].int64 ?? 0,
                                        useDetails: useDetails)
    }
}

struct ProjectCachetCellBean: THJGBaseBean {
    
    var cachetOut: Int //0无外借 1有外借
    var cachetDepartment: String
    var cachetUser: String
    var cachetType: String
    var cachetFileName: String
    var cachetPortions: Int
    var cachetInspector: String
    var cachetRemark: String
    var cachetResources: [ProjectCachetResourceBean]
    
    static func parse(_ data: JSONTYPE) -> ProjectCachetCellBean {
        var cachetResources = [ProjectCachetResourceBean]()
        if let cachetResourcesArray = data["cachetResources"].array {
            for cachetRes in cachetResourcesArray {
                cachetResources.append(ProjectCachetResourceBean.parse(cachetRes))
            }
        }
        return ProjectCachetCellBean(cachetOut: data["cachetOut"].int ?? 0,
                                     cachetDepartment: data["cachetDepartment"].string ?? "",
                                     cachetUser: data["cachetUser"].string ?? "",
                                     cachetType: data["cachetType"].string ?? "",
                                     cachetFileName: data["cachetFileName"].string ?? "",
                                     cachetPortions: data["cachetPortions"].int ?? 0,
                                     cachetInspector: data["cachetInspector"].string ?? "",
                                     cachetRemark: data["cachetRemark"].string ?? "",
                                     cachetResources: cachetResources)
    }
}

struct ProjectCachetResourceBean: THJGBaseBean {
    
    var cachetResUrl: String
    var cachetResName: String
    
    static func parse(_ data: JSONTYPE) -> ProjectCachetResourceBean {
        return ProjectCachetResourceBean(cachetResUrl: data["cachetResUrl"].string ?? "",
                                         cachetResName: data["cachetResName"].string ?? "")
    }
}
