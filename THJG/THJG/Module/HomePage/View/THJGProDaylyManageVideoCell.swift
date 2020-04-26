/**
 * 日常管理CELL
 */

import UIKit

class THJGProDaylyManageVideoCell: UITableViewCell {

    var imgShowView: THJGBriefImgShowView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgShowView = THJGBriefImgShowView.showBriefImgView()
        imgShowView.frame = CGRect(x: 0, y: 0.5, width: bounds.width, height: bounds.height-0.5)
        addSubview(imgShowView)
    }
    
    func reloadData(_ beans: [THJGProVideoBean],
                    selectBlock: @escaping ImgShowBlock) {
        imgShowView.isHidden = beans.isEmpty
        guard !beans.isEmpty else {
            return
        }
        var imgBeans = [THJGImgShowBean]()
        for video in beans {
            imgBeans.append(THJGImgShowBean(imgUrl: video.proVideoPic, imgName: video.proVideoName, isVideo: true, videoType: video.proVideoType, videoStatus: video.proVideoStatus, videoSerial: video.proVideoDeviceSerial, videoUrl: video.proVideoUrl))
        }
        imgShowView.reloadData(imgBeans) { (beans, curIndex) in
            selectBlock(beans, curIndex)
        }
    }
    
}
