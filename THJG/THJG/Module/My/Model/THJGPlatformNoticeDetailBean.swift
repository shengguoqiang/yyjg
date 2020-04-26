/**
 * 平台公告详情实体
 */

struct THJGPlatformNoticeDetailBean: THJGBaseBean {

    var noticeTitle: String
    var noticeDate: Int64
    var noticeContent: String
    
    static func parse(_ data: JSONTYPE) -> THJGPlatformNoticeDetailBean {
        return THJGPlatformNoticeDetailBean(noticeTitle: data["noticeTitle"].string ?? "",
                                            noticeDate: data["noticeDate"].int64 ?? 0,
                                            noticeContent: data["noticeContent"].string ?? "")
    }
}
