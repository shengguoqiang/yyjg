/**
 * 站内信cell
 */

import UIKit

class THJGInnerMsgCell: UITableViewCell {

    @IBOutlet weak var statusImg: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    var bean: InnerMsgBean! {
        didSet {
            statusImg.image = (bean.msgIsRead == 0) ? UIImage(named: "my_msg_read") : UIImage(named: "my_msg_unread")
            titleLabel.text = bean.msgTitle
            contentLabel.text = bean.msgContent
            timeLabel.text = DQSUtils.showTime(interval: TimeInterval(bean.msgSendDate/1000), timeFormate: "yyyy-MM-dd HH:mm")
        }
    }
    
}
