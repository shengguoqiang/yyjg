/**
 * 修改手势密码校验
 */

import UIKit

class THJGValidateModifyGuestueController: THJGBaseController {
    
    //MARK: - UI Elements
    @IBOutlet weak var curPhoneLabel: UILabel!
    @IBOutlet weak var authCodeTF: DQSTextField!
    @IBOutlet weak var timerButton: TZBTimeButton!
    
    //MARK: - Properties
    lazy var validateVM = THJGValidateModifyGuestureViewModel()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        //setup
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //注册请求通知
        NotificationCenter.default.addObserver(self, selector: #selector(requestAuthCodeSuccess(_:)), name: Notification.Name(THJG_NOTIFICATION_AUTHCODE_SUCCESS), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(requestAuthCodeFailure(_:)), name: Notification.Name(THJG_NOTIFICATION_AUTHCODE_FAILURE), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(requestSuccess(_:)), name: Notification.Name(THJG_NOTIFICATION_VALIDATE_MODIFY_GUESTUREPWD_SUCCESS), object: nil)
    }

}

extension THJGValidateModifyGuestueController {
    
    //setup
    func setup() {
        //设置导航栏标题
        navigationItem.title = "修改手势密码"
        
        //设置原手机号
        let user = THJGStorageManager.readUser()!
        curPhoneLabel.text = DQSUtils.showPhoneNum(user.userMobile)
    }
    
    //验证码事件监听
    @IBAction func timerBtnDidClicked(_ sender: TZBTimeButton) {
        //send request for authCode
        DQSUtils.showLoading(view)
        timerButton.start() //start the timer
        let user = THJGStorageManager.readUser()!
        validateVM.requestForAuthCode(param: ["mobile": user.userMobile, "type": 2])
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
    
    
    //确认事件监听
    @IBAction func confirmBtnDidClicked(_ sender: UIButton) {
        //结束页面编辑
        view.endEditing(true)
        
        //校验验证码是否非空
        guard DQSUtils.isNotBlank(authCodeTF.text) else {
            DQSUtils.showToast("请输入短信验证码", view)
            return
        }
        validateVM.requestForModifyGuesturePwd(param: ["authCode": authCodeTF.text!])
    }
    
    @objc override func requestSuccess(_ notification: Notification) {
        super.requestSuccess(notification)
        let modifyVC = THJGModifyGuesturePwdController()
        navigationController?.pushViewController(modifyVC, animated: true)
    }
}
