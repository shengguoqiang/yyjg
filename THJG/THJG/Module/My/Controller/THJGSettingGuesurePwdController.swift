/**
 * 设置手势密码
 */

import UIKit

class THJGSettingGuesurePwdController: THJGBaseController {
    
    //MARK: - UI Elements
    @IBOutlet weak var tipView: DQSGuestureTipView!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var guestureView: DQSGuestureView!
    @IBOutlet weak var guestureViewY: NSLayoutConstraint!
    @IBOutlet weak var reDrawBtn: UIButton!
    
    @IBOutlet weak var skipBtn: UIButton!
    //MARK: - Properties
    var tempPwd: String!
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

       //setup
       setup()
    }

}

//MARK: - METHODS
extension THJGSettingGuesurePwdController {
    
    //setup
    func setup() {
        //屏蔽全屏返回手势
        fd_interactivePopDisabled = true
        
        //设置导航栏标题
        navigationItem.title = "设置手势密码"
        
        //设置手势密码视图代理
        guestureView.gDelegate = self
        
        //处理跳过逻辑
        if ((UIApplication.shared.delegate as! THJGAppDelegate).window?.rootViewController) is THJGTabBarController {//【设置】页进入
            skipBtn.isHidden = true
        } else {//【登录】页进入
            skipBtn.isHidden = false
        }
        
        //适配5s
        if DEVICE_5S {
            guestureViewY.constant = 160
        }
    }
    
    //重新绘制图案
    @IBAction func reDrawBtnDidClicked(_ sender: UIButton) {
        tipView.reset()
        tipLabel.text = "请绘制手势密码图案"
        guestureView.gType = .set
        guestureView.guestureButtonType = .normal
        //重新绘制图案
        reDrawBtn.isHidden = true
    }
    
    //跳过
    @IBAction func skipBtnDidClicked(_ sender: UIButton) {
        //切换root
        (UIApplication.shared.delegate as! THJGAppDelegate).window?.rootViewController = THJGTabBarController()
    }
    
}

extension THJGSettingGuesurePwdController: DQSGuestureViewDelegate {
    
    func drawFinished(_ type: DQSGuestureViewType, _ pwd: String) {
        switch type {
        case .set:
            guard pwd.count >= 4 else {
                tipLabel.text = "请至少连接4个点"
                DQSUtils_OC.shakerView(tipLabel)
                guestureView.guestureButtonType = .error
                guestureView.setNeedsDisplay()
                return
            }
            tempPwd = pwd
            tipView.refresh(pwd)
            tipLabel.text = "请再次绘制解锁图案"
            guestureView.gType = .confirm
            guestureView.guestureButtonType = .normal
        case .confirm:
            guard pwd == tempPwd else {
                tipLabel.text = "两次图案不同，请重新绘制"
                DQSUtils_OC.shakerView(tipLabel)
                guestureView.guestureButtonType = .error
                return
            }
            DQSUtils.showToast("手势密码设置成功", view) {
                [unowned self] in
                //存储手势密码
                DQSUtils.saveGuesture(pwd)
                //页面跳转
                if ((UIApplication.shared.delegate as! THJGAppDelegate).window?.rootViewController) is THJGTabBarController {//【设置】页进入
                    self.navigationController?.popViewController(animated: true)
                } else {//【登录】页进入
                    (UIApplication.shared.delegate as! THJGAppDelegate).window?.rootViewController = THJGTabBarController()
                }
            }
        default:
            break
        }
        //重新绘制图案
        reDrawBtn.isHidden = false
        //隐藏跳过
        skipBtn.isHidden = true
    }
    
}
