/**
 * 项目cell
 */

import UIKit

class THJGProjectCell: UITableViewCell {

    //properties
    @IBOutlet weak var projectNameLabel: UILabel!
    @IBOutlet weak var statusBtn: UIButton!
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var projectTypeLabel: UILabel!
    @IBOutlet weak var loanAmountLabel: UILabel!
    @IBOutlet weak var balanceAmountLabel: UILabel!
    @IBOutlet weak var expireDateLabel: UILabel!
    
    
    //reloadData
    func reloadData(_ bean: THJGProjectBean) {
        projectNameLabel.text = bean.projectName
        statusBtn.isSelected = bean.projectStatus != 10
        thumbImageView.kf.setImage(with: URL(string: bean.projectImg), placeholder: UIImage(named: "common_bg_placeholder_nodata"), options: nil, progressBlock: nil, completionHandler: nil)
        
        projectTypeLabel.text = bean.projectType
        loanAmountLabel.text = "\(DQSUtils.showNumWithComma(num: DQSUtils.showDoubleNum(sourceDouble: bean.projectLoanAmount, floatNum: 2, showStyle: .showStyleNoZero)))万元"
        balanceAmountLabel.text = "\(DQSUtils.showNumWithComma(num: DQSUtils.showDoubleNum(sourceDouble: bean.projectLoanBalance, floatNum: 2, showStyle: .showStyleNoZero)))万元"
        expireDateLabel.text = DQSUtils.showTime(interval: TimeInterval(bean.projectExpireDate/1000), timeFormate: "yyyy-MM-dd")
    }
    
}
