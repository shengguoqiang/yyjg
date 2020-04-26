/**
 * 销售信息-销售明细-室销售详情（type two）
 */

import UIKit

class THJGProjectRoomDetailTypeTwoCell: UITableViewCell {

    
    @IBOutlet weak var infoContentLabel: UILabel!
    
    var bean: ProjectRoomSellDetailCellBean! {
        didSet {
            infoContentLabel.text = (bean.infoContent as! String)
        }
    }
}
