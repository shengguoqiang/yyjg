/**
 * 地图大头针
 */

import UIKit

//大头针类型
enum THJGPointType {
    case ownProject   //当前楼盘
    case compeProject //竞品楼盘
}

class THJGPointAnnotation: BMKPointAnnotation {

    var type: THJGPointType!
}
