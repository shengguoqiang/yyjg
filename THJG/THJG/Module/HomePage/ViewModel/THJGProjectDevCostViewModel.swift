/**
 * 项目开发成本及费用VM
 */

/* 成功通知 */
let THJG_NOTIFICATION_DEVCOST_SUCCESS = "THJG_NOTIFICATION_DEVCOST_SUCCESS"
let THJG_NOTIFICATION_DEVCOST_DETAIL_SUCCESS = "THJG_NOTIFICATION_DEVCOST_DETAIL_SUCCESS"

//处理过的数据，主要为了标明状态以及增加详情列表
struct ProDevCostHandledBean {
    var isHeader: (Bool, String?, Double?, Double?)
    var smallBean: ProDevCostSmallTypeBean
    var isSelected: (Bool, [ProDevCostDetailBean]?)
}

class THJGProjectDevCostViewModel: THJGBaseViewModel {

    /**
     * 获取项目开发成本及费用数据
     * @param param   业务参数
     */
    func requestForProDevCostData(param: PARAMETERTYPE?) {
       let request = DQSNetworkManager.sharedInstance.requestForData(methodName: "projectDevCost", bussinessParam: param, success: {(response) in
           let proDevCostBean = THJGProjectDevCostBean.parse(response)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: THJG_NOTIFICATION_DEVCOST_SUCCESS), object: THJGSuccessBean(bean: proDevCostBean, msg: nil))
        }) { (code, message) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: THJG_NOTIFICATION_NETWORK_FAILURE), object: THJGFailureBean(errorCode: code, msg: message))
        }
        requestQueue.append(request)
    }
    
    /**
     * 获取项目开发成本及费用明细数据
     * @param param   业务参数
     */
    func requestForProDevCostDetailData(param: PARAMETERTYPE?) {
        let request = DQSNetworkManager.sharedInstance.requestForData(methodName: "projectDevCostDetail", bussinessParam: param, success: {(response) in
            let details = ProDevCostDetailBean.parseDevCostDetail(response)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: THJG_NOTIFICATION_DEVCOST_DETAIL_SUCCESS), object: details)
        }) { (code, message) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: THJG_NOTIFICATION_NETWORK_FAILURE), object: THJGFailureBean(errorCode: code, msg: message))
        }
        requestQueue.append(request)
    }
}

extension THJGProjectDevCostViewModel {
    //处理数据，主要为了标明状态以及增加详情列表
    func handleDevCostData(_ bean: THJGProjectDevCostBean) -> [ProDevCostHandledBean] {
        var handles = [ProDevCostHandledBean]()
        for bigType in bean.bigTypes {
            for (index, smallType) in bigType.smallTypes.enumerated() {
                var header: (Bool, String?, Double?, Double?)!
                if index == 0 {//header
                    header = (true, bigType.bigTypeName, bigType.bigTypePlanSum, bigType.bigTypeAcutalSum)
                } else {
                    header = (false, nil, nil, nil)
                }
                let handle = ProDevCostHandledBean(isHeader: header, smallBean: smallType, isSelected: (false, nil))
                handles.append(handle)
            }
        }
        return handles
    }
}
