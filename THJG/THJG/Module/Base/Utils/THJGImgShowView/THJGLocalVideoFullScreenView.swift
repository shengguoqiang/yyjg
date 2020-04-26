/**
 * 本地视频全屏
 */

import UIKit
import AVKit

class THJGLocalVideoFullScreenView: UIView {

    @IBOutlet weak var containerView: UIView!
    var avPlayerVC: AVPlayerViewController?
    
    var url: String! {
        didSet {
            let avPlayer = AVPlayer(url: URL(string: url)!)
            avPlayerVC = AVPlayerViewController()
            avPlayerVC?.showsPlaybackControls = false
            avPlayerVC!.player = avPlayer
            avPlayerVC!.view.frame = containerView.bounds
            containerView.addSubview(avPlayerVC!.view)
            avPlayerVC?.player?.play()
        }
    }
    
    static func showLocalVideoFullScreen() -> THJGLocalVideoFullScreenView {
        return Bundle.main.loadNibNamed("THJGLocalVideoFullScreenView", owner: self, options: nil)?.last as! THJGLocalVideoFullScreenView
    }
    
    deinit {
        avPlayerVC?.player?.pause()
        avPlayerVC = nil
    }
    
}

extension THJGLocalVideoFullScreenView {
    
    //退出全屏事件监听
    @IBAction func backBtnDidClicked(_ sender: UIButton) {
        //发送切换屏通知
        NotificationCenter.default.post(name: NSNotification.Name(NOTIFICATION_VIDEO_REC_SMALLSCREEN), object: nil)
        
        //移除当前视图
        removeFromSuperview()
    }
    
}
