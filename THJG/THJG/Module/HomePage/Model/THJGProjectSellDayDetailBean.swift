/**
 * 日销售明细实体
 */

struct THJGProjectSellDayDetailBean: THJGBaseBean {

    /**
     * 销售总数
     */
    var projectSellSoldTotal: Int
    /**
     * 销售总金额
     */
    var projectSellDfinalAmountTotal: Double
    /**
     * 每月详情列表
     */
    var projectSellDailyDetails: [THJGProjectSellDayDetailMonthBean]
    
    static func parse(_ data: JSONTYPE) -> THJGProjectSellDayDetailBean {
        var projectSellDailyDetails = [THJGProjectSellDayDetailMonthBean]()
        if let monthArr = data["projectSellDailyDetails"].array {
            for month in monthArr {
                projectSellDailyDetails.append(THJGProjectSellDayDetailMonthBean.parse(month))
            }
        }
        return THJGProjectSellDayDetailBean(projectSellSoldTotal: data["projectSellSoldTotal"].int ?? 0,
                                            projectSellDfinalAmountTotal: data["projectSellDfinalAmountTotal"].double ?? 0.0,
                                            projectSellDailyDetails: projectSellDailyDetails)
    }
    
}

struct THJGProjectSellDayDetailMonthBean: THJGBaseBean {
    
    /**
     * 时间
     */
    var proSellDateMonth: String
    /**
     * 销售量
     */
    var proSoldTotal: Int
    /**
     * 销售金额
     */
    var proDfinalAmountTotal: Double
    /**
     * 是否选中
     */
    var isSelected: Bool
    /**
     * 每日销售明细列表
     */
    var proSellDetails: [THJGProjectSellDayDetailDayBean]
    
    static func parse(_ data: JSONTYPE) -> THJGProjectSellDayDetailMonthBean {
        var proSellDetails = [THJGProjectSellDayDetailDayBean]()
        if let detailArr = data["proSellDetails"].array {
            for detail in detailArr {
                proSellDetails.append(THJGProjectSellDayDetailDayBean.parse(detail))
            }
        }
        return THJGProjectSellDayDetailMonthBean(proSellDateMonth: data["proSellDateMonth"].string ?? "",
                                                 proSoldTotal: data["proSoldTotal"].int ?? 0,
                                                 proDfinalAmountTotal: data["proDfinalAmountTotal"].double ?? 0.0,
                                                 isSelected: false,
                                                 proSellDetails: proSellDetails)
    }
    
}

struct THJGProjectSellDayDetailDayBean: THJGBaseBean {
    
    /**
     * 时间
     */
    var proSellDate: String
    /**
     * 销售量
     */
    var proSold: Int
    /**
     * 销售金额
     */
    var proDfinalAmount: Double
    
    static func parse(_ data: JSONTYPE) -> THJGProjectSellDayDetailDayBean {
        return THJGProjectSellDayDetailDayBean(proSellDate: data["proSellDate"].string ?? "",
                                               proSold: data["proSold"].int ?? 0,
                                               proDfinalAmount: data["proDfinalAmount"].double ?? 0.0)
    }
    
}
