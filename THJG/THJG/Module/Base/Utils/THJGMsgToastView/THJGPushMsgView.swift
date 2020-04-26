/**
 * 推送弹框
 */

import UIKit

class THJGPushMsgView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    var block: (()->Void)?
    
    var bean: [AnyHashable: Any]! {
        didSet {
            titleLabel.text = (bean["title"] as? String) ?? ""
            textView.text = (bean["content"] as? String) ?? ""
        }
    }
    
    static func showPushView() -> THJGPushMsgView {
        return Bundle.main.loadNibNamed("THJGPushMsgView", owner: self, options: nil)?.last as! THJGPushMsgView
    }
    
}

extension THJGPushMsgView {
    //取消事件监听
    @IBAction func ignoreBtnDidClicked(_ sender: UIButton) {
        removeFromSuperview()
    }
    
    //查看事件监听
    @IBAction func checkBtnDidClicked(_ sender: UIButton) {
        removeFromSuperview()
        block?()
    }
}
