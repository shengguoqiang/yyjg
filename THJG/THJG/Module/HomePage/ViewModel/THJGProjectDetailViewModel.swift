/**
 * 项目详情VM
 */

/* 成功通知 */
let THJG_NOTIFICATION_PROHECT_DETAIL_SUCCESS = "THJG_NOTIFICATION_PROHECT_DETAIL_SUCCESS"

/* 项目详情-section标题常量 */
let PRO_SECTION_SITUATION      = "项目概况"
let PRO_SECTION_VIDEO_SGXC     = "施工现场"
let PRO_SECTION_VIDEO_RCGL     = "日常管理"
let PRO_SECTION_INDICATOR      = "项目监控"
let PRO_SECTION_SELLMARKET     = "销售市场"
let PRO_SECTION_LOANCOMPANY    = "借款企业"
let PRO_SECTION_DEVELOPER      = "开发商"
let PRO_SECTION_GUARANTEE      = "担保企业"
let PRO_SECTION_DIZHIYA        = "抵/质押情况"
let PRO_SECTION_OPERATOR       = "施工方"

/* 项目详情-开发商信息-标题常量 */
let PRO_DEV_NAME = "企业名称"
let PRO_DEV_CODE = "统一社会信用代码"
let PRO_DEV_LEGALNAME = "法人姓名"
let PRO_DEV_DES = "企业描述"

class THJGProjectDetailViewModel: THJGBaseViewModel {

    /**
     * 获取项目详情数据
     * @param param   业务参数
     */
    func requestForProjectDetailData(param: PARAMETERTYPE?) {
        let request = DQSNetworkManager.sharedInstance.requestForData(methodName: "projectDetail", bussinessParam: param, success: {(response) in
            let proDetailBean = THJGProjectDetailBean.parse(response)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: THJG_NOTIFICATION_PROHECT_DETAIL_SUCCESS), object: THJGSuccessBean(bean: proDetailBean, msg: nil))
        }) {(code, message) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: THJG_NOTIFICATION_NETWORK_FAILURE), object: THJGFailureBean(errorCode: code, msg: message))
        }
        requestQueue.append(request)
    }
    
}

extension THJGProjectDetailViewModel {
    
