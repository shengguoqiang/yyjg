/**
 * 项目详情
 */

import UIKit
import SnapKit

/* banner cell */
fileprivate let kProDetailImgCellIdentifier = "proDetailImgCellIdentifier"

/* 项目描述 cell */
fileprivate let kProSituationCellIdentifier = "proSituationCellIdentifier"
/* 施工现场 cell */
fileprivate let kProDetailVideoCellIdentifier = "proDetailVideoCellIdentifier"
/* 日常管理 cell*/
fileprivate let kProDaylyManageCellIdentifier = "proDaylyManageCellIdentifier"
/* 项目监控 cell */
fileprivate let kProIndicatorCellIdentifier = "proIndicatorCellIdentifier"
/* 销售市场 cell */
fileprivate let kProSellInfoCellIdentifier = "proSellInfoCellIdentifier"
/* 公司企业 cell */
fileprivate let kProCompanyCellIdentifier = "proCompanyCellIdentifier"
/* 抵/质押情况 cell */
fileprivate let kProDZYCellIdentifier = "proDZYCellIdentifier"
/* 施工方 cell */
fileprivate let kProOperatorCellIdentifier = "proOperatorCellIdentifier"

class THJGProjectDetailController: THJGBaseController {
    
    //MARK: - UI Elements
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var loopView: FTDLoopView!
    @IBOutlet weak var pageCtl: UIPageControl!
    @IBOutlet weak var proLoanLabel: UILabel!
    @IBOutlet weak var proBalanceLabel: UILabel!
    @IBOutlet weak var proDateLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties
    var param: (projectId: String, projectName: String)! {
        didSet {
            //设置导航栏标题
            navigationItem.title = param.projectName
        }
    }
    lazy var proDetailVM = THJGProjectDetailViewModel()
    var proDetailBean: THJGProjectDetailBean!
    var proDetialCellBean: [(String, [Any])]!

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        //setup
        setup()
        
