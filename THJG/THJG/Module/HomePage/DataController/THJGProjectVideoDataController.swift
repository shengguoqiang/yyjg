//
//  THJGProjectVideoDataController.swift
//  THJG
//
//  Created by 大强神 on 2020/7/16.
//  Copyright © 2020 中南金融. All rights reserved.
//  乐橙视频DataController

import UIKit

class THJGProjectVideoDataController {

    var token: String!
    
}

extension THJGProjectVideoDataController {
    
    /**
     * 获取乐橙视频token
     * @param param   业务参数
     */
    func requestForLeChengTokenData(_ param: PARAMETERTYPE?,
                                                     _ successBlock: @escaping SuccessBlock,
                                                     _ failureBlock: FailureBlock?) {
        _ = DQSNetworkManager.sharedInstance.requestForData(methodName: "lcAppMonitorToken", bussinessParam: param, success: { [weak self] (response) in
            let resultBean = THJGLeChengResultBean.parse(response)
            self?.token = resultBean.accessToken
            successBlock(resultBean, nil)
        }) { (code, message) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: THJG_NOTIFICATION_NETWORK_FAILURE), object: THJGFailureBean(errorCode: code, msg: message))
        }
    }
    
}

struct THJGLeChengResultBean: THJGBaseBean {
    
    var accessToken: String
    
    static func parse(_ data: JSONTYPE) -> THJGLeChengResultBean {
        return THJGLeChengResultBean(accessToken: data["accessToken"].string ?? "")
    }
    
}
