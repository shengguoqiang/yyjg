/**
 * Baidu地图
 */

class THJGBaiduMapManager {

    static let sharedInstance = THJGBaiduMapManager()
}

//MARK: - METHODS
extension THJGBaiduMapManager {
    
    //setup
    func setup() {
        let mapManager = BMKMapManager()
        mapManager.start("t2wWKxwoxyaCCG1NeAyGUKsoIy294FQN", generalDelegate: nil)
    }
}
