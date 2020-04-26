/**
 * 联系我们视图
 */

import UIKit

class THJGContactUsView: UIView {

    static func showContactUsView() -> THJGContactUsView {
        return Bundle.main.loadNibNamed("THJGContactUsView", owner: self, options: nil)?.last as! THJGContactUsView
    }
    
}

extension THJGContactUsView {
    //取消事件监听
    @IBAction func cancleBtnDidClicked(_ sender: UIButton) {
        removeFromSuperview()
    }
    
    //拨打电话
    @IBAction func callBtnDidClicked(_ sender: UIButton) {
        removeFromSuperview()
        DQSUtils_OC.telePhoneCall("400-850-3099")
    }
}
