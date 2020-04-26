/**
 * 平台公告实体
 */

struct THJGPlatformNoticeBean: THJGBaseBean {

    var notices: [PlatformNoticeBean]
    
    static func parse(_ data: JSONTYPE) -> THJGPlatformNoticeBean {
        var notices = [PlatformNoticeBean]()
        if let noticesArray = data["notices"].array {
            for notice in noticesArray {
                notices.append(PlatformNoticeBean.parse(notice))
            }
        }
        return THJGPlatformNoticeBean(notices: notices)
    }
}

struct PlatformNoticeBean: THJGBaseBean {
    
    var noticeId: String
    var noticeTitle: String
    var noticeAbstract: String
    var noticeDate: Int64
    
    static func parse(_ data: JSONTYPE) -> PlatformNoticeBean {
        return PlatformNoticeBean(noticeId: data["noticeId"].string ?? "",
                                  noticeTitle: data["noticeTitle"].string ?? "",
                                  noticeAbstract: data["noticeAbstract"].string ?? "",
                                  noticeDate: data["noticeDate"].int64 ?? 0)
    }
}
