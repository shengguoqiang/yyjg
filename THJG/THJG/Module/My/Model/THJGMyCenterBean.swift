/**
 * 个人中心实体
 */

struct THJGMyCenterBean: THJGBaseBean {

    var msgUnRead: Int
    var upgrades: [AppUpgradeBean]
    
    static func parse(_ data: JSONTYPE) -> THJGMyCenterBean {
        var upgrades = [AppUpgradeBean]()
        if let upgradesArray = data["upgrades"].array {
            for up in upgradesArray {
                upgrades.append(AppUpgradeBean.parse(up))
            }
        }
        return THJGMyCenterBean(msgUnRead: data["msgUnRead"].int ?? 0,
                                upgrades: upgrades)
    }
}
