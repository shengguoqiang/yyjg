/**
 * 公告cell
 */

import UIKit

class THJGHomePageBullteinCell: FTDCollectionViewCell {
    
    //properties
    @IBOutlet weak var bulletinTitleLabel: UILabel!
    
    //reload the data
    override func reloadData(_ bean: AnyObject) {
        let bulletinBean = bean as! PlatformNoticeBean
        bulletinTitleLabel.text = bulletinBean.noticeTitle
    }

}
