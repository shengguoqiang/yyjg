/**
 * 忘记密码
 */

import UIKit

class THJGForgetPwdController: THJGBaseController {
    
    //MARK: - Properties
    @IBOutlet weak var phoneTF: DQSTextField!
    @IBOutlet weak var authCodeTF: DQSTextField!
    @IBOutlet weak var passwordTF: DQSTextField!
    @IBOutlet weak var rePwdTF: DQSTextField!
    @IBOutlet weak var timerButton: TZBTimeButton!
    
    lazy var forgetPwdVM = THJGForgetPwdViewModel()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        //setup
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //注册网络请求通知
        NotificationCenter.default.addObserver(self, selector: #selector(requestSuccess(_:)), name: Notification.Name(THJG_NOTIFICATION_FORGETPWD_SUCCESS), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(requestAuthCodeSuccess(_:)), name: Notification.Name(THJG_NOTIFICATION_AUTHCODE_SUCCESS), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(requestAuthCodeFailure(_:)), name: Notification.Name(THJG_NOTIFICATION_AUTHCODE_FAILURE), object: nil)
    }

}

//MARK: - UITextFieldDelegate
extension THJGForgetPwdController: UITextFieldDelegate {
    
    //limit the length of text of the phoneTF
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard textField == phoneTF else {
            return true
        }
        return range.location < 11
    }
}

//MARK: - METHODS
extension THJGForgetPwdController {
    
    //setup
    fileprivate func setup() {
        //setup the nav title
        navigationItem.title = "找回登录密码"
    }
    
    //MARK: - 获取验证码事件监听
    @IBAction func authCodeBtnDidClicked(_ sender: TZBTimeButton) {
        //结束页面编辑
        view.endEditing(true)
        
        //verify wheather the phone is empty
        if DQSUtils.isBlank(phoneTF.text) {
            DQSUtils.showToast("请输入登录手机号", view)
            return
        }
        
        //verify the validity of the phone
        if !DQSUtils.isValidMobile(phoneTF.text) {
            DQSUtils.showToast("请输入正确手机号", view)
            return
        }
        
        //send request for authCode
        DQSUtils.showLoading(view)
        timerButton.start() //start the timer
        forgetPwdVM.requestForAuthCode(param: ["mobile": phoneTF.text!, "type": 1])
    }
    
    @objc func requestAuthCodeSuccess(_ notification: Notification) {
        let specBean = notification.object as! THJGSuccessBean
        DQSUtils.showToast(specBean.msg ?? "发送成功", view)
    }
    
    @objc func requestAuthCodeFailure(_ notification: Notification) {
        //提示
        let specBean = notification.object as! THJGFailureBean
        DQSUtils.showToast(specBean.msg, view)
        //关闭倒计时
        timerButton.over()
    }
    
    //MARK: - 重置密码事件监听
    @IBAction func resetPwdBtnDidClicked() {
        //结束页面编辑
        view.endEditing(true)
        
        //verify wheather the phone is empty
        if DQSUtils.isBlank(phoneTF.text) {
            DQSUtils.showToast("请输入登录手机号", view)
            return
        }
        
        //verify the validity of the phone
        if !DQSUtils.isValidMobile(phoneTF.text) {
            DQSUtils.showToast("请输入正确手机号", view)
            return
        }
        
        //verify wheather the authCode is empty
        if DQSUtils.isBlank(authCodeTF.text) {
            DQSUtils.showToast("请输入验证码", view)
            return
        }
        
        //verify wheather the password is empty
        if DQSUtils.isBlank(passwordTF.text) {
            DQSUtils.showToast("请输入密码", view)
            return
        }
        
        //verify the validity of password
        if !DQSUtils.isValidPassword(passwordTF.text) {
            DQSUtils.showToast("密码格式为6~18位字母数字或组合", view)
            return
        }
        
        //comfirm the new password
        if DQSUtils.isBlank(rePwdTF.text) {
            DQSUtils.showToast("请再次输入新密码", view)
            return
        }
        if passwordTF.text! != rePwdTF.text! {
            DQSUtils.showToast("两次密码设置不一致", view)
            return
        }
        
        //send the request for resetting password
        forgetPwdVM.requestForResettingPwd(param: ["mobile": phoneTF.text!, "authCode": authCodeTF.text!, "password": passwordTF.text!, "rePassword": rePwdTF.text!])
        
    }
    
    @objc override func requestSuccess(_ notification: Notification) {
        let specBean = notification.object as! THJGSuccessBean
        DQSUtils.showToast(specBean.msg ?? "重置密码成功", view, completion: {[unowned self] in
            self.navigationController?.popViewController(animated: true)
        })
    }
}
