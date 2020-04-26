/**
 * 市场信息CELL
 */

import UIKit

class THJGProMarketInfoCell: UITableViewCell {

    @IBOutlet weak var marketTitleLabel: UILabel!
    @IBOutlet weak var marketContentLabel: UILabel!
    
    var bean: THJGProMarketHandledInfoBean! {
        didSet {
            marketTitleLabel.text = bean.title
            marketContentLabel.text = bean.content
        }
    }
}
