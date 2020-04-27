/**
 * 项目资金信息VM
 */

/* 成功通知 */
//账户信息
let THJG_NOTIFICATION_FUND_ACCOUNT_SUCCESS = "THJG_NOTIFICATION_FUND_ACCOUNT_SUCCESS"

//用款登记
let THJG_NOTIFICATION_FUND_CHECK_NEWDATA_SUCCESS = "THJG_NOTIFICATION_FUND_CHECK_NEWDATA_SUCCESS"
let THJG_NOTIFICATION_FUND_CHECK_NEWDATA_FAILURE = "THJG_NOTIFICATION_FUND_CHECK_NEWDATA_FAILURE"
let THJG_NOTIFICATION_FUND_CHECK_MOREDATA_SUCCESS = "THJG_NOTIFICATION_FUND_CHECK_MOREDATA_SUCCESS"
let THJG_NOTIFICATION_FUND_CHECK_MOREDATA_FAILURE = "THJG_NOTIFICATION_FUND_CHECK_MOREDATA_FAILURE"

//合同台账
let THJG_NOTIFICATION_FUND_CONTRACT_NEWDATA_SUCCESS = "THJG_NOTIFICATION_FUND_CONTRACT_NEWDATA_SUCCESS"
let THJG_NOTIFICATION_FUND_CONTRACT_NEWDATA_FAILURE = "THJG_NOTIFICATION_FUND_CONTRACT_NEWDATA_FAILURE"
let THJG_NOTIFICATION_FUND_CONTRACT_MOREDATA_SUCCESS = "THJG_NOTIFICATION_FUND_CONTRACT_MOREDATA_SUCCESS"
let THJG_NOTIFICATION_FUND_CONTRACT_MOREDATA_FAILURE = "THJG_NOTIFICATION_FUND_CONTRACT_MOREDATA_FAILURE"


//账户信息处理过的实体
struct ProFundInfoAccountHandledBean {
    var cellBean: ProFundAccountBean
    var cellHeight: CGFloat
}

//用款登记处理过的实体
struct ProFundInfoCheckHandledBean {
    var payTime: Int64
    var payDetails: [ProFundInfoCheckDetailHandledBean]
}
struct ProFundInfoCheckDetailHandledBean {
    var cellBean: FundCheckDetailBean
    var cellHeight: CGFloat
    var isSelected: Bool
}

//合同台账处理过的实体
struct ProContractHandledBean {
    var headerBean: ProjectContractBean
    var isSelected: (Bool, [THJGBaseBean]?)
}

/* 成功回调 */
//合同台账
typealias ContractSuccessBlock = ([ProContractHandledBean]) -> Void

class THJGProjectFundInfoViewModel: THJGBaseViewModel {

