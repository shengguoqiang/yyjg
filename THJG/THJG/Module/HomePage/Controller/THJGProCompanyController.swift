/**
 * 企业信息控制器
 */

import UIKit

class THJGProCompanyController: THJGBaseController {
    
    //MARK: - UI Elements
    @IBOutlet weak var tabView: UIView!
    @IBOutlet weak var baseBtn: UIButton!
    @IBOutlet weak var financeBtn: UIButton!
    @IBOutlet weak var riskBtn: UIButton!
    @IBOutlet weak var markView: UIView!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var baseInfoView: THJGProCompanyBaseInfoView!
    @IBOutlet weak var financeInfoView: THJGProCompanyFinanceInfoView!
    @IBOutlet weak var riskInfoView: THJGProCompanyRiskInfoView!
    
    //MARK: - Properties
    var param: (comId: String, comType: String, index: Int)!
    var companyVM = THJGProCompanyViewModel()
    var bean: THJGProCompanyBean! {
        didSet {
            //设置标题
            navigationItem.title = bean.baseInfo.companyName
            //设定当前tab
            curSelectedIndex = param.index
        }
    }
    //tab相关
    var curSelectedTab: UIButton!
    var curSelectedIndex: Int = 0 {
        didSet {
            switch curSelectedIndex {
            case 0://公司信息
                tabBtnDidClicked(baseBtn)
            case 1://财务信息
                tabBtnDidClicked(financeBtn)
            case 2://风险信息
                tabBtnDidClicked(riskBtn)
            default:
                break
            }
        }
    }

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        //初始化
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        /* 注册请求成功通知 */
        NotificationCenter.default.addObserver(self, selector: #selector(requestSuccess(_:)), name: NSNotification.Name(THJG_NOTIFICATION_PROCOMPANY_SUCCESS), object: nil)
    }

}

//MARK: - METHODS
extension THJGProCompanyController {
    
    //初始化
    func setup() {
        //屏蔽全屏返回手势
        fd_interactivePopDisabled = true
        
        //add guesture to the view
        let guesture_left = UISwipeGestureRecognizer(target: self, action: #selector(swapSubViews))
        guesture_left.direction = .left
        view.addGestureRecognizer(guesture_left)
        
        let guesture_right = UISwipeGestureRecognizer(target: self, action: #selector(swapSubViews))
        guesture_right.direction = .right
        view.addGestureRecognizer(guesture_right)
        
        //发送请求
        requestForData()
    }
    
    //MARK: - switch the tab
    @objc func swapSubViews(_ guestureRecognizer: UISwipeGestureRecognizer) {
        switch guestureRecognizer.direction {
        case .left:
            if curSelectedIndex != 2 {
                curSelectedIndex += 1
            } else {
                curSelectedIndex = 0
            }
        case .right:
            if curSelectedIndex != 0 {
                curSelectedIndex -= 1
            } else {
                curSelectedIndex = 2
            }
        default:
            break
        }
    }
    
    //请求数据
    func requestForData() {
        //校验参数
        if DQSUtils.isBlank(param.comId)
            || DQSUtils.isBlank(param.comType) {
            DispatchQueue.main.async {
                self.bean = THJGProCompanyBean(baseInfo: ProCompanyBaseInfoBean(companyName: "企业信息", legalName: "", registerAmount: "", actualAmount: "", authCode: "", companyDes: "", leaderInfo: [ProCompanyPdfBean]()), financeInfo: [ProCompanyPdfBean](), riskInfo: [ProCompanyPdfBean]())
            }
            return
        }
        
        //请求数据
        DQSUtils.showLoading(view)
        companyVM.requestForProCompanyData(param: ["companyId": param.comId, "companyType": param.comType])
    }
    
    override func requestSuccess(_ notification: Notification) {
        super.requestSuccess(notification)
        let specBean = notification.object as! THJGSuccessBean
        bean = (specBean.bean as! THJGProCompanyBean)
    }
    
    //MARK: - tab切换事件监听
    @IBAction func tabBtnDidClicked(_ sender: UIButton) {
        guard sender != curSelectedTab else {
            return
        }
        if curSelectedTab != nil {
            curSelectedTab.isSelected = false
        }
        sender.isSelected = true
        curSelectedTab = sender
        
        switch sender.tag {
        case 1000:
            containerView.bringSubviewToFront(baseInfoView)
            baseInfoView.reloadData(bean: bean) {[unowned self] (pdfUrl, _) in
                let request = URLRequest(url: URL(string: pdfUrl)!)
                let webVC = THJGWebController()
                webVC.request = request
                self.navigationController?.pushViewController(webVC, animated: true)
            }
            //调整底部红色浮标
            var center = markView.center
            center.x = baseBtn.center.x
            markView.center = center
        case 1001:
            containerView.bringSubviewToFront(financeInfoView)
            financeInfoView.reloadData(bean: bean) {[unowned self] (pdfUrl, _) in
                let request = URLRequest(url: URL(string: pdfUrl)!)
                let webVC = THJGWebController()
                webVC.request = request
                self.navigationController?.pushViewController(webVC, animated: true)
            }
            //调整底部红色浮标
            var center = markView.center
            center.x = financeBtn.center.x
            markView.center = center
        case 1002:
            containerView.bringSubviewToFront(riskInfoView)
            riskInfoView.reloadData(bean: bean) {[unowned self] (pdfUrl, _) in
                let request = URLRequest(url: URL(string: pdfUrl)!)
                let webVC = THJGWebController()
                webVC.request = request
                self.navigationController?.pushViewController(webVC, animated: true)
            }
            //调整底部红色浮标
            var center = markView.center
            center.x = riskBtn.center.x
            markView.center = center
        default:
            break
        }
        
    }
}
