/**
 * 资金信息-合同台账header
 */

import UIKit

class THJGProjectContractHeaderView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var contractNameLabel: UILabel!
    
    @IBOutlet weak var checkContractBtn: UIButton!
    
    @IBOutlet weak var departmentNameLabel: UILabel!
    @IBOutlet weak var contractAmountLabel: UILabel!
    @IBOutlet weak var actualAmountLabel: UILabel!
    
    var bean: ProjectContractBean! {
        didSet {
            contractNameLabel.text = bean.conName
            checkContractBtn.isHidden = DQSUtils.isBlank(bean.conContentUrl)
            departmentNameLabel.text = bean.conDepartmentName
            contractAmountLabel.text = "\(DQSUtils.showNumWithComma(num: DQSUtils.showDoubleNum(sourceDouble: bean.conSum, floatNum: 2, showStyle: .showStyleNoZero)))万元"
            actualAmountLabel.text = "\(DQSUtils.showNumWithComma(num: DQSUtils.showDoubleNum(sourceDouble: bean.conActualAmount, floatNum: 2, showStyle: .showStyleNoZero)))万元"
        }
    }
}

//MARK: - METHODS
extension THJGProjectContractHeaderView {
    
    //查看合同事件监听
    @IBAction func checkContractDidClicked(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(NOTIFICATION_PROJECT_CHECK_CONTRACT), object: bean)
    }
    
    //查看合同付款详情
    @IBAction func headerDidClicked(_ sender: UIButton) {
       NotificationCenter.default.post(name: NSNotification.Name(NOTIFICATION_PROJECT_CHECK_CONTRACT_PAYDETAIL), object: bean)
    }
    
}
