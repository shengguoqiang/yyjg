/**
 * 项目开发成本及费用实体
 */

struct THJGProjectDevCostBean: THJGBaseBean {
    
    var proName: String
    var proPlanCost: Double
    var proActualCost: Double
    var bigTypes: [ProDevCostBigTypeBean]
    
    static func parse(_ data: JSONTYPE) -> THJGProjectDevCostBean {
        var bigTypes = [ProDevCostBigTypeBean]()
        var proPlanCost: Double = 0
        var proActualCost: Double = 0
        if let bigTypesArray = data["bigTypes"].array {
            for bigType in bigTypesArray {
                let bigTypeBean = ProDevCostBigTypeBean.parse(bigType)
                bigTypes.append(bigTypeBean)
                proActualCost += bigTypeBean.bigTypeAcutalSum
                proPlanCost += bigTypeBean.bigTypePlanSum
            }
        }
        return THJGProjectDevCostBean(proName: data["proName"].string ?? "",
                                      proPlanCost: proPlanCost,
                                      proActualCost: proActualCost,
                                      bigTypes: bigTypes)
    }
    
}

//MARK: - 开发成本大类实体
struct ProDevCostBigTypeBean: THJGBaseBean {
    
    var bigTypeName: String
    var smallTypes: [ProDevCostSmallTypeBean]
    var bigTypePlanSum: Double
    var bigTypeAcutalSum: Double
    
    static func parse(_ data: JSONTYPE) -> ProDevCostBigTypeBean {
        var smallTypes = [ProDevCostSmallTypeBean]()
        var bigTypePlanSum: Double = 0
        var bigTypeAcutalSum: Double = 0
        if let smallTypesArray = data["smallTypes"].array {
            for smallType in smallTypesArray {
                smallTypes.append(ProDevCostSmallTypeBean.parse(smallType))
                bigTypePlanSum += (smallType["smallTypePlanCost"].double ?? 0)
                bigTypeAcutalSum += (smallType["smallTypeActualCost"].double ?? 0)
            }
        }
        return ProDevCostBigTypeBean(bigTypeName: data["bigTypeName"].string ?? "",
                                     smallTypes: smallTypes,
                                     bigTypePlanSum: bigTypePlanSum,
                                     bigTypeAcutalSum: bigTypeAcutalSum)
    }
}

//MARK: - 开发成本小类实体
struct ProDevCostSmallTypeBean: THJGBaseBean {
    
    var smallTypeId: String
    var smallTypeName: String
    var smallTypePlanCost: Double
    var smallTypeActualCost: Double
    
    static func parse(_ data: JSONTYPE) -> ProDevCostSmallTypeBean {
        return ProDevCostSmallTypeBean(smallTypeId: data["smallTypeId"].string ?? "",
                                       smallTypeName: data["smallTypeName"].string ?? "",
                                       smallTypePlanCost: data["smallTypePlanCost"].double ?? 0,
                                       smallTypeActualCost: data["smallTypeActualCost"].double ?? 0)
    }
}

//MARK: - 开发成本明细实体
struct ProDevCostDetailBean: THJGBaseBean {
    
    var costDetailNode: String
    var costDetailActualCost: Double
    
    static func parse(_ data: JSONTYPE) -> ProDevCostDetailBean {
        return ProDevCostDetailBean(costDetailNode: data["costDetailNode"].string ?? "",
                                    costDetailActualCost: data["costDetailActualCost"].double ?? 0)
    }
}

//MARK: - 开发成本明细拓展方法
extension ProDevCostDetailBean {
    static func parseDevCostDetail(_ data: JSONTYPE) -> [ProDevCostDetailBean] {
        var details = [ProDevCostDetailBean]()
        if let detailsArray = data["costDetails"].array {
            for detail in detailsArray {
                details.append(ProDevCostDetailBean.parse(detail))
            }
        }
        return details
    }
}
