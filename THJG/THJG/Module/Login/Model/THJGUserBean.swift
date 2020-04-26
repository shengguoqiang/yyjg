/**
 * 用户实体
 */

struct THJGUserBean: THJGBaseBean {
    
    //properties
    var userId: String
    var userToken: String
    var userMobile: String
    var userName: String
    
    //parse method
    static func parse(_ data: JSONTYPE) -> THJGUserBean {
        return THJGUserBean(userId: data["userId"].string ?? "",
                            userToken: data["userToken"].string ?? "",
                            userMobile: data["userMobile"].string ?? "",
                            userName: data["userName"].string ?? "")
    }
}

//MARK: - DQSArchivable
extension THJGUserBean: DQSArchivable {
    //archive: transform the struct to the dic which conforms to NSCoding
    func archive() -> NSDictionary {
        return ["userId": userId,
                "userToken": userToken,
                "userMobile": userMobile,
                "userName": userName]
    }
    
    //unArchive: restore the struct from the dic
    init?(unarchive: NSDictionary?) {
        guard let dic = unarchive else {
            return nil
        }
        if let userId = dic["userId"] as? String,
            let userToken = dic["userToken"] as? String,
            let userMobile = dic["userMobile"] as? String,
            let userName = dic["userName"] as? String {
            self.userId = userId
            self.userToken = userToken
            self.userMobile = userMobile
            self.userName = userName
        } else {
            return nil
        }
    }
    
    
}
