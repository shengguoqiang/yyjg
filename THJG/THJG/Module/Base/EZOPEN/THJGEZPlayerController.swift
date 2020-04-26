/**
 * 萤石视频播放器
 */

import UIKit

//MARK: - 播放类型
enum PlayerType {
    case live //直播
    case rec  //回放
}

class THJGEZPlayerController: THJGBaseController {
    
    var type: PlayerType = .live //默认直播

    var videoUrl: String = "" {
        didSet {
            //判断视频链接类型
            let mode = EZUIPlayer.getPlayMode(withUrl: videoUrl)
            if mode == EZUIKIT_PLAYMODE_REC {// 回放
                type = .rec
            }
        }
    }

    var mplayer: EZUIPlayer!

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        //创建播放器
        mplayer = EZUIPlayer.createPlayer(withUrl: videoUrl)
        mplayer.mDelegate = self
        mplayer.previewView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: view.bounds.height)
        view.addSubview(mplayer.previewView)
        if type == .live {
            mplayer.startPlay()
        }
    }

    deinit {
        mplayer.stopPlay()
    }

}

//MARK: - EZUIPlayerDelegate
extension THJGEZPlayerController: EZUIPlayerDelegate {
    
    func ezuiPlayerPrepared(_ player: EZUIPlayer!) {
        if type == .rec {
            mplayer.startPlay()
        }
    }
}
