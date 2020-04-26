/**
 * 项目资金信息
 */

import UIKit
import MJRefresh

class THJGProjectFundInfoController: THJGBaseController {
    
    //MARK: - UI Elements
    @IBOutlet weak var projectNameLabel: UILabel!
    
    @IBOutlet weak var accountBtn: UIButton!
    @IBOutlet weak var fundCheckBtn: UIButton!
    @IBOutlet weak var contractBtn: UIButton!
    @IBOutlet weak var markView: UIView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet var accountContentView: THJGFundInfoAccountView!
    @IBOutlet var fundCheckContentView: THJGFundInfoCheckView!
    @IBOutlet weak var typeBtn: UIButton!
    @IBOutlet weak var startDateBtn: UIButton!
    @IBOutlet weak var endDateBtn: UIButton!
    @IBOutlet var contractContentView: THJGFundInfoContractView!
    @IBOutlet weak var contractNameTF: DQSTextField!
    @IBOutlet weak var contractNameSearchIcon: UIImageView!
    @IBOutlet weak var contractNamePlaceholder: UILabel!
    //MARK: - Properties
    //项目ID
    var projectId: String!
    //VM
    lazy var fundVM = THJGProjectFundInfoViewModel()
    //查询条件
    var smallTypeId: String = "" {
        didSet {
            if DQSUtils.isBlank(smallTypeId) {
                typeBtn.setTitle("请选择费用类型", for: .normal)
            }
        }
    }
    var smallTypes: [SmallTypeBean]!
    var startDate: String = "" {
        didSet {
            startDateBtn.setTitle(startDate, for: .normal)
        }
    }
    var endDate: String = "" {
        didSet {
            endDateBtn.setTitle(endDate, for: .normal)
        }
    }
    var contractName: String = "" {
        didSet {
            contractNameTF.text = contractName
        }
    }
    //tab相关
    var curSelectedTab: UIButton! {
        didSet {
            curSelectedTab.isSelected = true
        }
    }
    var curSelectedIndex: Int = 0 {
        didSet {
            switch curSelectedIndex {
            case 0://账户信息
                var center = markView.center
                center.x = accountBtn.center.x
                markView.center = center
                tabBtnDidClicked(accountBtn)
            case 1://用款登记
                var center = markView.center
                center.x = fundCheckBtn.center.x
                markView.center = center
                tabBtnDidClicked(fundCheckBtn)
            case 2://合同台账
                var center = markView.center
                center.x = contractBtn.center.x
                markView.center = center
                tabBtnDidClicked(contractBtn)
            default:
                break
            }
        }
    }
    //分页相关
    var fundCheck_curPage: Int = 1
    var contract_curPage: Int = 1

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        //setup
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //注册网络请求回调通知
        //账户信息
        NotificationCenter.default.addObserver(self, selector: #selector(requestSuccess(_:)), name: Notification.Name(THJG_NOTIFICATION_FUND_ACCOUNT_SUCCESS
        ), object: nil)
        
        //用款登记
        NotificationCenter.default.addObserver(self, selector: #selector(requestFundCheckNewDataSuccess(_:)), name: Notification.Name(THJG_NOTIFICATION_FUND_CHECK_NEWDATA_SUCCESS), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(requestFundCheckNewDataFailure(_:)), name: Notification.Name(THJG_NOTIFICATION_FUND_CHECK_NEWDATA_FAILURE), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(requestFundCheckMoreDataSuccess(_:)), name: Notification.Name(THJG_NOTIFICATION_FUND_CHECK_MOREDATA_SUCCESS), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(requestFundCheckMoreDataFailure(_:)), name: Notification.Name(THJG_NOTIFICATION_FUND_CHECK_MOREDATA_FAILURE), object: nil)
        
        //合同台账
        NotificationCenter.default.addObserver(self, selector: #selector(requestFundContractNewDataSuccess(_:)), name: Notification.Name(THJG_NOTIFICATION_FUND_CONTRACT_NEWDATA_SUCCESS), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(requestFundContractNewDataFailure(_:)), name: Notification.Name(THJG_NOTIFICATION_FUND_CONTRACT_NEWDATA_FAILURE), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(requestFundContractMoreDataSuccess(_:)), name: Notification.Name(THJG_NOTIFICATION_FUND_CONTRACT_MOREDATA_SUCCESS), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(requestFundContractMoreDataFailure(_:)), name: Notification.Name(THJG_NOTIFICATION_FUND_CONTRACT_MOREDATA_FAILURE), object: nil)
        //查看合同
        NotificationCenter.default.addObserver(self, selector: #selector(checkContract(_:)), name: NSNotification.Name(NOTIFICATION_PROJECT_CHECK_CONTRACT), object: nil)
        //查看付款详情
        NotificationCenter.default.addObserver(self, selector: #selector(checkContractPayDetail(_:)), name: NSNotification.Name(NOTIFICATION_PROJECT_CHECK_CONTRACT_PAYDETAIL), object: nil)
        
    }
    
    
    @IBAction func contractTFDidChanged(_ sender: DQSTextField) {
        contractNameSearchIcon.isHidden = DQSUtils.isNotBlank(sender.text)
        contractNamePlaceholder.isHidden = contractNameSearchIcon.isHidden
    }
    
}

//MARK: - METHODS
extension THJGProjectFundInfoController {
    
    //setup
    func setup() {
        //设置导航栏标题
        navigationItem.title = "监管资金"
        
        //屏蔽全屏返回手势
        fd_interactivePopDisabled = true
        
        //add guesture to the view
        let guesture_left = UISwipeGestureRecognizer(target: self, action: #selector(swapSubViews))
        guesture_left.direction = .left
        view.addGestureRecognizer(guesture_left)
        
        let guesture_right = UISwipeGestureRecognizer(target: self, action: #selector(swapSubViews))
        guesture_right.direction = .right
        view.addGestureRecognizer(guesture_right)

        //默认选中【账户信息】
        curSelectedIndex = 0
        
        //设置代理
        fundCheckContentView.infoDelegate = self
        
        /* 设置分页加载 */
        //用款登记
        fundCheckContentView.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {[unowned self] in
            self.requestForFundCheckData()
        })
        //合同台账
        contractContentView.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {[unowned self] in
            self.requestForContractData()
        })
        
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
    
    //MARK: - send requests for data
    //请求账户信息
    fileprivate func requestForAccountData() {
        DQSUtils.showLoading(view)
        fundVM.requestForAccountData(param: ["projectId": projectId])
    }
    
    @objc override func requestSuccess(_ notification: Notification) {
        super.requestSuccess(notification)
        //获取数据
        let specBean = notification.object as! THJGSuccessBean
        let accountBean = (specBean.bean as! THJGProjectFundAccountBean)
        projectNameLabel.text = accountBean.projectName
        if accountBean.accounts.isEmpty {
            //添加占位图片
            DQSUtils.showPlaceholderImg(accountContentView)
        } else {
            //删除默认占位图片
            DQSUtils.hidePlaceholderImg(accountContentView)
            //刷新页面
            accountContentView.reloadData(accountSum: accountBean.accountSum, beans: fundVM.handleAccountBeans(accountBean))
        }
        
    }
    
    //请求用款登记
    fileprivate func requestForFundCheckData() {
        fundCheck_curPage = 1
        fundCheckContentView.tableView.mj_footer = nil
        fundVM.requestForFundCheckNewData(param: ["projectId": projectId, "pageNum": fundCheck_curPage, "pageSize": 20, "smallTypeId": smallTypeId, "startDate": startDate, "endDate": endDate])
    }
    
    @objc func requestFundCheckNewDataSuccess(_ notification: Notification) {
        //结束顶部刷新
        fundCheckContentView.tableView.mj_header.endRefreshing()
        //处理数据
        let specBean = notification.object as! THJGSuccessBean
        let mainBean = specBean.bean as! THJGProjectFundCheckBean
        smallTypes = mainBean.smallTypes
        if mainBean.paysTotal == 0 {
            //添加占位图片
            DQSUtils.showPlaceholderImg(fundCheckContentView.tableView)
            //刷新空数据
            fundCheckContentView.reloadNewData([ProFundInfoCheckHandledBean]())
        } else {
            //删除占位图片
            DQSUtils.hidePlaceholderImg(fundCheckContentView.tableView)
            //刷新列表
            fundCheckContentView.reloadNewData(fundVM.handleFundCheckBeans(mainBean))
            //添加底部刷新
            if mainBean.paysTotal == 20 {
                fundCheckContentView.tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
                    [unowned self] in
                    self.requestForMoreFundCheckData()
                })
            }
        }
    }
    
    @objc func requestFundCheckNewDataFailure(_ notification: Notification) {
        //结束顶部刷新
        fundCheckContentView.tableView.mj_header.endRefreshing()
        //提示异常
        let specBean = notification.object as! THJGFailureBean
        DQSUtils.showToast(specBean.msg, view)
    }
    
    fileprivate func requestForMoreFundCheckData() {
        fundCheck_curPage += 1
        fundVM.requestForFundCheckMoreData(param: ["projectId": projectId, "pageNum": fundCheck_curPage, "pageSize": 20, "smallTypeId": smallTypeId, "startDate": startDate, "endDate": endDate])
    }
    
    @objc func requestFundCheckMoreDataSuccess(_ notification: Notification) {
        //处理分页逻辑
        let specBean = notification.object as! THJGSuccessBean
        let mainBean = specBean.bean as! THJGProjectFundCheckBean
        let fundCheckBeans = fundVM.handleFundCheckBeans(mainBean)
        guard !fundCheckBeans.isEmpty else {//没有更多数据
            (fundCheckContentView.tableView.mj_footer as! MJRefreshAutoNormalFooter).endRefreshingWithNoMoreData()
            return
        }
        if mainBean.paysTotal < 20 {
            (fundCheckContentView.tableView.mj_footer as! MJRefreshAutoNormalFooter).endRefreshingWithNoMoreData()
        } else {
            (fundCheckContentView.tableView.mj_footer as! MJRefreshAutoNormalFooter).endRefreshing()
        }
        //赋值
        fundCheckContentView.reloadMoreData(fundCheckBeans)
    }
    
    @objc func requestFundCheckMoreDataFailure(_ notification: Notification) {
        //当前页递减
        fundCheck_curPage -= 1
        //结束底部刷新
        (fundCheckContentView.tableView.mj_footer as! MJRefreshAutoNormalFooter).endRefreshing()
        //提示异常
        let specBean = notification.object as! THJGFailureBean
        DQSUtils.showToast(specBean.msg, view)
    }
    
    //请求合同台账
    fileprivate func requestForContractData() {
        contract_curPage = 1
        contractContentView.tableView.mj_footer = nil
        fundVM.requestForContractNewData(param: ["projectId": projectId, "pageNum": contract_curPage, "pageSize": 20, "contractName": contractName.trimmingCharacters(in: CharacterSet.whitespaces)])
    }
    
    @objc func requestFundContractNewDataSuccess(_ notification: Notification) {
        //结束顶部刷新
        contractContentView.tableView.mj_header.endRefreshing()
        //处理数据
        let specBean = notification.object as! THJGSuccessBean
        let contractBeans = fundVM.handleContractData(specBean.bean as! THJGProjectContractBean)
        if contractBeans.isEmpty {
            //添加默认占位图
            DQSUtils.showPlaceholderImg(contractContentView.tableView)
            //刷新空数据
            contractContentView.reloadNewData([ProContractHandledBean]())
        } else {
            //删除默认占位图
            DQSUtils.hidePlaceholderImg(contractContentView.tableView)
            //刷新列表
            contractContentView.reloadNewData(contractBeans)
            //添加底部刷新
            if contractBeans.count == 20 {
                contractContentView.tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
                    [unowned self] in
                    self.requestForMoreContractData()
                })
            }
        }
    }
    
    @objc func requestFundContractNewDataFailure(_ notification: Notification) {
        //结束顶部刷新
        contractContentView.tableView.mj_header.endRefreshing()
        //提示异常
        let specBean = notification.object as! THJGFailureBean
        DQSUtils.showToast(specBean.msg, self.view)
    }
    
    fileprivate func requestForMoreContractData() {
        contract_curPage += 1
        fundVM.requestForContractMoreData(param: ["projectId": projectId, "pageNum": contract_curPage, "pageSize":20, "contractName": contractName])
    }
    
    @objc func requestFundContractMoreDataSuccess(_ notification: Notification) {
        //处理分页逻辑
        let specBean = notification.object as! THJGSuccessBean
        let contractBeans = fundVM.handleContractData(specBean.bean as! THJGProjectContractBean)
        guard !contractBeans.isEmpty else {//没有更多数据
            (contractContentView.tableView.mj_footer as! MJRefreshAutoNormalFooter).endRefreshingWithNoMoreData()
            return
        }
        if contractBeans.count < 20 {
            (contractContentView.tableView.mj_footer as! MJRefreshAutoNormalFooter).endRefreshingWithNoMoreData()
        } else {
            (contractContentView.tableView.mj_footer as! MJRefreshAutoNormalFooter).endRefreshing()
        }
        //赋值
        contractContentView.reloadMoreData(contractBeans)
    }
    
    @objc func requestFundContractMoreDataFailure(_ notification: Notification) {
        //当前页递减
        contract_curPage -= 1
        //结束底部刷新
        (contractContentView.tableView.mj_footer as! MJRefreshAutoNormalFooter).endRefreshing()
        //提示异常
        let specBean = notification.object as! THJGFailureBean
        DQSUtils.showToast(specBean.msg, self.view)
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
            contentView.bringSubviewToFront(accountContentView)
            requestForAccountData()
            curSelectedIndex = 0
        case 1001:
            contentView.bringSubviewToFront(fundCheckContentView)
            (fundCheckContentView.tableView.mj_header as! MJRefreshNormalHeader).beginRefreshing()
            curSelectedIndex = 1
            //删除查询条件
            smallTypeId = ""
            startDate = ""
            endDate = ""
        case 1002:
            contentView.bringSubviewToFront(contractContentView)
            (contractContentView.tableView.mj_header as! MJRefreshNormalHeader).beginRefreshing()
            curSelectedIndex = 2
            //删除查询条件
            contractName = ""
        default:
            break
        }
        
    }
    
    //MARK: - 查看合同
    @objc func checkContract(_ notification: Notification) {
        let bean = notification.object as! ProjectContractBean
        let request = URLRequest(url: URL(string: bean.conContentUrl)!)
        let webVC = THJGWebController()
        webVC.request = request
        navigationController?.pushViewController(webVC, animated: true)
    }
    
    //MARK: - 查看合同付款详情
    @objc func checkContractPayDetail(_ notification: Notification) {
        let bean = notification.object as! ProjectContractBean
        let detailVC = THJGProjectContractDetailController()
        detailVC.contractBean = bean
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
}

