/**
 * 企业VM
 */

/* 成功通知 */
let THJG_NOTIFICATION_PROCOMPANY_SUCCESS = "THJG_NOTIFICATION_PROCOMPANY_SUCCESS"

class THJGProCompanyViewModel: THJGBaseViewModel {

    /**
     * 获取企业数据
     * @param param   业务参数
     */
    func requestForProCompanyData(param: PARAMETERTYPE?) {
        let request = DQSNetworkManager.sharedInstance.requestForData(methodName: "companyInfo", bussinessParam: param, success: { (response) in
            let companyBean = THJGProCompanyBean.parse(response)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: THJG_NOTIFICATION_PROCOMPANY_SUCCESS), object: THJGSuccessBean(bean: companyBean, msg: nil))
        }) { (code, message) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: THJG_NOTIFICATION_NETWORK_FAILURE), object: THJGFailureBean(errorCode: code, msg: message))
        }
        requestQueue.append(request)
    }
    
}
