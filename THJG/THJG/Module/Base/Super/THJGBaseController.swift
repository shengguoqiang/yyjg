/**
 * 视图控制器基类
 */

import UIKit

/* 失败回调 */
let THJG_NOTIFICATION_NETWORK_FAILURE = "THJG_NOTIFICATION_NETWORK_FAILURE"

class THJGBaseController: UIViewController {

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        //setup
        basicSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //注册失败通知
        NotificationCenter.default.addObserver(self, selector: #selector(requestFailure(_:)), name: Notification.Name(THJG_NOTIFICATION_NETWORK_FAILURE), object: nil)
        //注册账号异常通知
        NotificationCenter.default.addObserver(self, selector: #selector(requestAccountNeedRefresh), name: NSNotification.Name(NOTIFICATION_ACCOUNT_NEED_REFRESH), object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //注销通知
        NotificationCenter.default.removeObserver(self)
    }
    
    deinit {
        DQSUtils.log("\(self) was already deallocated!")
    }

}

//MARK: - METHODS
extension THJGBaseController {
    
    //setup
    func basicSetup() {
        view.backgroundColor = UIColor.white
    }
    
    //popBack
    @objc func popBack() {
        navigationController?.popViewController(animated: true)
    }
    
    //网络请求回调
    @objc func requestSuccess(_ notification: Notification) {
        //隐藏loading
        DQSUtils.hideLoading(view)
        //具体逻辑子类自行实现
    }
    
    @objc func requestFailure(_ notification: Notification) {
        let speBean = notification.object as! THJGFailureBean
        DQSUtils.showToast(speBean.msg, view)
    }
    
    @objc func requestAccountNeedRefresh() {
        //清空本地用户数据
        DQSUtils.logout()
        
        //页面跳转
        (UIApplication.shared.delegate as! THJGAppDelegate).window?.rootViewController = THJGNavigationController(rootViewController: THJGLoginController())
    }
}
