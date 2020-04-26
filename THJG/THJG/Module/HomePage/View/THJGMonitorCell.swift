/**
 * 监控cell
 */

import UIKit

class THJGMonitorCell: UITableViewCell {
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    
    var bean: MonitorDetailBean! {
        didSet {
            iconView.kf.setImage(with: URL(string: bean.alarmPicUrl), placeholder: UIImage(named: "common_bg_placeholder_nodata"), options: nil, progressBlock: nil, completionHandler: nil)
            timeLabel.text = DQSUtils.showTime(interval: TimeInterval(bean.alarmTime/1000), timeFormate: "HH:mm:ss")
        }
    }
}
