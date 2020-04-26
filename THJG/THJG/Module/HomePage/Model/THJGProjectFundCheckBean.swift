/**
 * 用款登记实体
 */

struct THJGProjectFundCheckBean: THJGBaseBean {

    var smallTypes: [SmallTypeBean]
    var pays: [FundCheckBean]
    var paysTotal: Int
    
    static func parse(_ data: JSONTYPE) -> THJGProjectFundCheckBean {
        var smallTypes = [SmallTypeBean]()
        if let smallTypeArray = data["smallTypes"].array {
            for type in smallTypeArray {
                smallTypes.append(SmallTypeBean.parse(type))
            }
        }
        var pays = [FundCheckBean]()
        if let paysArray = data["pays"].array {
            for pay in paysArray {
                pays.append(FundCheckBean.parse(pay))
            }
        }
        return THJGProjectFundCheckBean(smallTypes: smallTypes,
                                        pays: pays,
                                        paysTotal: data["paysTotal"].int ?? 0)
    }
}

//MARK: - 费用小类
struct SmallTypeBean: THJGBaseBean {
    var smallTypeId: String
    var smallTypeName: String
    static func parse(_ data: JSONTYPE) -> SmallTypeBean {
        return SmallTypeBean(smallTypeId: data["smallTypeId"].string ?? "",
                             smallTypeName: data["smallTypeName"].string ?? "")
    }
}

//MARK: - 用款登记实体
struct FundCheckBean: THJGBaseBean {
    
    var payTime: Int64
    var payDetails: [FundCheckDetailBean]
    
    static func parse(_ data: JSONTYPE) -> FundCheckBean {
        var payDetails = [FundCheckDetailBean]()
        if let payDetailsArray = data["payDetails"].array {
            for payDetail in payDetailsArray {
                payDetails.append(FundCheckDetailBean.parse(payDetail))
            }
        }
        return FundCheckBean(payTime: data["payTime"].int64 ?? 0,
                             payDetails: payDetails)
    }
}

//MARK: - 用款登记详情实体
struct FundCheckDetailBean: THJGBaseBean {
    
    var paySmallTypeName: String
    var payActualPay: Double
    var payOperator: String
    var payWay: String
    var payReason: String
    var payPayAccount: String
    var payRecAccount: String
    var payRemark: String
    var payResources: [FundCheckDetailResourceBean]
    
    static func parse(_ data: JSONTYPE) -> FundCheckDetailBean {
        var payResources = [FundCheckDetailResourceBean]()
        if let payResourcesArray = data["payResources"].array {
            for payRes in payResourcesArray {
                payResources.append(FundCheckDetailResourceBean.parse(payRes))
            }
        }
        return FundCheckDetailBean(paySmallTypeName: data["paySmallTypeName"].string ?? "",
                                   payActualPay: data["payActualPay"].double ?? 0,
                                   payOperator: data["payOperator"].string ?? "",
                                   payWay: data["payWay"].string ?? "",
                                   payReason: data["payReason"].string ?? "",
                                   payPayAccount: data["payPayAccount"].string ?? "",
                                   payRecAccount: data["payRecAccount"].string ?? "",
                                   payRemark: data["payRemark"].string ?? "",
                                   payResources: payResources)
    }
}

//MARK: - 用款登记资源实体
struct FundCheckDetailResourceBean: THJGBaseBean {
    
    var fundCheckResName: String
    var fundCheckResUrl: String
    
    static func parse(_ data: JSONTYPE) -> FundCheckDetailResourceBean {
        return FundCheckDetailResourceBean(fundCheckResName: data["fundCheckResName"].string ?? "",
                                           fundCheckResUrl: data["fundCheckResUrl"].string ?? "")
    }
}
