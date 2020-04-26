/**
 * 修改绑定手机号
 */

import UIKit

class THJGModifyPhoneController: THJGBaseController {
    
    //MARK: - UI Elements
    @IBOutlet weak var oldPhoneLabel: UILabel!
    @IBOutlet weak var phoneTF: DQSTextField!
    @IBOutlet weak var authCodeTF: DQSTextField!
    @IBOutlet weak var timerButton: TZBTimeButton!
    
    //MARK: - Properties
    lazy var modifyPhoneVM = THJGModifyPhoneViewModel()

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        //setup
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //注册网络请求回调通知
        NotificationCenter.default.addObserver(self, selector: #selector(requestModifyPhoneSuccess(_:)), name: Notification.Name(THJG_NOTIFICATION_MY_MODIFYPHONE_SUCCESS), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(requestAuthCodeSuccess(_:)), name: Notification.Name(THJG_NOTIFICATION_AUTHCODE_SUCCESS), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(requestAuthCodeFailure(_:)), name: Notification.Name(THJG_NOTIFICATION_AUTHCODE_FAILURE), object: nil)
    }

}

//MARK: - METHODS
extension THJGModifyPhoneController {
    
    //setup
    func setup() {
        //设置导航栏标题
        navigationItem.title = "修改绑定手机号"
        
        //设置原手机号
        let user = THJGStorageManager.readUser()!
        oldPhoneLabel.text = DQSUtils.showPhoneNum(user.userMobile)
    }
    
    //MARK: - 获取验证码事件监听
    @IBAction func authCodeBtnDidClicked(_ sender: TZBTimeButton) {
        //结束页面编辑
        view.endEditing(true)
        
        //verify wheather the phone is empty
        if DQSUtils.isBlank(phoneTF.text) {
            DQSUtils.showToast("请输入新手机号", view)
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
        modifyPhoneVM.requestForAuthCode(param: ["mobile": phoneTF.text!, "type": 3])
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
    
    //MARK: - 确认换绑事件监听
    @IBAction func confirmModifyPhone(_ sender: UIButton) {
        //结束页面编辑
        view.endEditing(true)
        
        //verify wheather the parameter is empty
        guard DQSUtils.isNotBlank(phoneTF.text) else {
            DQSUtils.showToast("请输入新手机号", view)
            return
        }
        
        //verify wheather the phone number is valid
        guard DQSUtils.isValidMobile(phoneTF.text) else {
            DQSUtils.showToast("请输入正确手机号", view)
            return
        }
        
        //verify wheather the parameter is empty
        guard DQSUtils.isNotBlank(authCodeTF.text) else {
            DQSUtils.showToast("请输入短信验证码", view)
            return
        }
        
        //send request for modifing Phone
        DQSUtils.showLoading(view)
        modifyPhoneVM.requestForModifyPhone(param: ["mobile": phoneTF.text!, "authCode": authCodeTF.text!])
    }
    
    @objc func requestModifyPhoneSuccess(_ notification: Notification) {
        let specBean = notification.object as! THJGSuccessBean
        DQSUtils.showToast(specBean.msg ?? "修改手机号成功", view, completion: {
            //清空本地用户数据
            DQSUtils.logout()
            
            //跳转登录页面
            (UIApplication.shared.delegate as! THJGAppDelegate).window?.rootViewController = THJGNavigationController(rootViewController: THJGLoginController())
        })
    }
}

//MARK: - UITextFieldDelegate
extension THJGModifyPhoneController: UITextFieldDelegate {
    
    //limit the length of text of the phoneTF
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard textField == phoneTF else {
            return true
        }
        return range.location < 11
    }
}
