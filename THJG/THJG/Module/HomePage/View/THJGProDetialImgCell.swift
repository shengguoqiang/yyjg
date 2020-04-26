/**
 * 项目平面图cell
 */

import UIKit
import Kingfisher

class THJGProDetialImgCell: FTDCollectionViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    
    override func reloadData(_ bean: AnyObject) {
        let imgBean = bean as! THJGProImgBean
        imgView.kf.setImage(with: URL(string: imgBean.proImgUrl), placeholder: UIImage(named: "common_bg_placeholder_nodata"), options: nil, progressBlock: nil, completionHandler: nil)
    }

}
