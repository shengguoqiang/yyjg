/**
 * 萤石视频
 */

class THJGEZOPENManager {

    //singleton
   static let sharedInstance = THJGEZOPENManager()
    
    lazy var tokenVM = THJGEZOpenViewModel()
    
}

//MARK: - METHODS
extension THJGEZOPENManager {
    
    //setup
    func setup() {
        //取消debug模式
        EZUIKit.setDebug(false)
        
        //appKey
        EZUIKit.initWithAppKey("44e0478cb3d0413ab363bf604df8ade2")
        
        //token
        tokenVM.requestForEZOpenAccessToken(param: nil, success: { (token) in
            EZUIKit.setAccessToken(token)
        }) { (code, msg) in
            DQSUtils.log("萤石视频token获取失败")
        }
    }
}
