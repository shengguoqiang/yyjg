/**
 * 市场情况实体
 */

struct THJGProMarketInfoBean: THJGBaseBean {

    var projectName: String
    var marketInfos: [MarketInfoBean]
    
    static func parse(_ data: JSONTYPE) -> THJGProMarketInfoBean {
        
        var marketInfos = [MarketInfoBean]()
        if let marketArray = data["marketInfos"].array {
            for market in marketArray {
                marketInfos.append(MarketInfoBean.parse(market))
            }
        }
        
        return THJGProMarketInfoBean(projectName: data["projectName"].string ?? "",
                                     marketInfos: marketInfos)
    }
}

struct MarketInfoBean: THJGBaseBean {
    
    var marketTitle: String
    var marketContent: String
    
    static func parse(_ data: JSONTYPE) -> MarketInfoBean {
        return MarketInfoBean(marketTitle: data["marketTitle"].string ?? "",
                              marketContent: data["marketContent"].string ?? "")
    }
}
