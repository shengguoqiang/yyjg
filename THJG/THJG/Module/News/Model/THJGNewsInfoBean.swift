/**
 * 资讯列表实体
 */

struct THJGNewsInfoBean: THJGBaseBean {

    var newsInfos: [THJGNewsBean]
    
    static func parse(_ data: JSONTYPE) -> THJGNewsInfoBean {
        var newsInfos = [THJGNewsBean]()
        if let newInfoArray = data["newsInfos"].array {
            for news in newInfoArray {
                newsInfos.append(THJGNewsBean.parse(news))
            }
        }
        
        return THJGNewsInfoBean(newsInfos: newsInfos)
    }
}
