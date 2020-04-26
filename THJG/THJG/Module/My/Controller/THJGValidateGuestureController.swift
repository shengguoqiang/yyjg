/**
 * 手势密码校验
 */

import UIKit

/* 常量通知 */
let THJG_NOTIFICATION_TOUCHID_VALIDATE_SUCCESS = "THJG_NOTIFICATION_TOUCHID_VALIDATE_SUCCESS"
let THJG_NOTIFICATION_TOUCHID_VALIDATE_FAILURE = "THJG_NOTIFICATION_TOUCHID_VALIDATE_FAILURE"

class THJGValidateGuestureController: THJGBaseController {
    
    //MARK: - UI Elements
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var guestureView: DQSGuestureView!
    @IBOutlet weak var guestureViewY: NSLayoutConstraint!
    @IBOutlet weak var forgetPwdBtn: UIButton!
    @IBOutlet weak var forgetPwdBtnY: NSLayoutConstraint!
    @IBOutlet weak var switchAccountBtn: UIButton!
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        //setup
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //如果有指纹解锁，注册事件
        if DQSUtils.touchIDIsSet() {
            NotificationCenter.default.addObserver(self, selector: #selector(validateSuccess), name: NSNotification.Name(THJG_NOTIFICATION_TOUCHID_VALIDATE_SUCCESS), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(validateFailure), name: NSNotification.Name(THJG_NOTIFICATION_TOUCHID_VALIDATE_FAILURE), object: nil)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //如果有指纹解锁，注销
        if DQSUtils.touchIDIsSet() {
            NotificationCenter.default.removeObserver(self)
        }
    }
    
}

//MARK: - METHODS
extension THJGValidateGuestureController {
    
    //setup
    func setup() {
        //隐藏导航栏
        fd_prefersNavigationBarHidden = true
        
        //设置顶部信息
        let user = THJGStorageManager.readUser()!
        phoneLabel.text = DQSUtils.showPhoneNum(user.userMobile)
        nameLabel.text = "欢迎您，\(user.userName)"
        
        /* 手势密码 */
        if DQSUtils.readGuesture() != nil {
            //显示手势密码视图
            guestureView.isHidden = false
            //设置手势密码视图代理
            guestureView.gDelegate = self
        } else {
            //隐藏手势密码视图
            guestureView.isHidden = true
            //设置手势密码视图代理
            guestureView.gDelegate = nil
            //隐藏提示
            tipLabel.isHidden = true
            //隐藏忘记手势密码
            forgetPwdBtn.isHidden = true
            //隐藏切换账户
            switchAccountBtn.isHidden = true
        }
        
        //适配5s
        if DEVICE_5S {
            guestureViewY.constant = 170
            forgetPwdBtnY.constant = 25
        }
        
        /* TouchID */
        if DQSUtils.touchIDIsSet() {
            DQSUtils.showTouchID("通过验证指纹解锁云眼监管")
        }
        
    }
    
    @objc func validateSuccess() {
        (UIApplication.shared.delegate as! THJGAppDelegate).window?.rootViewController = THJGTabBarController()
    }
    
    @objc func validateFailure() {
        guard DQSUtils.readGuesture() == nil else {//设置了手势密码
            return
        }
        (UIApplication.shared.delegate as! THJGAppDelegate).window?.rootViewController = THJGNavigationController(rootViewController: THJGLoginController())
    }
    
    //忘记密码事件监听
    @IBAction func forgetPwdDidClicked(_ sender: UIButton) {
        let validateVC = THJGValidateModifyGuestueController()
        navigationController?.pushViewController(validateVC, animated: true)
    }
    
    //切换账户事件监听
    @IBAction func switchAccountDidClicked(_ sender: UIButton) {
        (UIApplication.shared.delegate as! THJGAppDelegate).window?.rootViewController = THJGNavigationController(rootViewController: THJGLoginController())
    }
    
}

extension THJGValidateGuestureController: DQSGuestureViewDelegate {
    
    func drawFinished(_ type: DQSGuestureViewType, _ pwd: String) {
        if DQSUtils.readGuesture()! != pwd {//密码输入错误
            tipLabel.text = "密码错误，请重新输入"
            DQSUtils_OC.shakerView(tipLabel)
            guestureView.guestureButtonType = .error
        } else {//密码输入正确
            (UIApplication.shared.delegate as! THJGAppDelegate).window?.rootViewController = THJGTabBarController()
        }
    }
    
}