    func handleProDetailData(bean: THJGProjectDetailBean) -> [(String, [Any])] {
        var resArr = [(String, [Any])]()
        
        //项目描述
        if DQSUtils.isNotBlank(bean.proSituation) {
            //计算项目概况高度
            let textHeight = DQSUtils.heightForText(text: bean.proSituation, fixedWidth: SCREEN_WIDTH - 30, fixedFont: UIFont.systemFont(ofSize: 14)) + 10
            //计算项目风险高度
            var riskHeight: CGFloat = 0
            if DQSUtils.isNotBlank(bean.proRisk) {
                riskHeight = DQSUtils.heightForText(text: bean.proRisk, fixedWidth: SCREEN_WIDTH - 65, fixedFont: UIFont.systemFont(ofSize: 14)) + 10
            }
            let situation = ProDetailTempBean(title: PRO_SECTION_SITUATION, content: bean, cellHeight: 95+textHeight+20+riskHeight)
            resArr.append((PRO_SECTION_SITUATION, [situation]))
        }
        
        //施工现场
        let sgxcVideo = ProDetailTempBean(title: PRO_SECTION_VIDEO_SGXC, content: bean.proVideos, cellHeight: 160)
        resArr.append((PRO_SECTION_VIDEO_SGXC, [sgxcVideo]))
        
        //日常管理
        let rcglVideo = ProDetailTempBean(title: PRO_SECTION_VIDEO_RCGL, content: bean.proDaylyManageVideos, cellHeight: 160)
        resArr.append((PRO_SECTION_VIDEO_RCGL, [rcglVideo]))
        
        //项目监控
        var indicators = [String]()
        for (index, value) in bean.proIndicators.enumerated() {
            if index != 4 {//去除【销售信息】
                indicators.append(String(value))
            }
        }
        let monitor = ProDetailTempBean(title: PRO_SECTION_INDICATOR, content: indicators, cellHeight: 230)
        resArr.append((PRO_SECTION_INDICATOR, [monitor]))
        
        //销售市场
        let sellInfo = ProDetailTempBean(title: PRO_SECTION_SELLMARKET, content: bean.proSellIndicators, cellHeight: 125)
        resArr.append((PRO_SECTION_SELLMARKET, [sellInfo]))
        
        //借款企业
        if !bean.loanCompanys.isEmpty {
            var loanInfos = [ProDetailTempBean]()
            for loan in bean.loanCompanys {
                let loanInfo = ProDetailTempBean(title: loan.companyName, content: loan, cellHeight: 175)
                loanInfos.append(loanInfo)
            }
            resArr.append((PRO_SECTION_LOANCOMPANY, loanInfos))
        }
        
        //开发商
        if !bean.devCompanys.isEmpty {
            var devInfos = [ProDetailTempBean]()
            for dev in bean.devCompanys {
                let devInfo = ProDetailTempBean(title: dev.companyName, content: dev, cellHeight: 175)
                devInfos.append(devInfo)
            }
            resArr.append((PRO_SECTION_DEVELOPER, devInfos))
        }
        
        //担保企业
        if !bean.guaranteeCompanys.isEmpty {
            var guaInfos = [ProDetailTempBean]()
            for gua in bean.guaranteeCompanys {
                let guaInfo = ProDetailTempBean(title: gua.companyName, content: gua, cellHeight: 175)
                guaInfos.append(guaInfo)
            }
            resArr.append((PRO_SECTION_GUARANTEE, guaInfos))
        } else {
            var guaInfos = [ProDetailTempBean]()
            let guaInfo = ProDetailTempBean(title: "暂无担保企业", content: THJGCompanyInfoBean(companyId: "", companyName: "暂无担保企业", companyIndicators: "000", companyType: ""), cellHeight: 175)
            guaInfos.append(guaInfo)
            resArr.append((PRO_SECTION_GUARANTEE, guaInfos))
        }
        
        //抵/质押情况
        var temArr = [THJGPldgeInfoBean]()
        //抵押物-设定时
        temArr.append(THJGPldgeInfoBean(pledgeIndex: 0, pledgeType: 10, pledgeNodeType: 10, pledgeContent: ""))
        //抵押物-目前现状
        temArr.append(THJGPldgeInfoBean(pledgeIndex: 1, pledgeType: 10, pledgeNodeType: 20, pledgeContent: ""))
        //质押物-设定时
        temArr.append(THJGPldgeInfoBean(pledgeIndex: 2, pledgeType: 20, pledgeNodeType: 10, pledgeContent: ""))
        //质押物-目前现状
        temArr.append(THJGPldgeInfoBean(pledgeIndex: 3, pledgeType: 20, pledgeNodeType: 20, pledgeContent: ""))
        
        for pledge in bean.pledgeInfos {
            for (index, temp) in temArr.enumerated() {
                if pledge.pledgeIndex == temp.pledgeIndex {//对应
                    temArr[index] = pledge
                }
            }
        }
        
        let plegeInfo = ProDetailTempBean(title: PRO_SECTION_DIZHIYA, content: temArr, cellHeight: 350)
        resArr.append((PRO_SECTION_DIZHIYA, [plegeInfo]))
        
        //施工方
        if !bean.workCompanys.isEmpty {
            var workInfos = [ProDetailTempBean]()
            for work in bean.workCompanys {
                let workInfo = ProDetailTempBean(title: work.companyName, content: work, cellHeight: 175)
                workInfos.append(workInfo)
            }
            resArr.append((PRO_SECTION_OPERATOR, workInfos))
        } else {
            var workInfos = [ProDetailTempBean]()
            let workInfo = ProDetailTempBean(title: "暂无施工方", content: THJGCompanyInfoBean(companyId: "", companyName: "暂无施工方", companyIndicators: "00", companyType: ""), cellHeight: 175)
            workInfos.append(workInfo)
            resArr.append((PRO_SECTION_OPERATOR, workInfos))
        }
        
        return resArr
    }
    
}

//MARK: - CELL展示实体
struct ProDetailTempBean {
    var title: String?
    var content: Any?
    var cellHeight: CGFloat?
}
