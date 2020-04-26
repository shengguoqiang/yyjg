/**
 * 竞品楼盘详情cell
 */


import UIKit

class THJGProjectCompetionDetailCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    var bean: ProjectSellCompetionDetailBean! {
        didSet {
            titleLabel.text = bean.title
            contentLabel.text = bean.content
        }
    }
    
}
