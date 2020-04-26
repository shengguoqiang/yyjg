/**
 * 平台公告cell
 */

import UIKit

class THJGPlatformNoticeCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var abstractLabel: UILabel!
    
    var bean: PlatformNoticeBean! {
        didSet {
            titleLabel.text = bean.noticeTitle
            timeLabel.text = DQSUtils.showTime(interval: TimeInterval(bean.noticeDate/1000), timeFormate: "yyyy-MM-dd HH:mm")
            abstractLabel.text = bean.noticeAbstract
        }
    }
}
