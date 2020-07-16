/**
 * 大华视频cell
 */

import UIKit

class THJGLeChengVideoCell: UICollectionViewCell {
    
    //MARK: UI元素
    /**
     * 背景图片
     */
    @IBOutlet weak var bgImgView: UIImageView!
    /**
     * 视频组件
     */
    var m_play: LCOpenSDK_PlayWindow!
    
    //MARK: 加载数据
    var bean: THJGImgShowBean! {
        didSet {
            //加载背景图片
            bgImgView.kf.setImage(with: URL(string: bean.imgUrl), placeholder: UIImage(named: "common_bg_placeholder_nodata"), options: nil, progressBlock: nil, completionHandler: nil)
        }
    }
    
    deinit {
        stopRtspVideo()
    }
    
    //MARK: 关闭视频
    func stopRtspVideo() {
        guard m_play != nil else {
            return
        }
        m_play.stopRtspReal()
        m_play.getView()?.removeFromSuperview()
        m_play = nil
    }
    
    //MARK: 播放视频
    func startRtspVideo() {
        if m_play == nil {
            m_play = LCOpenSDK_PlayWindow(playWindow: bounds, index: 0)
            m_play.setSurfaceBGColor(.black)
            addSubview(m_play.getView())
        }
        let appD = UIApplication.shared.delegate as! THJGAppDelegate
        m_play.playRtspReal(appD.lcDataCtl.token,
                            devID: bean.videoSerial ?? "",
                            psk: "",
                            channel: 0,
                            definition: 1,
                            optimize: true)
    }
}

