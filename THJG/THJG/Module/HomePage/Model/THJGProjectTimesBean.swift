/**
 * 重要时间节点实体
 */

struct THJGProjectTimesBean: THJGBaseBean {

    var proName: String
    var proTimes: [ProTimesBean]
    
    static func parse(_ data: JSONTYPE) -> THJGProjectTimesBean {
     
        var proTimes = [ProTimesBean]()
        if let timesArray = data["proTimes"].array {
            for time in timesArray {
                proTimes.append(ProTimesBean.parse(time))
            }
        }
        
        return THJGProjectTimesBean(proName: data["proName"].string ?? "",
                                    proTimes: proTimes)
        
    }
}

//MARK: - CELL实体
struct ProTimesBean: THJGBaseBean {
    
    var timeStatus: Int  //0.已完成 1.未完成
    var timeName: String
    var timeAppointDate: Int64
    var timeExpectDate: Int64
    var timeActualDate: Int64
    var timeDelay: Int
    var timeCurProgress: String
    var timeRemark: String
    var systemCurDate: Int64
    
    static func parse(_ data: JSONTYPE) -> ProTimesBean {
        return ProTimesBean(timeStatus: data["timeStatus"].int ?? 0,
                            timeName: data["timeName"].string ?? "",
                            timeAppointDate: data["timeAppointDate"].int64 ?? 0,
                            timeExpectDate: data["timeExpectDate"].int64 ?? 0,
                            timeActualDate: data["timeActualDate"].int64 ?? 0,
                            timeDelay: data["timeDelay"].int ?? 0,
                            timeCurProgress: data["timeCurProgress"].string ?? "",
                            timeRemark: data["timeRemark"].string ?? "",
                            systemCurDate: data["systemCurDate"].int64 ?? 0)
    }
    
}
