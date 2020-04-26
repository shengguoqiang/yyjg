/**
 * 登录
 */

import UIKit

class THJGLoginController: THJGBaseController {
    
    //MARK: - Properties
    @IBOutlet weak var phoneTF: DQSTextField!
    @IBOutlet weak var pwdTF: DQSTextField!
    
    lazy var loginVM = THJGLoginViewModel()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
     
        //setup
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //注册网络请求通知
        NotificationCenter.default.addObserver(self, selector: #selector(requestSuccess(_:)), name: Notification.Name(THJG_NOTIFICATION_LOGIN_SUCCESS), object: nil)
        //清空密码输入框（找回密码返回）
        pwdTF.text = nil
    }
    
}

//MARK: - UITextFieldDelegate
extension THJGLoginController: UITextFieldDelegate {
    
    //limit the length of text of the phoneTF
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard textField == phoneTF else {
            return true
        }
        return range.location < 11
    }
}

//MARK: - METHODS
extension THJGLoginController {
    
    //setup
    func setup() {
        //隐藏导航栏
        fd_prefersNavigationBarHidden = true
        
        //带入手机号
        let user = THJGStorageManager.readUser()
        if user != nil {
            phoneTF.text = user!.userMobile
        }
    }
    
    //密码安全输入事件监听
    @IBAction func passwordSecurityDidClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        pwdTF.isSecureTextEntry = !pwdTF.isSecureTextEntry
    }
    
    //登录事件监听
    @IBAction func loginBthDidClicked() {
        //结束页面编辑
        view.endEditing(true)
        
        //verify wheather the parameter is empty
        guard DQSUtils.isNotBlank(phoneTF.text) else {
            DQSUtils.showToast("请输入手机号", view)
            return
        }
        guard DQSUtils.isNotBlank(pwdTF.text) else {
            DQSUtils.showToast("请输入密码", view)
            return
        }
        
        //verify wheather the phone number is valid
        guard DQSUtils.isValidMobile(phoneTF.text) else {
            DQSUtils.showToast("请输入正确手机号", view)
            return
        }
        
        DQSUtils.showLoading(view)
        loginVM.requestForUserData(param: ["username": phoneTF.text!, "password": pwdTF.text!])
    }
    
    @objc override func requestSuccess(_ notification: Notification) {
        super.requestSuccess(notification)
        let specBean = notification.object as! THJGSuccessBean
        let userBean = specBean.bean as! THJGUserBean
        //保存用户信息和密码
        THJGStorageManager.writeUser(userBean)
        DQSUtils.savePwd(self.pwdTF.text!)
        
        /* 推送相关 */
        //设置标签
        JPUSHService.setTags([ENVIRONMENT], completion: nil, seq: 0)
        //设置别名
        JPUSHService.setAlias(userBean.userMobile, completion: nil, seq: 0)
        
        //判断是否设置过手势密码
        if DQSUtils.readGuesture() != nil {
            //切换root
            (UIApplication.shared.delegate as! THJGAppDelegate).window?.rootViewController = THJGTabBarController()
        } else {
            //去设置手势密码
            let setPwdVC = THJGSettingGuesurePwdController()
            navigationController?.pushViewController(setPwdVC, animated: true)
        }
    }
    
    //MARK: - 忘记密码事件监听
    @IBAction func forgetPwdBtnDidClicked() {
        let forgetPwdVC = THJGForgetPwdController()
        navigationController?.pushViewController(forgetPwdVC, animated: true)
    }
    
    //MARK: - 联系我们事件监听
    @IBAction func contractUsDidClicked(_ sender: UIButton) {
        let contactUsView = THJGContactUsView.showContactUsView()
        contactUsView.frame = view.bounds
        view.addSubview(contactUsView)
    }
    
    
}
