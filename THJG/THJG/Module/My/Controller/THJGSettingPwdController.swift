/**
 * 密码设置
 */

import UIKit

fileprivate let kPwdSettingCellIdentifier = "pwdSettingCellIdentifier"

/* 通知常量 */
let THJG_NOTIFICATION_TOUCHID_SETTING_NOTAVAILABLE = "THJG_NOTIFICATION_TOUCHID_SETTING_NOTAVAILABLE"

class THJGSettingPwdController: THJGBaseController {
    
    //MARK: - UI Elements
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties
    lazy var beans = [[String]]()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setup
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //处理数据
        handleData()
        
        //注册Touch ID
        NotificationCenter.default.addObserver(self, selector: #selector(requestTouchIDValidateSuccess), name: NSNotification.Name(THJG_NOTIFICATION_TOUCHID_VALIDATE_SUCCESS), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(requestTouchIDValidateFailure), name: NSNotification.Name(THJG_NOTIFICATION_TOUCHID_VALIDATE_FAILURE), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(requestTouchIDNotAvailable), name: NSNotification.Name(THJG_NOTIFICATION_TOUCHID_SETTING_NOTAVAILABLE), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //注销通知
        NotificationCenter.default.removeObserver(self)
    }

}

//MARK: - METHODS
extension THJGSettingPwdController {
    
    //setup
    fileprivate func setup() {
        //设置导航栏标题
        navigationItem.title = "密码设置"
        
        //注册cell
        tableView.register(UINib(nibName: "THJGPwdSettingCell", bundle: nil), forCellReuseIdentifier: kPwdSettingCellIdentifier)
    }
    
    //处理数据
    fileprivate func handleData() {
        //清空之前的数据
        beans.removeAll()
        beans.append(["登录密码"])
        if DQSUtils.readGuesture() != nil {
            beans.append(["手势密码解锁", "修改手势密码"])
        } else {
            beans.append(["手势密码解锁"])
        }
        if DQSUtils.isSupportTouchID() {
            beans.append(["Touch ID指纹解锁"])
        }
        tableView.reloadData()
    }
    
    @objc func requestTouchIDValidateSuccess() {
        DQSUtils.setTouchID(true)
        DQSUtils.showToast("Touch ID指纹解锁已开启", self.view)
    }
    
    @objc func requestTouchIDValidateFailure() {
        tableView.reloadSections([2], with: .none)
    }
    
    @objc func requestTouchIDNotAvailable() {
        let alertVC = UIAlertController(title: "你尚未设置TouchID,请在手机系统\"设置>Touch ID与密码\"中添加指纹", message: nil, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "知道了", style: .cancel, handler: {[unowned self] (action) in
            self.tableView.reloadSections([2], with: .none)
        }))
        present(alertVC, animated: true, completion: nil)
        
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension THJGSettingPwdController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return beans.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beans[section].count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kPwdSettingCellIdentifier) as! THJGPwdSettingCell
        cell.reloadData(beans[indexPath.section][indexPath.row]) {[unowned self] (title, status) in
            switch title {
            case "手势密码解锁":
                if status {
                    let setPwdVC = THJGSettingGuesurePwdController()
                    self.navigationController?.pushViewController(setPwdVC, animated: true)
                } else {
                    DQSUtils.saveGuesture("")
                    DQSUtils.showToast("手势密码已关闭", self.view)
                    self.beans[1] = ["手势密码解锁"]
                    tableView.reloadSections([1], with: .none)
                }
            case "Touch ID指纹解锁":
                if status {
                    DQSUtils.showTouchID("通过验证指纹解锁云眼监管")
                } else {
                    DQSUtils.setTouchID(false)
                    DQSUtils.showToast("Touch ID指纹解锁已关闭", self.view)
                }
            default:
                break
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bean = beans[indexPath.section][indexPath.row]
        switch bean {
        case "登录密码":
            let modifyLoginPwdVC = THJGModifyLoginPwdController()
            navigationController?.pushViewController(modifyLoginPwdVC, animated: true)
        case "修改手势密码":
            let modifyGuestureVC = THJGModifyGuesturePwdController()
            navigationController?.pushViewController(modifyGuestureVC, animated: true)
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
