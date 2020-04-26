/**
 * 销售信息-销售明细-幢cell
 */

import UIKit

class THJGProjectSellDetailBlockCell: UITableViewCell {
    
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var roomLabel: UILabel!
    @IBOutlet weak var squareLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var arrowView: UIImageView!
    
    @IBOutlet weak var topSeperator: UIView!
    @IBOutlet weak var bottomSeperator: UIView!
    
    @IBOutlet weak var innerSeperator: UIView!
    
    
    func reloadData(_ bean: ProjectBlockSellDetailBean, index: Int, totalIndex: Int) {
        //调整UI
        arrowView.isHidden = index == 0
        topSeperator.isHidden = index != 0
        innerSeperator.isHidden = index != 0
        bottomSeperator.isHidden = index != totalIndex
        
        //赋值
        guard index != 0 else {
            unitLabel.text = "单元"
            roomLabel.text = "房号"
            squareLabel.text = "建筑面积(㎡)"
            statusLabel.text = "销售状态"
            return
        }
        unitLabel.text = DQSUtils.isNotBlank(bean.blockUnit) ? bean.blockUnit : "-"
        roomLabel.text = DQSUtils.isNotBlank(bean.unitRoom) ? bean.unitRoom : "-"
        squareLabel.text = bean.roomSquare != 0 ? DQSUtils.showNumWithComma(num: DQSUtils.showDoubleNum(sourceDouble: bean.roomSquare, floatNum: 2, showStyle: .showStyleNoZero)) : "-"
        switch bean.roomSellStatus {//10 待售 20 认购 30 网签 40 不可售
        case 10:
            statusLabel.text = "待售"
        case 20:
            statusLabel.text = "认购"
        case 30:
            statusLabel.text = "网签"
        case 40:
            statusLabel.text = "不可售"
        default:
            statusLabel.text = "-"
            break
        }
        
    }
}