//MARK: - 搜索事件监听
extension THJGProjectFundInfoController {
    
    //费用类型搜索条件事件监听
    @IBAction func typeBtnDidClicked() {
        let feeTypeView = THJGProjectFeeTypeView.showFeeTypeView()
        feeTypeView.frame = UIScreen.main.bounds
        feeTypeView.completionBlock = {
            [unowned self] result in
            self.smallTypeId = result?.smallTypeId ?? ""
            self.typeBtn.setTitle(result?.smallTypeName, for: .normal)
            (self.fundCheckContentView.tableView.mj_header as! MJRefreshNormalHeader).beginRefreshing()
        }
        feeTypeView.beans = smallTypes
        view.window?.addSubview(feeTypeView)
    }
    
    //起始时间搜索条件事件监听
    @IBAction func startBtnDidClicked() {
        let datePickerView = THJGDatePickerView.showDatePickerView()
        datePickerView.frame = UIScreen.main.bounds
        datePickerView.completeBlock = {
            [unowned self] result in
            self.startDate = result ?? ""
            (self.fundCheckContentView.tableView.mj_header as! MJRefreshNormalHeader).beginRefreshing()
        }
        view.window?.addSubview(datePickerView)
    }
    
    //截止时间搜索条件事件监听
    @IBAction func endBtnDidClicked() {
        //smallTypeId = "5"
        let datePickerView = THJGDatePickerView.showDatePickerView()
        datePickerView.frame = UIScreen.main.bounds
        datePickerView.completeBlock = {
            [unowned self] result in
            self.endDate = result ?? ""
            (self.fundCheckContentView.tableView.mj_header as! MJRefreshNormalHeader).beginRefreshing()
        }
        view.window?.addSubview(datePickerView)
    }
    
}

//MARK: - UITextFieldDelegate
extension THJGProjectFundInfoController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        contractNameSearchIcon.isHidden = true
        contractNamePlaceholder.isHidden = contractNameSearchIcon.isHidden
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        contractName = textField.text ?? ""
        (contractContentView.tableView.mj_header as! MJRefreshNormalHeader).beginRefreshing()
        if DQSUtils.isBlank(textField.text) {
            contractNameSearchIcon.isHidden = false
            contractNamePlaceholder.isHidden = contractNameSearchIcon.isHidden
        }
    }
    
}

//MARK: - THJGFundInfoCheckViewDelegate
extension THJGProjectFundInfoController: THJGFundInfoCheckViewDelegate {
    func checkPdf(_ bean: THJGImgShowBean) {
        let request = URLRequest(url: URL(string: bean.imgUrl)!)
        let webVC = THJGWebController()
        webVC.request = request
        self.navigationController?.pushViewController(webVC, animated: true)
    }
}
