/**
 * 合同付款信息-约定付款信息
 */

import UIKit

class THJGConDetailAppointInfoCell: UITableViewCell {

    @IBOutlet weak var indexLabel: UILabel!
    @IBOutlet weak var nodeLabel: UILabel!
    @IBOutlet weak var seperator: UIView!
    
    
    func reloadData(_ bean: ProjectContractAppointDetailBean, curIndex: Int, totalIndex: Int) {
        
        //调整UI&&赋值
        if curIndex == 0 {
            indexLabel.textColor = DQSUtils.rgbColor(150, 150, 150)
            nodeLabel.textColor = indexLabel.textColor
            seperator.isHidden = false
            indexLabel.text = "序号"
            nodeLabel.text = "约定节点"
        } else {
            indexLabel.textColor = DQSUtils.rgbColor(33, 33, 33)
            nodeLabel.textColor = indexLabel.textColor
            seperator.isHidden = true
            indexLabel.text = "\(curIndex)"
            nodeLabel.text = DQSUtils.isNotBlank(bean.conAppointNode) ? bean.conAppointNode : "-"
        }
    }
    
}
