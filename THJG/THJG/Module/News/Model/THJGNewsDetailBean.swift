/**
 * 资讯详情实体
 */

struct THJGNewsDetailBean: THJGBaseBean {

    var newsTitle: String
    var newsDate: Int64
    var newsSource: String
    var newsType: Int // 10新闻资讯 20企业资讯 30行业动态 40政策动向
    var newsContent: String
    
    static func parse(_ data: JSONTYPE) -> THJGNewsDetailBean {
        return THJGNewsDetailBean(newsTitle: data["newsTitle"].string ?? "",
                                  newsDate: data["newsDate"].int64 ?? 0,
                                  newsSource: data["newsSource"].string ?? "",
                                  newsType: data["newsType"].int ?? 0,
                                  newsContent: data["newsContent"].string ?? "")
    }
}
