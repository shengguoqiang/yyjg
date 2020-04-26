/**
 * 我的cell
 */

import UIKit

class THJGMyCenterCell: UITableViewCell {

    @IBOutlet weak var leadIconBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var msgView: UIView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var trailView: UIImageView!
    
    var bean: MyHandledBean! {
        didSet {
            leadIconBtn.setImage(UIImage(named: bean.leadIcon), for: .normal)
            titleLabel.text = bean.titile
            if bean.titile == "我的消息" {
                msgView.isHidden = bean.msgUnRead == 0
            } else {
                msgView.isHidden = true
            }
            contentLabel.text = bean.content
            trailView.isHidden = DQSUtils.isBlank(bean.trailIcon)
            trailView.image = UIImage(named: bean.trailIcon ?? "")
        }
    }
    
}
