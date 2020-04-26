/**
 * 重要时间节点考核VM
 */

/* 成功通知 */
let THJG_NOTIFICATION_PROJECTTIMES_SUCCESS = "THJG_NOTIFICATION_PROJECTTIMES_SUCCESS"

//时间节点处理过的实体
struct ProTimesHandledBean {
    var cellBean: ProTimesBean
    var cellHeight: CGFloat
}

class THJGProjectTimesViewModel: THJGBaseViewModel {

    /**
     * 获取重要时间节点数据
     * @param param   业务参数
     */
    func requestForProTimesData(param: PARAMETERTYPE?) {
        let request = DQSNetworkManager.sharedInstance.requestForData(methodName: "projectTimes", bussinessParam: param, success: {(response) in
            let proTimeBean = THJGProjectTimesBean.parse(response)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: THJG_NOTIFICATION_PROJECTTIMES_SUCCESS), object: THJGSuccessBean(bean: proTimeBean, msg: nil))
        }) { (code, message) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: THJG_NOTIFICATION_NETWORK_FAILURE), object: THJGFailureBean(errorCode: code, msg: message))
        }
        requestQueue.append(request)
    }

}

extension THJGProjectTimesViewModel {
    /**
     * 处理原始数据，计算cell高度
     */
    func handleData(_ bean: THJGProjectTimesBean) -> [ProTimesHandledBean] {
        var handledBeans = [ProTimesHandledBean]()
        let times = bean.proTimes
        for time in times {
            //计算cell高度
            var cellHeight: CGFloat = 133//默认高度（包含前两行元素）
            if time.timeActualDate == 0, (time.systemCurDate < time.timeAppointDate || time.timeDelay <= 0) {//待完成-无实际日期或拖延时间
                cellHeight += 0
            } else {//已完成或已延期
                cellHeight += 38
            }
            if DQSUtils.isNotBlank(time.timeCurProgress) {//当前进度有值
                cellHeight += 38
            }
            if DQSUtils.isNotBlank(time.timeRemark) {//备注有值
                let remarkHeight = DQSUtils.heightForText(text: time.timeRemark, fixedWidth: SCREEN_WIDTH - 101, fixedFont: UIFont.systemFont(ofSize: 14)) + 20
                cellHeight += remarkHeight
            }
            
            handledBeans.append(ProTimesHandledBean(cellBean: time, cellHeight: cellHeight))
        }
        return handledBeans
    }
}
