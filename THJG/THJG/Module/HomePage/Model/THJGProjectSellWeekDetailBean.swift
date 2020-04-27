/**
 * 销售明细-七日销售折线实体
 */

struct THJGProjectSellWeekDetailsBean: THJGBaseBean {

    /**
     * 七日总销售金额
     */
    var projectDfinalAmount: Double
    /**
     * 七日总销售套数
     */
    var projectIsold: Int
    /**
     * 七日销售明细
     */
    var projectSellWeekDetails: [THJGProjectSellWeekDetailBean]
    
    static func parse(_ data: JSONTYPE) -> THJGProjectSellWeekDetailsBean {
        var weekList = [THJGProjectSellWeekDetailBean]()
        if let weekArr = data["projectSellWeekDetails"].array {
            for week in weekArr {
                weekList.append(THJGProjectSellWeekDetailBean.parse(week))
            }
        }
        return THJGProjectSellWeekDetailsBean(projectDfinalAmount: data["projectDfinalAmount"].double ?? 0,
                                              projectIsold: data["projectIsold"].int ?? 0,
                                              projectSellWeekDetails: weekList)
    }
    
}

struct THJGProjectSellWeekDetailBean: THJGBaseBean {
    
    /**
     * 销售日期
     */
    var proSellDate: String
    /**
     * 销售套数
     */
    var proSold: Int
    
    static func parse(_ data: JSONTYPE) -> THJGProjectSellWeekDetailBean {
        return THJGProjectSellWeekDetailBean(proSellDate: data["proSellDate"].string ?? "",
                                             proSold: data["proSold"].int ?? 0)
    }
    
}
