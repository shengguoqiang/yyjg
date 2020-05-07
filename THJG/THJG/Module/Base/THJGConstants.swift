/**
 * 系统常量
 */

import SwiftyJSON

//JSON类型
typealias JSONTYPE = JSON

//参数类型
typealias PARAMETERTYPE = [String: Any]

//成功失败回调
typealias SuccessBlock = (THJGBaseBean?, String?) -> Void
typealias FailureBlock = (Int, String) -> Void

/* 请求成功 */
//成功实体
struct THJGSuccessBean {
    var bean: THJGBaseBean?
    var msg: String?
}

//失败实体
struct THJGFailureBean {
    var errorCode: Int
    var msg: String
}

//RSA公钥
let RSA_PUBLICK_KEY = "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDYldTRQgmZP/Bcj+qn0MJZt32/BFLCxi7W9jG+camax1JYMCZT7OI7+Mt/jBWRZTuGCL+DGM48gpSFsIKHB4YU6hdCV+ncyLmqYdnAAg8bOtxNc9V++j/1YuMoPLAvEdiELbW+PxU/cOsorzJQTzYCtrEwCL4KEzF6cywDHg0Y+QIDAQAB"

/* 网络请求URL */
//本地
//let baseUrl = "http://192.168.101.15:8088/info-app-thjg/core"
//130测试
//let baseUrl = "http://192.168.0.130:8099/info-app-thjg/core"
//15测试
//let baseUrl = "http://192.168.0.15:7112/core"
//新测试-打包
//let baseUrl = "http://192.168.0.15:7112/core"
//新测试-开发
//let baseUrl = "http://58.213.46.226:9090/core"
//正式环境
let baseUrl = "https://yyapp.yunshows.com/core"

/* 环境 */
//let ENVIRONMENT = "dev"
let ENVIRONMENT = "prd"

/* 各种机型 */
//屏幕宽度
let SCREEN_WIDTH = UIScreen.main.bounds.width
let SCREEN_HEIGHT = UIScreen.main.bounds.height

/*
 尺寸         分辨率          scale     型号         对应机型
 3.5         640x960        @2x       2x           iPhone4及其以下
 4.0         640×1136       @2x       Retina 4     iPhone5/5s/SE
 4.7         750×1334       @2x       Retina4.7    iPhone6/6s/7/7s/8/8s
 5.5         1242×2208      @3x       Retina 5.5   iPhone6P/iPhone7P/iPhone8P
 5.8         1125×2436      @3x       iPhone X/XS  iPhoneX/iPhoneXS
 6.1         828x1792       @2x       iPhoneXR     iPhoneXR
 6.5         1242x2688      @3x       iPhoneXMax   iPhoneX Max
 */


/* 机型适配 */
// 5S
let DEVICE_5S = UIScreen.main.bounds.width < 375

/* 全局通知 */
//登录超时或账号在其他设备登录
let NOTIFICATION_ACCOUNT_NEED_REFRESH = "NOTIFICATION_ACCOUNT_NEED_REFRESH"

//资金信息-合同台账-查看合同
let NOTIFICATION_PROJECT_CHECK_CONTRACT = "NOTIFICATION_PROJECT_CHECK_CONTRACT"
//资金信息-合同台账-查看合同付款详情
let NOTIFICATION_PROJECT_CHECK_CONTRACT_PAYDETAIL = "NOTIFICATION_PROJECT_CHECK_CONTRACT_PAYDETAIL"

//全屏查看录像
let NOTIFICATION_VIDEO_REC_FULLSCREEN = "NOTIFICATION_VIDEO_REC_FULLSCREEN"
//取消全屏
let NOTIFICATION_VIDEO_REC_SMALLSCREEN = "NOTIFICATION_VIDEO_REC_SMALLSCREEN"
