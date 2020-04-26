/**
 * 市场信息VM
 */

/* 成功通知 */
let THJG_NOTIFICATION_MARKETINFO_SUCCESS = "THJG_NOTIFICATION_MARKETINFO_SUCCESS"

/* 处理过的市场信息实体 */
struct THJGProMarketHandledInfoBean {
    var title: String
    var content: String
    var cellHeight: CGFloat
}

class THJGProMarketInfoViewModel: THJGBaseViewModel {

    /**
     * 获取市场情况数据
     * @param param   业务参数
     */
    func requestForProjectMarketInfoData(param: PARAMETERTYPE?) {
        let request = DQSNetworkManager.sharedInstance.requestForData(methodName: "projectMarketInfo", bussinessParam: param, success: { (response) in
            let marketBean = THJGProMarketInfoBean.parse(response)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: THJG_NOTIFICATION_MARKETINFO_SUCCESS), object: THJGSuccessBean(bean: marketBean, msg: nil))
        }) { (code, message) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: THJG_NOTIFICATION_NETWORK_FAILURE), object: THJGFailureBean(errorCode: code, msg: message))
        }
        requestQueue.append(request)
    }
    
}

//MARK: - METHODS
extension THJGProMarketInfoViewModel {
    
    func handleData(bean: THJGProMarketInfoBean) -> [THJGProMarketHandledInfoBean] {
        var result = [THJGProMarketHandledInfoBean]()
        for market in bean.marketInfos {
            //根据内容计算行高
            var cellHeight: CGFloat = 45
            if DQSUtils.isNotBlank(market.marketContent) {
                let textHeight = DQSUtils.heightForText(text: market.marketContent, fixedWidth: SCREEN_WIDTH - 30, fixedFont: UIFont.systemFont(ofSize: 14)) + 15
                cellHeight += textHeight
            }
            let handledBean = THJGProMarketHandledInfoBean(title: market.marketTitle, content: market.marketContent, cellHeight: cellHeight)
            result.append(handledBean)
        }
        return result
    }
}
