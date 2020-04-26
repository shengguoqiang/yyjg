/**
 *  我的
 */

import UIKit
import MJRefresh

//cell 标识
fileprivate let kMyCenterCellIdentifier = "myCenterCellIdentifier"

class THJGMyController: THJGBaseController {
    
    //MARK: - UI Elements
    @IBOutlet var tableHeaderView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var tableFooterView: UIView!
    
    let user = THJGStorageManager.readUser()!
    
    //MARK: - Properties
    var myVM = THJGMyViewModel()
    var beans: [MyHandledBean]! {
        didSet {
            tableView.reloadData()
        }
    }

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        //setup
        setup()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //注册网络请求回调通知
        NotificationCenter.default.addObserver(self, selector: #selector(requestSuccess(_:)), name: Notification.Name(THJG_NOTIFICATION_MYCENTER_SUCCESS), object: nil)
        
        //请求数据
        if !tableView.mj_header.isRefreshing {
            requestForData()
        }
    }
    
}

//MARK: - METHODS
extension THJGMyController {
    //setup
    fileprivate func setup() {
        //隐藏导航栏
        fd_prefersNavigationBarHidden = true
        
        //取消滚动视图自适配
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        //注册cell
        tableView.register(UINib(nibName: "THJGMyCenterCell", bundle: nil), forCellReuseIdentifier: kMyCenterCellIdentifier)
        
        //设置滚动视图顶部和底部视图
        tableHeaderView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_WIDTH*(230/375))
        nameLabel.text = user.userName
        phoneLabel.text = DQSUtils.showPhoneNum(user.userMobile)
        tableView.tableHeaderView = tableHeaderView
        
        tableFooterView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_WIDTH*(200/375))
        tableView.tableFooterView = tableFooterView
        
        //添加下拉刷新
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {[unowned self] in
            self.requestForData()
        })
        tableView.mj_header.beginRefreshing()
    }
    
    //send request for data
    fileprivate func requestForData() {
        DQSUtils.showLoading(view)
        myVM.requestForMyCenterData(param: ["mobile": user.userMobile])
    }
    
    @objc override func requestSuccess(_ notification: Notification) {
        super.requestSuccess(notification)
        //结束刷新
        tableView.mj_header.endRefreshing()
        //获取数据
        let specBean = notification.object as! THJGSuccessBean
        beans = myVM.handleMyData(specBean.bean as! THJGMyCenterBean)
    }
    
    override func requestFailure(_ notification: Notification) {
        super.requestFailure(notification)
        //结束刷新
        tableView.mj_header.endRefreshing()
    }
    
    //MARK: - 修改手机号
    @IBAction func modiyPhoneDidClicked(_ sender: UIButton) {
        let modifyPhoneVC = THJGModifyPhoneController()
        navigationController?.pushViewController(modifyPhoneVC, animated: true)
    }
    
    //MARK: - 联系我们
    @IBAction func contractUsDidClicked(_ sender: UIButton) {
        let contactUsView = THJGContactUsView.showContactUsView()
        contactUsView.frame = UIScreen.main.bounds
        view.window?.addSubview(contactUsView)
    }
    
    //MARK: - 退出登录
    @IBAction func logoutDidClicked(_ sender: UIButton) {
        //清空本地用户数据
        DQSUtils.logout()
        
        //页面跳转
        (UIApplication.shared.delegate as! THJGAppDelegate).window?.rootViewController = THJGNavigationController(rootViewController: THJGLoginController())
    }
    
}

extension THJGMyController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard beans != nil else {
            return 0
        }
        return beans.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kMyCenterCellIdentifier) as! THJGMyCenterCell
        cell.bean = beans[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bean = beans[indexPath.row]
        switch bean.titile {
        case "我的消息":
            let innerMsgVC = THJGInnerMsgController()
            navigationController?.pushViewController(innerMsgVC, animated: true)
        case "密码设置":
            let pwdSettingVC = THJGSettingPwdController()
            navigationController?.pushViewController(pwdSettingVC, animated: true)
        case "隐私政策":
            let url = "https://www.yunshows.com/privacy.html"
            let webVC = THJGWebController()
            webVC.request = URLRequest(url: URL(string: url)!)
            navigationController?.pushViewController(webVC, animated: true)
        case "当前版本号":
            if bean.trailIcon != nil {
                DQSUtils.switchAppStore()
            }
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
