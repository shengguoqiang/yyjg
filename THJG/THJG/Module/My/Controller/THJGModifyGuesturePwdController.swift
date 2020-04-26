/**
 * 修改手势密码
 */

import UIKit

class THJGModifyGuesturePwdController: THJGBaseController {
    
    //MARK: - UI Elements
    @IBOutlet weak var tipView: DQSGuestureTipView!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var guestureView: DQSGuestureView!
    @IBOutlet weak var guestureViewY: NSLayoutConstraint!
    @IBOutlet weak var reDrawBtn: UIButton!
    
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
extension THJGModifyGuesturePwdController {
   
    //setup
    func setup() {
        //屏蔽全屏返回手势
        fd_interactivePopDisabled = true
        //设置导航栏标题
        navigationItem.title = "修改手势密码"
        //设置代理
        guestureView.gDelegate = self
        //适配5s
        if DEVICE_5S {
            guestureViewY.constant = 160
        }
    }
    
    //重绘事件监听
    @IBAction func reDrawBtnDidClicked(_ sender: UIButton) {
        tipView.reset()
        tipLabel.text = "请绘制手势密码图案"
        guestureView.gType = .set
        guestureView.guestureButtonType = .normal
    }
}

extension THJGModifyGuesturePwdController: DQSGuestureViewDelegate {
    
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
            DQSUtils.showToast("手势密码修改成功", view) {
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
    }
    
}
