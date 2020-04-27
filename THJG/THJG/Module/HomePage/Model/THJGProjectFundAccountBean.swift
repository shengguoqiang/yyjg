/**
 * 项目资金信息-账户信息实体
 */

struct THJGProjectFundAccountBean: THJGBaseBean {
    
    var projectName: String
    var accountSum: Double
    var accounts: [ProFundAccountBean]
    
    static func parse(_ data: JSONTYPE) -> THJGProjectFundAccountBean {
        var accountSum: Double = 0
        var accounts = [ProFundAccountBean]()
        if let accountsArray = data["accounts"].array {
            for account in accountsArray {
                let accountBean = ProFundAccountBean.parse(account)
                accountSum += accountBean.bankBalance
                accounts.append(accountBean)
            }
        }
        return THJGProjectFundAccountBean(projectName: data["projectName"].string ?? "",
                                          accountSum: accountSum,
                                          accounts: accounts)
    }
}

struct ProFundAccountBean: THJGBaseBean {
    
    var bankLogo: String
    var accountName: String
    var bankName: String
    //账户类型 10 基本户 20 销售监管户 30 一般户 40 一般户(按揭) 50 保证金账户
    var bankProperty: String
    var bankNo: String
    var bankBalance: Double
    var bankShieldName: String
    var bankShieldCode: String
    /**
     * 更新时间
     */
    var dataUptTime: String
    
    static func parse(_ data: JSONTYPE) -> ProFundAccountBean {
        return ProFundAccountBean(bankLogo: data["bankLogo"].string ?? "",
                                  accountName: data["accountName"].string ?? "",
                                  bankName: data["bankName"].string ?? "",
                                  bankProperty: data["bankProperty"].string ?? "",
                                  bankNo: data["bankNo"].string ?? "",
                                  bankBalance: data["bankBalance"].double ?? 0,
                                  bankShieldName: data["bankShieldName"].string ?? "",
                                  bankShieldCode: data["bankShieldCode"].string ?? "",
                                  dataUptTime: data["dataUptTime"].string ?? "")
    }
}
