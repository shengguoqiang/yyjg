/**
 * 查看萤石实时视频
 */

import UIKit

class THJGEZOpenVideoCell: UICollectionViewCell {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var bgImgView: UIImageView!
    var mplayer: EZUIPlayer?
    
    var bean: THJGImgShowBean! {
        didSet {
            //加载背景图片
            bgImgView.kf.setImage(with: URL(string: bean.imgUrl), placeholder: UIImage(named: "common_bg_placeholder_nodata"), options: nil, progressBlock: nil, completionHandler: nil)
        }
    }
    
    deinit {
        //释放播放器资源
        mplayer?.release()
    }

}

//MARK: - 
extension THJGEZOpenVideoCell: EZUIPlayerDelegate {
    
    //播放成功
    func ezuiPlayerPlaySucceed(_ player: EZUIPlayer!) {
        
    }
    
    //播放失败
    func ezuiPlayer(_ player: EZUIPlayer!, didPlayFailed error: EZUIError!) {
        DQSUtils.showToast("播放失败:\(error.description)", self)
    }
    
}
