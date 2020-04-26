/**
 * 站内信实体
 */

struct THJGInnerMsgBean: THJGBaseBean {

    var unRead: Int
    var msgs: [InnerMsgBean]
    
    static func parse(_ data: JSONTYPE) -> THJGInnerMsgBean {
        var msgs = [InnerMsgBean]()
        if let msgsArray = data["msgs"].array {
            for msg in msgsArray {
                msgs.append(InnerMsgBean.parse(msg))
            }
        }
        return THJGInnerMsgBean(unRead: data["unRead"].int ?? 0,
                                msgs: msgs)
    }
}

struct InnerMsgBean: THJGBaseBean {
    
    var msgId: String
    var msgIsRead: Int
    var msgTitle: String
    var msgContent: String
    var msgSendDate: Int64
    
    static func parse(_ data: JSONTYPE) -> InnerMsgBean {
        return InnerMsgBean(msgId: data["msgId"].string ?? "",
                            msgIsRead: data["msgIsRead"].int ?? 0,
                            msgTitle: data["msgTitle"].string ?? "",
                            msgContent: data["msgContent"].string ?? "",
                            msgSendDate: data["msgSendDate"].int64 ?? 0)
    }
}
