/**
 * 密码设置cell
 */

import UIKit

typealias THJGPwdSettingCellClickBlock = (String, Bool) -> Void

class THJGPwdSettingCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var arrowView: UIImageView!
    @IBOutlet weak var pwdSwitch: UISwitch!
    
    var clickBlock: THJGPwdSettingCellClickBlock!
    
    var bean: String! {
        didSet {
            //调整UI
            switch bean {
            case "手势密码解锁", "Touch ID指纹解锁":
                arrowView.isHidden = true
            default:
                arrowView.isHidden = false
            }
            pwdSwitch.isHidden = !arrowView.isHidden
            
            //赋值
            if bean == "手势密码解锁" {
                pwdSwitch.isOn = DQSUtils.isNotBlank(DQSUtils.readGuesture())
            } else if bean == "Touch ID指纹解锁" {
                pwdSwitch.isOn = DQSUtils.touchIDIsSet()
            }
            titleLabel.text = bean
        }
    }
    
    func reloadData(_ bean: String,
                    clickBlock: @escaping THJGPwdSettingCellClickBlock) {
        self.bean = bean
        self.clickBlock = clickBlock
    }
    
}

extension THJGPwdSettingCell {
    //switch事件监听
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        switch bean {
        case "手势密码解锁":
            clickBlock("手势密码解锁", sender.isOn)
        case "Touch ID指纹解锁":
            clickBlock("Touch ID指纹解锁", sender.isOn)
        default:
            break
        }
    }
}
