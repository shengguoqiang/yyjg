/**
 * 公司CELL
 */

let PRO_COMPANY_BASE = "公司信息"
let PRO_COMPANY_FUND = "财务信息"
let PRO_COMPANY_RISK = "风险信息"

import UIKit

class THJGProCompanyCell: UITableViewCell {

    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var baseBtn: THJGProDetailTapButton!
    @IBOutlet weak var fundBtn: THJGProDetailTapButton!
    @IBOutlet weak var riskBtn: THJGProDetailTapButton!
    
    lazy var btns: [THJGProDetailTapButton] = {
       return [baseBtn, fundBtn, riskBtn]
    }()
    
    var bean: THJGCompanyInfoBean! {
        didSet {
            companyNameLabel.text = bean.companyName
            for (index, value) in bean.companyIndicators.enumerated() {
                btns[index].isSelected = String(value) != "1"
            }
        }
    }
    
    var handledBlock: THJGProDetailTabBlock!
    
    func reloadData(bean: THJGCompanyInfoBean,
                    bloc: @escaping THJGProDetailTabBlock) {
        self.bean = bean
        handledBlock = bloc
    }
    
}

//MARK: - METHODS
extension THJGProCompanyCell {
    
    //事件响应
    @IBAction func btnDidClicked(_ sender: UIButton) {
        let title = sender.titleLabel?.text ?? ""
        var index = 0
        switch title {
        case PRO_COMPANY_BASE: //公司信息
            index = 0
        case PRO_COMPANY_FUND: //财务信息
            index = 1
        case PRO_COMPANY_RISK: //风险信息
            index = 2
        default:
            break
        }
        handledBlock(title, index)
    }
}