        //请求数据
        requestForData(param.projectId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //注册网络请求回调通知
        NotificationCenter.default.addObserver(self, selector: #selector(requestSuccess(_:)), name: Notification.Name(THJG_NOTIFICATION_PROHECT_DETAIL_SUCCESS), object: nil)
        
        //注册全屏通知
        NotificationCenter.default.addObserver(self, selector: #selector(requestForFullScreen(_:)), name: Notification.Name(NOTIFICATION_VIDEO_REC_FULLSCREEN), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(requestForSmallScreen), name: Notification.Name(NOTIFICATION_VIDEO_REC_SMALLSCREEN), object: nil)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .allButUpsideDown
    }
    
}

//MARK: - METHODS
extension THJGProjectDetailController {
    
    //setup
    fileprivate func setup() {
        //header
        headerView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_WIDTH*0.64)
        loopView.config(infinite: true, autoScroll: true, timerInterval: 3, scrollDirection: .horizontal, scrollPosition: .left, cellNibName: "THJGProDetialImgCell", cellIdentifier: kProDetailImgCellIdentifier)
        loopView.delegate = self
        tableView.tableHeaderView = headerView
        
        //cell
        tableView.register(UINib(nibName: "THJGProSituationCell", bundle: nil), forCellReuseIdentifier: kProSituationCellIdentifier)
        tableView.register(UINib(nibName: "THJGProVideoCell", bundle: nil), forCellReuseIdentifier: kProDetailVideoCellIdentifier)
        tableView.register(UINib(nibName: "THJGProDaylyManageVideoCell", bundle: nil), forCellReuseIdentifier: kProDaylyManageCellIdentifier)
        tableView.register(UINib(nibName: "THJGProMonitorCell", bundle: nil), forCellReuseIdentifier: kProIndicatorCellIdentifier)
        tableView.register(UINib(nibName: "THJGProSellMarketCell", bundle: nil), forCellReuseIdentifier: kProSellInfoCellIdentifier)
        tableView.register(UINib(nibName: "THJGProCompanyCell", bundle: nil), forCellReuseIdentifier: kProCompanyCellIdentifier)
        tableView.register(UINib(nibName: "THJGProDZYCell", bundle: nil), forCellReuseIdentifier: kProDZYCellIdentifier)
        tableView.register(UINib(nibName: "THJGProOperatorCell", bundle: nil), forCellReuseIdentifier: kProOperatorCellIdentifier)
        
    }
    
    //send request for detail
    fileprivate func requestForData(_ projectId: String) {
        DQSUtils.showLoading(view)
        proDetailVM.requestForProjectDetailData(param: ["projectId": projectId])
    }
    
    @objc override func requestSuccess(_ notification: Notification) {
        super.requestSuccess(notification)
        let speBean = notification.object as! THJGSuccessBean
        proDetailBean = (speBean.bean as! THJGProjectDetailBean)
        proDetialCellBean = proDetailVM.handleProDetailData(bean: proDetailBean)
        refreshUI()
    }
    
    //describe the UI
    fileprivate func refreshUI() {
        
        /* heaer */
        //loop
        loopView.reloadLoopView(resource: proDetailBean.proImgs as [AnyObject])
        
        //pageCtl
        pageCtl.isHidden = proDetailBean.proImgs.count <= 1
        pageCtl.numberOfPages = proDetailBean.proImgs.count
        headerView.bringSubviewToFront(pageCtl)
        
        //baseInfo
        proLoanLabel.text = "\(DQSUtils.showNumWithComma(num: DQSUtils.showDoubleNum(sourceDouble: proDetailBean.proLoanAmount, floatNum: 2, showStyle: .showStyleNoZero)))万元"
        proBalanceLabel.text = "\(DQSUtils.showNumWithComma(num: DQSUtils.showDoubleNum(sourceDouble: proDetailBean.proLoanBalance, floatNum: 2, showStyle: .showStyleNoZero)))万元"
        proDateLabel.text = DQSUtils.showTime(interval: TimeInterval(proDetailBean.proExpireDate/1000), timeFormate: "yyyy-MM-dd")
        
        //tableView
        tableView.reloadData()
        
    }
    
    @objc func requestForFullScreen(_ notification: Notification) {
        let value = UIInterfaceOrientation.landscapeRight.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        let specBean = notification.object as! String
        if specBean.isLocalVideo() {//本地视频
            let fullView = THJGLocalVideoFullScreenView.showLocalVideoFullScreen()
            fullView.frame = UIScreen.main.bounds
            view.window?.addSubview(fullView)
            fullView.url = specBean
        } else {//萤石视频
            let fullView = THJGVideoFullScreenView.showFullScreen()
            fullView.frame = UIScreen.main.bounds
            view.window?.addSubview(fullView)
            fullView.url = specBean
        }
    }
    
    @objc func requestForSmallScreen() {
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
}

//MARK: - FTDLoopViewDelegate
extension THJGProjectDetailController: FTDLoopViewDelegate {
    func collectionViewDidSelected(index: Int) {
        guard !proDetailBean.proImgs.isEmpty else {
            return
        }
        let bigImgShowView = THJGBigImgShowView.showBigImageView()
        bigImgShowView.frame = UIScreen.main.bounds
        bigImgShowView.imageUrl = proDetailBean.proImgs[index].proImgUrl
        view.window?.addSubview(bigImgShowView)
    }
    
    func collectionViewDidEndDecelerating(index: Int) {
        pageCtl.currentPage = index
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension THJGProjectDetailController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard nil != proDetialCellBean else {
            return 0
        }
        return proDetialCellBean.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 65))
        headerView.backgroundColor = UIColor.white
        //分割线
        let seperatorView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 10))
        seperatorView.backgroundColor = DQSUtils.rgbColor(242, 242, 243)
        headerView.addSubview(seperatorView)
        
        //标题
        let titleLabel = UILabel(frame: CGRect(x: 15, y: 10, width: SCREEN_WIDTH, height: 55))
        titleLabel.textColor = DQSUtils.rgbColor(33, 33, 33)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.text = proDetialCellBean[section].0
        headerView.addSubview(titleLabel)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let bean = proDetialCellBean[indexPath.section]
        let cellBean = bean.1[indexPath.row] as! ProDetailTempBean
        return cellBean.cellHeight ?? 45
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return proDetialCellBean[section].1.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        let sectionTitle = proDetialCellBean[indexPath.section].0
        let detailBean = proDetialCellBean[indexPath.section].1[indexPath.row] as! ProDetailTempBean
        switch sectionTitle {
        case PRO_SECTION_SITUATION:  //项目描述
            cell = tableView.dequeueReusableCell(withIdentifier: kProSituationCellIdentifier)
            (cell as! THJGProSituationCell).bean = (detailBean.content as! THJGProjectDetailBean)
        case PRO_SECTION_VIDEO_SGXC: //施工现场
            cell = tableView.dequeueReusableCell(withIdentifier: kProDetailVideoCellIdentifier)
            (cell as! THJGProVideoCell).reloadData(detailBean.content as! [THJGProVideoBean]) {[unowned self] (beans, curIndex) in
                let imgShowView = THJGImageShowView.showImgView()
                imgShowView.frame = UIScreen.main.bounds
                imgShowView.reloadData(beans, curIndex: curIndex ?? 0)
                self.view.window?.addSubview(imgShowView)
            }
        case PRO_SECTION_VIDEO_RCGL: //日常管理
            cell = tableView.dequeueReusableCell(withIdentifier: kProDaylyManageCellIdentifier)
            (cell as! THJGProDaylyManageVideoCell).reloadData(detailBean.content as! [THJGProVideoBean]) {[unowned self] (beans, curIndex) in
                let imgShowView = THJGImageShowView.showImgView()
                imgShowView.frame = UIScreen.main.bounds
                imgShowView.reloadData(beans, curIndex: curIndex ?? 0)
                self.view.window?.addSubview(imgShowView)
            }
        case PRO_SECTION_INDICATOR: //项目监控
            cell = tableView.dequeueReusableCell(withIdentifier: kProIndicatorCellIdentifier)
            (cell as! THJGProMonitorCell).reloadData(indi: detailBean.content as! [String]) { [unowned self] (title, _) in
                switch title {
                case PRO_INDICATOR_PLAN: //工程进度
                    let proPlanVC = THJGProjectPlanController()
                    proPlanVC.projectId = self.param.projectId
                    self.navigationController?.pushViewController(proPlanVC, animated: true)
                case PRO_INDICATOR_TIME: //节点考核
                    let proTimesVC = THJGProjectTimesController()
                    proTimesVC.projectId = self.param.projectId
                    self.navigationController?.pushViewController(proTimesVC, animated: true)
                case PRO_INDICATOR_CB: //成本费用
                    let proDevCostVC = THJGProjectDevCostController()
                    proDevCostVC.projectId = self.param.projectId
                    self.navigationController?.pushViewController(proDevCostVC, animated: true)
                case PRO_INDICATOR_FUND: //监管资金
                    let fundVC = THJGProjectFundInfoController()
                    fundVC.projectId = self.param.projectId
                    self.navigationController?.pushViewController(fundVC, animated: true)
                case PRO_INDICATOR_LOG: //用章登记
                    let cachetVC = THJGProjectCachetController()
                    cachetVC.projectId = self.param.projectId
                    cachetVC.projectName = self.param.projectName
                    self.navigationController?.pushViewController(cachetVC, animated: true)
                default:
                    break
                }
            }
        case PRO_SECTION_SELLMARKET: //销售市场
            cell = tableView.dequeueReusableCell(withIdentifier: kProSellInfoCellIdentifier)
            (cell as! THJGProSellMarketCell).reloadData(indi: detailBean.content as! String) {[unowned self] (title, _) in
                switch title {
                case PRO_SELLMARKET_INFO: //销售信息
                    let sellVC = THJGProjectSellInfoController()
                    sellVC.projectId = self.param.projectId
                    self.navigationController?.pushViewController(sellVC, animated: true)
                case PRO_SELLMARKET_COMPETITION: //竞品楼盘
                    let competeVC = THJGProCompetionController()
                    competeVC.projectId = self.param.projectId
                    self.navigationController?.pushViewController(competeVC, animated: true)
                case PRO_SELLMARKET_MARKET: //市场信息
                    let marketVC = THJGProMarketInfoController()
                    marketVC.projectId = self.param.projectId
                    self.navigationController?.pushViewController(marketVC, animated: true)
                default:
                    break
                }
            }
        case PRO_SECTION_LOANCOMPANY, PRO_SECTION_DEVELOPER, PRO_SECTION_GUARANTEE: //借款企业、开发商、担保企业
            cell = tableView.dequeueReusableCell(withIdentifier: kProCompanyCellIdentifier)
            let companyBean = detailBean.content as! THJGCompanyInfoBean
            (cell as! THJGProCompanyCell).reloadData(bean: companyBean) {[unowned self] (title, index) in
                let companyVC = THJGProCompanyController()
                companyVC.param = (companyBean.companyId, companyBean.companyType, index ?? 0)
                self.navigationController?.pushViewController(companyVC, animated: true)
            }
        case PRO_SECTION_DIZHIYA: //抵/质押情况
            cell = tableView.dequeueReusableCell(withIdentifier: kProDZYCellIdentifier)
            let pledgeInfos = detailBean.content as! [THJGPldgeInfoBean]
            (cell as! THJGProDZYCell).reloadData(beans: pledgeInfos) {[unowned self] (title, index) in
                let detailVC = THJGProDZYController()
                detailVC.bean = pledgeInfos[index ?? 0]
                detailVC.projectName = self.param.projectName
                self.navigationController?.pushViewController(detailVC, animated: true)
            }
        case PRO_SECTION_OPERATOR: //施工方
            cell = tableView.dequeueReusableCell(withIdentifier: kProOperatorCellIdentifier)
            let companyBean = detailBean.content as! THJGCompanyInfoBean
            (cell as! THJGProOperatorCell).reloadData(bean: companyBean) {[unowned self] (title, index) in
                let companyVC = THJGProCompanyController()
                companyVC.param = (companyBean.companyId, companyBean.companyType, index ?? 0)
                self.navigationController?.pushViewController(companyVC, animated: true)
            }
        default:
            break
        }
        return cell ?? UITableViewCell(style: .default, reuseIdentifier: nil)
    }
}
