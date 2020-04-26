/**
 * 合同台账明细VM
 */

/* 成功通知 */
let THJG_NOTIFICATION_CONTRACT_DETAIL_SUCCESS = "THJG_NOTIFICATION_CONTRACT_DETAIL_SUCCESS"

//合同台账付款明细处理过的实体
struct ProjectContractDetailHandledBean {
    var detailName: String
    var details: [THJGBaseBean]
}

class THJGProjectContractDetailViewModel: THJGBaseViewModel {

    /**
     * 获取合同台账明细数据
     * @param param   业务参数
     */
    func requestForContractDetailData(param: PARAMETERTYPE?) {
        let request = DQSNetworkManager.sharedInstance.requestForData(methodName: "projectContractDetail", bussinessParam: param, success: { (response) in
            let contractDetailBean = THJGProjectContractDetailBean.parse(response)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: THJG_NOTIFICATION_CONTRACT_DETAIL_SUCCESS), object: THJGSuccessBean(bean: contractDetailBean, msg: nil))
        }) { (code, message) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: THJG_NOTIFICATION_NETWORK_FAILURE), object: THJGFailureBean(errorCode: code, msg: message))
        }
        requestQueue.append(request)
    }
}

extension THJGProjectContractDetailViewModel {
    //处理合同台账明细
     func handleContractDetailData(detailBean
        :THJGProjectContractDetailBean) -> [ProjectContractDetailHandledBean] {
        var handledBeans = [ProjectContractDetailHandledBean]()
        //处理约定付款信息
        if !detailBean.appointDetails.isEmpty {
            var tempBeans = detailBean.appointDetails
            tempBeans.insert(ProjectContractAppointDetailBean(conAppointNode: "", cellHeight: 45), at: 0)
            handledBeans.append(ProjectContractDetailHandledBean(detailName: "约定付款信息", details: tempBeans))
        }
        
        //处理实际付款信息
        if !detailBean.actualDetails.isEmpty {
            var tempBeans = detailBean.actualDetails
            tempBeans.insert(ProjectContractActualDetailBean(conActualTime: 0, conActualAmount: 0), at: 0)
            tempBeans.append(ProjectContractActualDetailBean(conActualTime: 0, conActualAmount: detailBean.actualSum))
            handledBeans.append(ProjectContractDetailHandledBean(detailName: "实际付款信息", details: tempBeans))
        }
        return handledBeans
    }
}
