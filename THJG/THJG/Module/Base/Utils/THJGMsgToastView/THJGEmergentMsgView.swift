/**
 * 紧急公告
 */

import UIKit

class THJGEmergentMsgView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    var bean: EmergentMsgBean! {
        didSet {
            titleLabel.text = bean.msgTitle
            textView.text = bean.msgContent
        }
    }
    
    static func showEmergentMsgView() -> THJGEmergentMsgView {
        return Bundle.main.loadNibNamed("THJGEmergentMsgView", owner: self, options: nil)?.last as! THJGEmergentMsgView
    }
    
}

extension THJGEmergentMsgView {
    //知道啦事件监听
    @IBAction func okBtnDidClicked(_ sender: UIButton) {
        removeFromSuperview()
    }
}
