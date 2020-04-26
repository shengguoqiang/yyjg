/**
 * 询问是否需要开启指纹密码
 */

import UIKit

class THJGTouchIDToastView: UIView {
    
    var block: (()->Void)?

    static func showTouchIDToastView() -> THJGTouchIDToastView {
        return Bundle.main.loadNibNamed("THJGTouchIDToastView", owner: self, options: nil)?.last as! THJGTouchIDToastView
    }
    
}

extension THJGTouchIDToastView {
    //取消事件监听
    @IBAction func cancelBtnDidClicked(_ sender: UIButton) {
        removeFromSuperview()
    }
    
    //去设置事件监听
    @IBAction func goSetBtnDidClicked(_ sender: UIButton) {
        removeFromSuperview()
        block?()
    }
}
