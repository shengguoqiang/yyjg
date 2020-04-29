/**
 * 日销售详情cell
 */

import UIKit

class THJGProjectSellDayDetailCell: UITableViewCell {

    //MARK: UI元素
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    
    
    func reloadData(_ bean: THJGProjectSellDayDetailDayBean) {
        // 时间
        timeLabel.text = bean.proSellDate
        // 销售量
        amountLabel.text = "\(bean.proSold)"
        // 销售额
        moneyLabel.text = "\(DQSUtils.showNumWithComma(num: DQSUtils.showDoubleNum(sourceDouble: bean.proDfinalAmount/10000, floatNum: 2, showStyle: .showStyleNoZero)))"
    }
    
}
