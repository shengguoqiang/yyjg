/**
 * 项目描述CELL
 */

import UIKit

class THJGProSituationCell: UITableViewCell {

    
    @IBOutlet weak var proTypeLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var contentHeight: NSLayoutConstraint!
    @IBOutlet weak var warnImageView: UIImageView!
    @IBOutlet weak var riskLabel: UILabel!
    @IBOutlet weak var riskHeight: NSLayoutConstraint!
    
    
    var bean: THJGProjectDetailBean! {
        didSet {
            proTypeLabel.text = bean.proType
            contentHeight.constant = DQSUtils.heightForText(text: bean.proSituation, fixedWidth: SCREEN_WIDTH-30, fixedFont: UIFont.systemFont(ofSize: 14))+10
            contentLabel.text = bean.proSituation
            warnImageView.isHidden = DQSUtils.isBlank(bean.proRisk)
            riskLabel.isHidden = warnImageView.isHidden
            riskHeight.constant = DQSUtils.heightForText(text: bean.proRisk, fixedWidth: SCREEN_WIDTH - 65, fixedFont: UIFont.systemFont(ofSize: 14)) + 10
            riskLabel.text = bean.proRisk
        }
    }
    
}
