/**
 * 查看大图cell
 */

import UIKit
import AVKit

class THJGImgShowCell: UICollectionViewCell {

    @IBOutlet weak var imgView: UIImageView!
    var avPlayerVC: AVPlayerViewController?
    
    var bean: THJGImgShowBean! {
        didSet {
            //图片
            imgView.kf.setImage(with: URL(string: bean.imgUrl), placeholder: UIImage(named: "common_bg_placeholder_nodata"), options: nil, progressBlock: nil, completionHandler: nil)
        }
    }
    
    deinit {
        DQSUtils.log("播放器销毁")
        avPlayerVC?.player = nil
        avPlayerVC?.view.removeFromSuperview()
    }
    
}

//MARK: - 图片、视频实体
struct THJGImgShowBean {
    var imgUrl: String
    var imgName: String
    var isVideo: Bool
    var videoType: Int?      //10.萤石视频 20.本地视频 13.大华视频
    var videoStatus: Int?
    var videoSerial: String?
    var videoUrl: String?
}

struct THJGImageShowHandledBean {
    var showBean: THJGImgShowBean
    var localVideoScreenImage: UIImage?
}

//MARK: - 判断当前资源是否是pdf
extension THJGImgShowBean {
    var isPdf: Bool {
        return imgUrl.contains("viewPdf")
    }
}

//MARK: - 本地视频URL支持的格式
extension String {
    func isLocalVideo() -> Bool {
        return (self.lowercased().hasSuffix(".mov") || self.lowercased().hasSuffix(".mp4"))
    }
}
