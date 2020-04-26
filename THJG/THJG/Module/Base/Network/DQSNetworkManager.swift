/**
 * 网络层封装
 * Alamofire 4.8.0
 * SwiftyJSON 4.2.0
 */

import UIKit
import AdSupport
import Alamofire
import SwiftyJSON

//blocks
typealias ReqSuccessBlock = (JSON) -> Void
typealias ReqFailureBlock = (Int, String) -> Void

class DQSNetworkManager: NSObject {

    //Singleton
    static let sharedInstance = DQSNetworkManager()
    
    private let dqsManager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = 15
        return SessionManager(configuration: configuration)
    }()
    
    //Common Param
    private var commonParam: Parameters = ["appVer": Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String,
                                           "osVer": UIDevice.current.systemVersion,
                                           "deviceName": UIDevice.current.name,
                                           "source": "20",
                                           "idfa": ASIdentifierManager.shared().advertisingIdentifier.uuidString,
                                           "channel" : "iOS",
                                           "bizCode": "",
                                           "userId": "",
                                           "userToken": ""]
    
    
}

//MARK: - METHODS
extension DQSNetworkManager {
    
    /**
     * 请求
     * @param methodName     方法名
     * @param bussinessParam 业务参数
     * @param success        成功回调
     * @param failure        失败回调
     */
     @discardableResult
     func requestForData(methodName: String,
                        bussinessParam: Parameters?,
                        success: @escaping ReqSuccessBlock,
                        failure: @escaping ReqFailureBlock) -> DataRequest? {
        //verify the paramers
        guard !methodName.isEmpty else {
            failure(10001, "请求方法名不能为空")
            return nil
        }
        
        //handle the paramers
        commonParam["bizCode"] = methodName
        
        DQSUtils.log("~~~requestMethod~~~: \(methodName)")
        
        //if logined, add the userId and the userToken to commonParam
        if DQSUtils.isLoginStatus().0 {
            let user = DQSUtils.isLoginStatus().1!
            commonParam["userId"] = user.userId
            commonParam["userToken"] = user.userToken
        }
        
        let finalParam: Parameters = ["header": commonParam,
                                      "body": bussinessParam ?? Parameters()]
        
        DQSUtils.log("finalParam:\(finalParam)")
        
        let jsonData = try! JSONSerialization.data(withJSONObject: finalParam, options: .prettyPrinted)
        
        /* Encrypt the data before sending requests */
        //1.Encrypt with rsa
        let enData = RSA.encryptData(jsonData, publicKey: RSA_PUBLICK_KEY)!
        //let enData = RSA.encryptData(jsonData, privateKey: RSA_PRIVATE_KEY)
        
        //2.Zip
        let zipData = DQSDataZipHelper.zipData(with: enData) as! Data
        
        //3.Base64 Encode
        let base64Str = GTMBase64.string(byEncoding: zipData)
        
        let enParam: Parameters = ["data": base64Str!]
        
        //Send the request
        let request = dqsManager.request(baseUrl, method: .post, parameters: enParam, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            DQSUtils.log("request_time:\(response.timeline)")
            switch response.result {
            case .success(let value): //success
                
                //Get the response value
                let json = JSON(value)
                DQSUtils.log(json)
                
                //1.Base64 Decode
                let base64Data = json["data"].stringValue.data(using: String.Encoding.utf8)
                let enData = GTMBase64.decode(base64Data!)!
                
                //Get the value of the key sign
                let signData = GTMBase64.decode(json["sign"].stringValue.data(using: String.Encoding.utf8))!
                
                //Verify the validity of response
                let res = DQSRSAHelper.rsaSHA256VerifyData(enData, withSignature: signData)
                guard res else {
                    failure(10002, "rsa验签失败")
                    return
                }
                
                //2.Unzip
                let unZipData = DQSDataZipHelper.unZipData(with: enData) as! Data
                
                //3.Decrypt the data
                //let str = RSA.decryptString(dataStr, publicKey: RSA_PUBLICK_KEY)!
                let deData = RSA.decryptData(unZipData, publicKey: RSA_PUBLICK_KEY)!
                
                //Verify the response
                guard let rp = try? JSON(data: deData) else {
                    failure(10003, "接口返回数据格式非JSON")
                    return
                }
                
                DQSUtils.log(rp)
                
                //Return the response
                let status = rp["success"].boolValue
                let errorCode = rp["errorCode"].intValue
                let msg = rp["msg"].string
                if status {
                    //response success
                    success(rp["data"])
                } else {
                    //response failure
                    failure(errorCode, msg ?? "")
                    
                    //special errorCode
                    switch errorCode {
                    case 100023: //登录超时，请重新登录
                        NotificationCenter.default.post(name: NSNotification.Name(NOTIFICATION_ACCOUNT_NEED_REFRESH), object: nil)
                    case 100025: //该账号已在其他设备上登录
                        NotificationCenter.default.post(name: NSNotification.Name(NOTIFICATION_ACCOUNT_NEED_REFRESH), object: nil)
                    default:
                        break
                    }
                }
                
            case .failure(let error): //failure
                failure(10004, "请求异常：\(error.localizedDescription)")
            }
        }
        return request
    }
}
