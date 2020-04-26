/**
 * 带【完成】退出功能的输入框
 */

import UIKit
import SnapKit

class DQSTextField: UITextField {
    
    private lazy var accessoryView: UIView = {
        let aView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: SCREEN_WIDTH, height: 44.0))
        aView.backgroundColor = UIColor.white
        return aView
    }()
    
    private lazy var doneBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("完成", for: .normal)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.addTarget(self, action: #selector(DQSTextField.done), for: .touchUpInside)
        return btn
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        
        //add the finish button
        accessoryView.addSubview(doneBtn)
        
        //constraint the button
        doneBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 60, height: 40))
            make.centerY.equalTo(accessoryView)
            make.trailing.equalTo(accessoryView)
        }
        
        //setup the accessoryView
        inputAccessoryView = accessoryView
        
    }
    
    @objc func done() {
        if isFirstResponder {
            resignFirstResponder()
        }
    }

}
