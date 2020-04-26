/**
 * 监控实体
 */

struct THJGMonitorBean: THJGBaseBean {

    var videosTotal: Int
    var videos: [MonitorBean]
    
    static func parse(_ data: JSONTYPE) -> THJGMonitorBean {
        var videos = [MonitorBean]()
        if let videosArray = data["videos"].array {
            for video in videosArray {
                videos.append(MonitorBean.parse(video))
            }
        }
        return THJGMonitorBean(videosTotal: data["videosTotal"].int ?? 0,
                               videos: videos)
    }
}

struct MonitorBean: THJGBaseBean {
    
    var videoDate: String
    var videoDetails: [MonitorDetailBean]
    
    static func parse(_ data: JSONTYPE) -> MonitorBean {
        var videoDetails = [MonitorDetailBean]()
        if let videoDetailsArray = data["videoDetails"].array {
            for detail in videoDetailsArray {
                videoDetails.append(MonitorDetailBean.parse(detail))
            }
        }
        return MonitorBean(videoDate: data["videoDate"].string ?? "",
                           videoDetails: videoDetails)
    }
}

struct MonitorDetailBean: THJGBaseBean {
    
    var alarmVideoUrl: String
    var alarmIsChecked: Int
    var alarmPicUrl: String
    var alarmTime: Int64
    
    static func parse(_ data: JSONTYPE) -> MonitorDetailBean {
        return MonitorDetailBean(alarmVideoUrl: data["alarmVideoUrl"].string ?? "",
                                 alarmIsChecked: data["alarmIsChecked"].int ?? 0,
                                 alarmPicUrl: data["alarmPicUrl"].string ?? "",
                                 alarmTime: data["alarmTime"].int64 ?? 0)
    }
}
