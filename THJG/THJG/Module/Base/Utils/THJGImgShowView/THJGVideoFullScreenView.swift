/**
 * 全屏展示录像
 */

import UIKit

class THJGVideoFullScreenView: UIView {
    
    
    @IBOutlet weak var containerView: UIView!
    var mplayer: EZUIPlayer!
    
    static func showFullScreen() -> THJGVideoFullScreenView {
        return Bundle.main.loadNibNamed("THJGVideoFullScreenView", owner: self, options: nil)?.last as! THJGVideoFullScreenView
    }
    
    var url: String! {
        didSet {
            mplayer = EZUIPlayer.createPlayer(withUrl: url)
            mplayer.mDelegate = self
            mplayer.previewView.frame = containerView.bounds
            containerView.addSubview(mplayer.previewView)
        }
    }
    
    deinit {
        mplayer.release()
    }
    
}

extension THJGVideoFullScreenView {
    
    //取消全屏事件监听
    @IBAction func backBtnDidClicked(_ sender: UIButton) {
        //发送切换屏通知
        NotificationCenter.default.post(name: NSNotification.Name(NOTIFICATION_VIDEO_REC_SMALLSCREEN), object: nil)
        
        //移除当前视图
        removeFromSuperview()
    }
    
}

extension THJGVideoFullScreenView: EZUIPlayerDelegate {
    
    func ezuiPlayerPrepared(_ player: EZUIPlayer!) {
        mplayer.startPlay()
    }
    
}
