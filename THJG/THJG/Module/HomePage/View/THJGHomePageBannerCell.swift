/**
 * bannercell
 */

import UIKit

class THJGHomePageBannerCell: FTDCollectionViewCell {
    
    //properties
    @IBOutlet weak var bannerImageView: UIImageView!
    
    // reload the data
    override func reloadData(_ bean: AnyObject) {
        let bannerBean = bean as! THJGBannerBean
        bannerImageView.kf.setImage(with: URL(string: bannerBean.bannerImg), placeholder: UIImage(named: "common_bg_placeholder"), options: nil, progressBlock: nil, completionHandler: nil)
    }

}