    /**
     * 获取账户信息数据
     * @param param   业务参数
     */
    func requestForAccountData(param: PARAMETERTYPE?) {
       let request = DQSNetworkManager.sharedInstance.requestForData(methodName: "projectAccount", bussinessParam: param, success: {(response) in
            let bean = THJGProjectFundAccountBean.parse(response)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: THJG_NOTIFICATION_FUND_ACCOUNT_SUCCESS), object: THJGSuccessBean(bean: bean, msg: nil))
        }) { (code, message) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: THJG_NOTIFICATION_NETWORK_FAILURE), object: THJGFailureBean(errorCode: code, msg: message))
        }
        requestQueue.append(request)
    }
    
    /**
     * 获取用款登记数据(第一页)
     * @param param   业务参数
     */
    func requestForFundCheckNewData(param: PARAMETERTYPE?) {
        let request = DQSNetworkManager.sharedInstance.requestForData(methodName: "projectFundCheck", bussinessParam: param, success: { (response) in
            let fundCheckBean = THJGProjectFundCheckBean.parse(response)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: THJG_NOTIFICATION_FUND_CHECK_NEWDATA_SUCCESS), object: THJGSuccessBean(bean: fundCheckBean, msg: nil))
        }) { (code, message) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: THJG_NOTIFICATION_FUND_CHECK_NEWDATA_FAILURE), object: THJGFailureBean(errorCode: code, msg: message))
        }
        requestQueue.append(request)
    }
    
    /**
     * 获取用款登记数据(更多)
     * @param param   业务参数
     */
    func requestForFundCheckMoreData(param: PARAMETERTYPE?) {
        let request = DQSNetworkManager.sharedInstance.requestForData(methodName: "projectFundCheck", bussinessParam: param, success: { (response) in
            let fundCheckBean = THJGProjectFundCheckBean.parse(response)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: THJG_NOTIFICATION_FUND_CHECK_MOREDATA_SUCCESS), object: THJGSuccessBean(bean: fundCheckBean, msg: nil))
        }) { (code, message) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: THJG_NOTIFICATION_FUND_CHECK_MOREDATA_FAILURE), object: THJGFailureBean(errorCode: code, msg: message))
        }
        requestQueue.append(request)
    }
    
    /**
     * 获取合同台账数据(第一页)
     * @param param   业务参数
     */
    func requestForContractNewData(param: PARAMETERTYPE?) {
        let request = DQSNetworkManager.sharedInstance.requestForData(methodName: "projectContract", bussinessParam: param, success: {(response) in
         let contractBean = THJGProjectContractBean.parse(response)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: THJG_NOTIFICATION_FUND_CONTRACT_NEWDATA_SUCCESS), object: THJGSuccessBean(bean: contractBean, msg: nil))
        }) { (code, message) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: THJG_NOTIFICATION_FUND_CONTRACT_NEWDATA_FAILURE), object: THJGFailureBean(errorCode: code, msg: message))
        }
        requestQueue.append(request)
    }
    
    /**
     * 获取合同台账数据(更多)
     * @param param   业务参数
     */
    func requestForContractMoreData(param: PARAMETERTYPE?) {
        let request = DQSNetworkManager.sharedInstance.requestForData(methodName: "projectContract", bussinessParam: param, success: {(response) in
            let contractBean = THJGProjectContractBean.parse(response)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: THJG_NOTIFICATION_FUND_CONTRACT_MOREDATA_SUCCESS), object: THJGSuccessBean(bean: contractBean, msg: nil))
        }) { (code, message) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: THJG_NOTIFICATION_FUND_CONTRACT_MOREDATA_FAILURE), object: THJGFailureBean(errorCode: code, msg: message))
        }
        requestQueue.append(request)
    }
    
}

//MARK: - METHODS
extension THJGProjectFundInfoViewModel {
    
    //处理账户信息实体
     func handleAccountBeans(_ bean: THJGProjectFundAccountBean) -> [ProFundInfoAccountHandledBean] {
        var handledBeans = [ProFundInfoAccountHandledBean]()
        let accountBeans = bean.accounts
        for account in accountBeans {
            handledBeans.append(ProFundInfoAccountHandledBean(cellBean: account, cellHeight: 255))
        }
        return handledBeans
    }
    
    //处理用款登记实体
     func handleFundCheckBeans(_ bean: THJGProjectFundCheckBean) -> [ProFundInfoCheckHandledBean] {
        var handledBeans = [ProFundInfoCheckHandledBean]()
        let fundCheckBeans = bean.pays
        for fundCheckBean in fundCheckBeans {
            var handledDetailBeans = [ProFundInfoCheckDetailHandledBean]()
            for detailBean in fundCheckBean.payDetails {
                //计算cell高度
                var cellHeight: CGFloat = 200
                if DQSUtils.isNotBlank(detailBean.payPayAccount) {
                    cellHeight += 40
                }
                if DQSUtils.isNotBlank(detailBean.payRecAccount) {
                    cellHeight += 40
                }
                if DQSUtils.isNotBlank(detailBean.payRemark) {
                   let textHeight = DQSUtils.heightForText(text: detailBean.payRemark, fixedWidth: SCREEN_WIDTH - 76, fixedFont: UIFont.systemFont(ofSize: 14)) + 30
                    cellHeight += max(textHeight, 40)
                }
                if !detailBean.payResources.isEmpty {
                    cellHeight += 130
                }
                handledDetailBeans.append(ProFundInfoCheckDetailHandledBean(cellBean: detailBean, cellHeight: cellHeight, isSelected: false))
            }
            handledBeans.append(ProFundInfoCheckHandledBean(payTime: fundCheckBean.payTime, payDetails: handledDetailBeans))
        }
        return handledBeans
    }
    
    //处理合同台账
     func handleContractData(_ bean: THJGProjectContractBean) -> [ProContractHandledBean] {
        var handledBeans  = [ProContractHandledBean]()
        let contracts = bean.contracts
        for contract in contracts {
            handledBeans.append(ProContractHandledBean(headerBean: contract, isSelected: (false, nil)))
        }
        return handledBeans
    }
    
}
