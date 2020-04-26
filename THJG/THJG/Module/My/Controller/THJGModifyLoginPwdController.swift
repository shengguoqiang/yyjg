/**
 * 修改登录密码
 */

import UIKit

class THJGModifyLoginPwdController: THJGBaseController {
    
    //MARK: - UI Elements
    
    @IBOutlet weak var oldPwdTF: DQSTextField!
    @IBOutlet weak var curPwdTF: DQSTextField!
    @IBOutlet weak var rePwdTF: DQSTextField!
    
    //MARK: - Properties
    lazy var modifyLoginPwdVM = THJGModifyLoginPwdViewModel()

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        //setup
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //注册网络请求回调通知
        NotificationCenter.default.addObserver(self, selector: #selector(requestSuccess(_:)), name: Notification.Name(THJG_NOTIFICATION_MODIFY_LOGINPWD_SUCCESS), object: nil)
    }

}

//MARK: - METHODS
extension THJGModifyLoginPwdController {
    
    //setup
    fileprivate func setup() {
        //设置导航栏标题
        navigationItem.title = "修改登录密码"
    }
    
    //确认修改事件监听
    @IBAction func confirmModify(_ sender: UIButton) {
        //结束页面编辑
        view.endEditing(true)
        
        //校验输入框
        if DQSUtils.isBlank(oldPwdTF.text) {
            DQSUtils.showToast("请输入原登录密码", view)
            return
        }
        if DQSUtils.isBlank(curPwdTF.text) {
            DQSUtils.showToast("请设置新密码", view)
            return
        }
        
        //校验新密码格式
        if !DQSUtils.isValidPassword(curPwdTF.text) {
            DQSUtils.showToast("密码格式为6~18位字母数字或组合", view)
            return
        }
        
        //校验重复密码
        if DQSUtils.isBlank(rePwdTF.text) {
            DQSUtils.showToast("请再次输入新密码", view)
            return
        }

        if curPwdTF.text! != rePwdTF.text! {
            DQSUtils.showToast("两次密码设置不一致", view)
            return
        }
        
        //发送请求
        DQSUtils.showLoading(view)
        let userBean = THJGStorageManager.readUser()!
        modifyLoginPwdVM.requestForModifyLoginPwd(param: ["mobile": userBean.userMobile, "oldPassword": oldPwdTF.text!, "password": curPwdTF.text!, "rePassword": rePwdTF.text!])
        
    }
    
    @objc override func requestSuccess(_ notification: Notification) {
        let specBean = notification.object as! THJGSuccessBean
        DQSUtils.showToast(specBean.msg ?? "修改密码成功", view, completion: {
            //返回登录页面
            (UIApplication.shared.delegate as! THJGAppDelegate).window?.rootViewController = THJGNavigationController(rootViewController: THJGLoginController())
        })
    }
}
