/**
 * 缩略图cell
 */

import UIKit

class THJGBriefImgShowCell: UICollectionViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var playView: UIImageView!
    @IBOutlet weak var liveView: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    var bean: THJGImgShowBean! {
        didSet {
            if bean.isVideo, bean.videoType! == 20 {//本地视频
                imgView.image = UIImage(named: "common_bg_placeholder_nodata")
                DispatchQueue.global().async {
                    let image = DQSUtils_OC.thumbnailImage(forVideo: URL(string: self.bean.videoUrl ?? "")!, atTime: 1)
                    DispatchQueue.main.async {
                        self.imgView.image = image
                    }
                }
            } else if bean.isPdf {//pdf
                imgView.image = UIImage(named: "pro_pdf_big")
            } else {//实时视频、图片
                imgView.kf.setImage(with: URL(string: bean.imgUrl), placeholder: UIImage(named: "common_bg_placeholder_nodata"), options: nil, progressBlock: nil, completionHandler: nil)
            }
            liveView.isHidden = !(bean.isVideo && bean.videoType! != 20)
            if bean.videoType == 13 && bean.videoStatus != 1 { // 大华视频离线
                liveView.text = "离线"
            } else {
                liveView.text = "实时"
            }
            playView.isHidden = !bean.isVideo
            nameLabel.text = bean.imgName
        }
    }
    
}
