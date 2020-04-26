/**
 * 录像回放
 */

import UIKit

class THJGVideoRecView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var videoView: UIView!
    var mplayer: EZUIPlayer!
    
    var param: (title: String, url: String)! {
        didSet {
            //标题
            titleLabel.text = param.0
            
            //录像
            mplayer = EZUIPlayer.createPlayer(withUrl: param.1)
            mplayer.mDelegate = self
            videoView.addSubview(mplayer.previewView)
        }
    }
    
    static func showVideoRecView() -> THJGVideoRecView {
        return Bundle.main.loadNibNamed("THJGVideoRecView", owner: self, options: nil)?.last as! THJGVideoRecView
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //获得具体尺寸布局
        mplayer.previewView.frame = videoView.bounds
    }
    
    deinit {
        mplayer.release()
    }
}

extension THJGVideoRecView {
    
    //取消事件监听
    @IBAction func cancleDidClicked(_ sender: UIButton) {
        removeFromSuperview()
    }
    
    //全屏事件监听
    @IBAction func fullScreenDidClicked(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(NOTIFICATION_VIDEO_REC_FULLSCREEN), object: param.1)
    }
}

extension THJGVideoRecView: EZUIPlayerDelegate {
    
    func ezuiPlayerPrepared(_ player: EZUIPlayer!) {
        mplayer.startPlay()
    }
}
