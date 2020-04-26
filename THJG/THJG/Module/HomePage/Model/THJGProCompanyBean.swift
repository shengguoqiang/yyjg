/**
 * 企业实体
 */

struct THJGProCompanyBean: THJGBaseBean {

    var baseInfo: ProCompanyBaseInfoBean
    var financeInfo: [ProCompanyPdfBean]
    var riskInfo: [ProCompanyPdfBean]
    
    static func parse(_ data: JSONTYPE) -> THJGProCompanyBean {
        
        var financeInfo = [ProCompanyPdfBean]()
        if let financeArray = data["financeInfo"].array {
            for fund in financeArray {
                financeInfo.append(ProCompanyPdfBean.parse(fund))
            }
        }
        
        var riskInfo = [ProCompanyPdfBean]()
        if let riskArray = data["riskInfo"].array {
            for risk in riskArray {
                riskInfo.append(ProCompanyPdfBean.parse(risk))
            }
        }
        
        return THJGProCompanyBean(baseInfo: ProCompanyBaseInfoBean.parse(data["baseInfo"]),
                                  financeInfo: financeInfo,
                                  riskInfo: riskInfo)
    }
}

//公司信息
struct ProCompanyBaseInfoBean: THJGBaseBean {
    
    var companyName: String
    var legalName: String
    var registerAmount: String
    var actualAmount: String
    var authCode: String
    var companyDes: String
    var leaderInfo: [ProCompanyPdfBean]
    
    static func parse(_ data: JSONTYPE) -> ProCompanyBaseInfoBean {
        
        var leaderInfo = [ProCompanyPdfBean]()
        if let leaderArray = data["leaderInfo"].array {
            for leader in leaderArray {
                leaderInfo.append(ProCompanyPdfBean.parse(leader))
            }
        }
        
        return ProCompanyBaseInfoBean(companyName: data["companyName"].string ?? "",
                                      legalName: data["legalName"].string ?? "",
                                      registerAmount: data["registerAmount"].string ?? "",
                                      actualAmount: data["actualAmount"].string ?? "",
                                      authCode: data["authCode"].string ?? "",
                                      companyDes: data["companyDes"].string ?? "",
                                      leaderInfo: leaderInfo)
    }
}

//pdf
struct ProCompanyPdfBean: THJGBaseBean {
    
    var resourceUrl: String
    var resourceName: String
    
    static func parse(_ data: JSONTYPE) -> ProCompanyPdfBean {
        return ProCompanyPdfBean(resourceUrl: data["resourceUrl"].string ?? "",
                                     resourceName: data["resourceName"].string ?? "")
    }
}
