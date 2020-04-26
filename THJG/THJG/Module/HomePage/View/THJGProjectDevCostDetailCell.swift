/**
 * 开发成本及费用明细cell
 */

import UIKit

class THJGProjectDevCostDetailCell: UITableViewCell {
    
    
    @IBOutlet weak var topSeperator: UIView!
    @IBOutlet weak var innerSeperator: UIView!
    @IBOutlet weak var bottomSeperator: UIView!
    

    @IBOutlet weak var nodeLabel: UILabel!
    @IBOutlet weak var actualAmountLabel: UILabel!
    
    func reloadData(_ bean: ProDevCostDetailBean, index: Int, totalIndex: Int) {
        //调整UI
        topSeperator.isHidden = index != 0
        innerSeperator.isHidden = (index == totalIndex)
        bottomSeperator.isHidden = !innerSeperator.isHidden
        
        //赋值
        nodeLabel.text = bean.costDetailNode
        actualAmountLabel.text = DQSUtils.showNumWithComma(num: DQSUtils.showDoubleNum(sourceDouble: bean.costDetailActualCost, floatNum: 2, showStyle: .showStyleNoZero))
    }
    
}
