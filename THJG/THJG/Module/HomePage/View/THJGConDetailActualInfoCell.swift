/**
 * 合同台账付款信息-实际付款信息
 */

import UIKit

class THJGConDetailActualInfoCell: UITableViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var seperator: UIView!
    
    func reloadData(_ bean: ProjectContractActualDetailBean, curIndex: Int, totalIndex: Int) {
        
        //调整UI&&赋值
        if curIndex == 0 {
            timeLabel.textColor = DQSUtils.rgbColor(150, 150, 150)
            timeLabel.font = UIFont.systemFont(ofSize: 14)
            amountLabel.textColor = timeLabel.textColor
            amountLabel.font = timeLabel.font
            seperator.isHidden = false
            
            timeLabel.text = "实际付款日"
            amountLabel.text = "金额(万元)"
        } else if curIndex == totalIndex {
            timeLabel.textColor = DQSUtils.rgbColor(33, 33, 33)
            timeLabel.font = UIFont.boldSystemFont(ofSize: 16)
            amountLabel.textColor = timeLabel.textColor
            amountLabel.font = timeLabel.font
            seperator.isHidden = true
            
            timeLabel.text = "合计"
            amountLabel.text = DQSUtils.showNumWithComma(num: DQSUtils.showDoubleNum(sourceDouble: bean.conActualAmount, floatNum: 2, showStyle: .showStyleNoZero))
        } else {
            timeLabel.textColor = DQSUtils.rgbColor(33, 33, 33)
            timeLabel.font = UIFont.systemFont(ofSize: 14)
            amountLabel.textColor = timeLabel.textColor
            amountLabel.font = timeLabel.font
            seperator.isHidden = true
            
            timeLabel.text = (bean.conActualTime != 0) ? DQSUtils.showTime(interval: TimeInterval(bean.conActualTime/1000), timeFormate: "yyyy年MM月dd日") : "-"
            amountLabel.text = (bean.conActualAmount != 0) ? DQSUtils.showNumWithComma(num: DQSUtils.showDoubleNum(sourceDouble: bean.conActualAmount, floatNum: 2, showStyle: .showStyleNoZero)) : "-"
        }
    }
}
