/**
 * 项目用章登记信息VM
 */

/* 成功通知 */
let THJG_NOTIFICATION_CACHET_NEWDATA_SUCCESS = "THJG_NOTIFICATION_CACHET_NEWDATA_SUCCESS"
let THJG_NOTIFICATION_CACHET_NEWDATA_FAILURE = "THJG_NOTIFICATION_CACHET_NEWDATA_FAILURE"

let THJG_NOTIFICATION_CACHET_MOREDATA_SUCCESS = "THJG_NOTIFICATION_CACHET_MOREDATA_SUCCESS"
let THJG_NOTIFICATION_CACHET_MOREDATA_FAILURE = "THJG_NOTIFICATION_CACHET_MOREDATA_FAILURE"

//处理数据
struct ProjectCachetSectionHandledBean {
    var useDate: Int64
    var useDetails: [ProjectCachetCellHandledBean]
}

struct ProjectCachetCellHandledBean {
    var cellBean: ProjectCachetCellBean
    var cellHeight: CGFloat
}

class THJGProjectCachetViewModel: THJGBaseViewModel {

    /**
     * 获取用章登记数据(第一页)
     * @param param   业务参数
     */
    func requestForProjectCachetNewData(param: PARAMETERTYPE?) {
        let request = DQSNetworkManager.sharedInstance.requestForData(methodName: "projectCachet", bussinessParam: param, success: { (response) in
            let cachetBean = THJGProjectCachetBean.parse(response)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: THJG_NOTIFICATION_CACHET_NEWDATA_SUCCESS), object: THJGSuccessBean(bean: cachetBean, msg: nil))
        }) { (code, message) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: THJG_NOTIFICATION_CACHET_NEWDATA_FAILURE), object: THJGFailureBean(errorCode: code, msg: message))
        }
        requestQueue.append(request)
    }
    
    /**
     * 获取用章登记数据(更多)
     * @param param   业务参数
     */
    func requestForProjectCachetMoreData(param: PARAMETERTYPE?) {
        let request = DQSNetworkManager.sharedInstance.requestForData(methodName: "projectCachet", bussinessParam: param, success: { (response) in
            let cachetBean = THJGProjectCachetBean.parse(response)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: THJG_NOTIFICATION_CACHET_MOREDATA_SUCCESS), object: THJGSuccessBean(bean: cachetBean, msg: nil))
        }) { (code, message) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: THJG_NOTIFICATION_CACHET_MOREDATA_FAILURE), object: THJGFailureBean(errorCode: code, msg: message))
        }
        requestQueue.append(request)
    }
}

//MARK: - METHODS
extension THJGProjectCachetViewModel {
    
     func handleCachetData(_ bean: THJGProjectCachetBean) -> [ProjectCachetSectionHandledBean] {
        var handledBeans = [ProjectCachetSectionHandledBean]()
        let medals = bean.medals
        for medal in medals {
            var handledDetailBeans = [ProjectCachetCellHandledBean]()
            for detail in medal.useDetails {
                //计算行高
                var cellHeight: CGFloat = 75
                //文件名
                let content = DQSUtils.isNotBlank(detail.cachetType) ?  (detail.cachetFileName + "（\(detail.cachetPortions)份/\(detail.cachetType)）") : (detail.cachetFileName + "（\(detail.cachetPortions)份）")
                var trailing = 16
                trailing = detail.cachetOut == 1 ? 70 : 16
                let textHeight = DQSUtils.heightForText(text: content, fixedWidth: SCREEN_WIDTH-16-CGFloat(trailing), fixedFont: UIFont.boldSystemFont(ofSize: 16)) + 25
                if textHeight > 55 {
                    cellHeight += (textHeight - 55)
                }
                //用章人员
                if DQSUtils.isNotBlank(detail.cachetDepartment) {
                    if DQSUtils.isNotBlank(detail.cachetUser) {
                        let textHeight = DQSUtils.heightForText(text: "\(detail.cachetDepartment) - \(detail.cachetUser)", fixedWidth: SCREEN_WIDTH-116, fixedFont: UIFont.systemFont(ofSize: 14)) + 10
                        cellHeight += max(40, textHeight)
                    } else {
                        let textHeight = DQSUtils.heightForText(text: detail.cachetDepartment, fixedWidth: SCREEN_WIDTH-116, fixedFont: UIFont.systemFont(ofSize: 14)) + 10
                        cellHeight += max(40, textHeight)
                    }
                } else {
                    if DQSUtils.isNotBlank(detail.cachetUser) {
                        cellHeight += 40
                    }
                }
                //监管人员
                if DQSUtils.isNotBlank(detail.cachetInspector) {
                    let textHeight = DQSUtils.heightForText(text: detail.cachetInspector, fixedWidth: SCREEN_WIDTH-116, fixedFont: UIFont.systemFont(ofSize: 14)) + 10
                    cellHeight += max(40, textHeight)
                }
                //备注
                if DQSUtils.isNotBlank(detail.cachetRemark) {
                   let textHeiht = DQSUtils.heightForText(text: detail.cachetRemark, fixedWidth: SCREEN_WIDTH-116, fixedFont: UIFont.systemFont(ofSize: 14)) + 30
                    cellHeight += textHeiht
                }
                //资源
                if !detail.cachetResources.isEmpty {
                    cellHeight += 130
                }
                
                handledDetailBeans.append(ProjectCachetCellHandledBean(cellBean: detail, cellHeight: cellHeight))
            }
            handledBeans.append(ProjectCachetSectionHandledBean(useDate: medal.useTime, useDetails: handledDetailBeans))
        }
        return handledBeans
    }
}
