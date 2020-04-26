/**
 * 首页控制器
 */

import UIKit
import MJRefresh

/* banner */
fileprivate let kBannerViewIdentifier = "bannerViewIdentifier"
fileprivate let kBannerViewCellIdentifier = "homePageBannerCellIdentifier"

/* bulletin */
fileprivate let kBulletinViewIdentifier = "bulletinViewIdentifier"
fileprivate let kBulletinViewCellIdentifier = "homePageBullteinCellIdentifier"

/* project */
fileprivate let kProjectCellIdentifier = "projectCellIdentifier"

class THJGHomePageController: THJGBaseController {
    
    //MARK: - UI Elements
    @IBOutlet weak var containerView: UIScrollView!
    @IBOutlet weak var bannerView: FTDLoopView!
    @IBOutlet weak var pageCtl: UIPageControl!
    
    @IBOutlet weak var bulletinContainerView: UIView!
    @IBOutlet weak var bulletinViewHeight: NSLayoutConstraint!
    @IBOutlet weak var bulletinView: FTDLoopView!
    @IBOutlet weak var newsView: UIView!
    @IBOutlet weak var projectView: UITableView!
    @IBOutlet weak var projectBottomOffSet: NSLayoutConstraint!
    @IBOutlet weak var projectEmptyView: UIView!
    @IBOutlet weak var projectViewHeight: NSLayoutConstraint!
    
    //MARK: - Properties
    lazy var homePageVM = THJGHomePageViewModel()
    var homePageBean: THJGHomePageBean!
 
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        //setup
        setup()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //注册网络请求回调通知
        NotificationCenter.default.addObserver(self, selector: #selector(requestSuccess(_:)), name: Notification.Name(THJG_NOTIFICATION_HOMEPAGE_SUCCESS), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(requestVersionUpdateSuccess(_:)), name: Notification.Name(THJG_NOTIFICATION_VERSION_UPDATE_SUCCESS), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(requestEmergentMsgSuccess(_:)), name: Notification.Name(THJG_NOTIFICATION_EMERGENT_MSG_SUCCESS), object: nil)
    }
    
}

//MARK: - METHODS
extension THJGHomePageController {
    
    //setup
    fileprivate func setup() {
        //隐藏导航栏
        fd_prefersNavigationBarHidden = true
        
        //取消滚动视图自适配
        if #available(iOS 11.0, *) {
            containerView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        //register the project tableView
        projectView.register(UINib(nibName: "THJGProjectCell", bundle: nil), forCellReuseIdentifier: kProjectCellIdentifier)
        
        //添加下拉刷新
        containerView.mj_header = MJRefreshNormalHeader(refreshingBlock: {[unowned self] in
            self.requestForData()
        })
        containerView.mj_header.beginRefreshing()
        
        //询问是否需要设置指纹密码
        if !DQSUtils.touchIDIsSet(), DQSUtils.isSupportTouchID() {
            let touchIDToastView = THJGTouchIDToastView.showTouchIDToastView()
            touchIDToastView.frame = UIScreen.main.bounds
            (UIApplication.shared.delegate as! THJGAppDelegate).window?.addSubview(touchIDToastView)
            touchIDToastView.block = {
                [unowned self] in
                let setPwdVC = THJGSettingPwdController()
                self.navigationController?.pushViewController(setPwdVC, animated: true)
            }
        }
        
        //获取版本更新或紧急公告
        homePageVM.requestForVersionUpdateData(param: nil)
        homePageVM.requestForEmergentMsgData(param: nil)
        
        //调整项目滚动视图底部距离
        guard #available(iOS 11.0, *) else {
            projectBottomOffSet.constant = (tabBarController?.tabBar.bounds.height ?? 49) + 10
            return
        }
    }
    
    //send request for homePage data
    fileprivate func requestForData() {
        DQSUtils.showLoading(view)
        homePageVM.requestForHomePageData(param: nil)
    }
    
    @objc override func requestSuccess(_ notification: Notification) {
        super.requestSuccess(notification)
        //结束下拉刷新
        containerView.mj_header.endRefreshing()
        //get the data
        let specBean = notification.object as! THJGSuccessBean
        homePageBean = (specBean.bean as! THJGHomePageBean)
        //describe the UI
        refreshUI()
    }
    
    override func requestFailure(_ notification: Notification) {
        super.requestFailure(notification)
        //结束下拉刷新
        containerView.mj_header.endRefreshing()
    }
    
    @objc func requestVersionUpdateSuccess(_ notification: Notification) {
        let specBean = notification.object as! THJGSuccessBean
        let updateVersionBean = specBean.bean as! THJGAppUpgradeBean
        //是否有版本更新
        if !updateVersionBean.upgrades.isEmpty {
            let updateView = THJGVersionUpdateView.showUpdateView()
            updateView.frame = UIScreen.main.bounds
            view.window?.addSubview(updateView)
            updateView.bean = updateVersionBean.upgrades.first!
        }
    }
    
    @objc func requestEmergentMsgSuccess(_ notification: Notification) {
        let specBean = notification.object as! THJGSuccessBean
        let emergentMsgBean = specBean.bean as! THJGEmergentMsgBean
        //是否有紧急公告
        if !emergentMsgBean.emergentMsgs.isEmpty {
            let emergentMsgView = THJGEmergentMsgView.showEmergentMsgView()
            emergentMsgView.frame = UIScreen.main.bounds
            view.window?.addSubview(emergentMsgView)
            emergentMsgView.bean = emergentMsgBean.emergentMsgs.first!
        }
    }
    
    //describe the UI
    fileprivate func refreshUI() {
        //banner
        bannerView.config(infinite: true, autoScroll: true, timerInterval: 3, scrollDirection: .horizontal, scrollPosition: .left, instanceName: kBannerViewIdentifier, cellNibName: "THJGHomePageBannerCell", cellIdentifier: kBannerViewCellIdentifier)
        bannerView.delegate = self
        bannerView.reloadLoopView(resource: homePageBean.banners as [AnyObject])
        
        //pageCtl
        pageCtl.isHidden = homePageBean.banners.count <= 1
        pageCtl.numberOfPages = homePageBean.banners.count
        
        //bulletin
        bulletinContainerView.isHidden = homePageBean.bulletins.isEmpty
        bulletinViewHeight.constant = homePageBean.bulletins.isEmpty ? 0 : 32
        if !homePageBean.bulletins.isEmpty {
            bulletinView.config(infinite: true, autoScroll: true, timerInterval: 2, scrollDirection: .vertical, scrollPosition: .top, instanceName: kBulletinViewIdentifier, cellNibName: "THJGHomePageBullteinCell", cellIdentifier: "homePageBullteinCellIdentifier")
            bulletinView.delegate = self
            bulletinView.reloadLoopView(resource: homePageBean.bulletins as [AnyObject])
        }
        
        //news
        for btn in newsView.subviews {
            if btn.isMember(of: THJGVerticalButton.self) {
                btn.removeFromSuperview()
            }
        }
        for (index, newsBean) in homePageBean.newsInfos.enumerated() {
            let btnW: CGFloat = (SCREEN_WIDTH - 30 - 40)/3
            let btnH: CGFloat
                = 110
            let btnX: CGFloat = 15 + CGFloat(index)*(btnW + 20)
            let btnY: CGFloat = 90
            let btn = THJGVerticalButton(frame: CGRect(x: btnX, y: btnY, width: btnW, height: btnH))
            btn.bean = newsBean
            btn.addTarget(self, action: #selector(checkNewsDetail(_:)), for: .touchUpInside)
            newsView.addSubview(btn)
        }
        
        //project
        guard !homePageBean.projects.isEmpty else {
            projectEmptyView.isHidden = false
            projectViewHeight.constant = 130
            return
        }
        projectEmptyView.isHidden = true
        projectViewHeight.constant = CGFloat(homePageBean.projects.count * 200)
        projectView.reloadData()
        
    }
    
    //公告更多
    @IBAction func moreMsgDidClicked(_ sender: UIButton) {
        let platforNoticeVC = THJGPlatformNoticeController()
        navigationController?.pushViewController(platforNoticeVC, animated: true)
    }
    
    //资讯详情
    @objc func checkNewsDetail(_ btn: THJGVerticalButton) {
        let newsBean = btn.bean
        let detailVC = THJGNewsDetailController()
        detailVC.newsId = newsBean?.newsId
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    //资讯更多
    @IBAction func moreNewsBtnDidClicked(_ sender: UIButton) {
        DQSUtils.switchPage(from: navigationController as! THJGNavigationController, to: 1)
    }
    
}

//MARK: - FTDLoopViewDelegate
extension THJGHomePageController: FTDLoopViewDelegate {
    
    //banner event listener
    func collectionViewDidSelected(instanceName: String?, index: Int) {
        if instanceName == kBannerViewIdentifier {//banner click event
            let bannberBean = homePageBean.banners[index]
            switch bannberBean.bannerType {
            case 10://超链接
                if DQSUtils.isNotBlank(bannberBean.bannerLink) {
                   let web = THJGWebController()
                    web.navTitle = bannberBean.bannerTitle
                    web.request = URLRequest(url: URL(string: bannberBean.bannerLink)!)
                    navigationController?.pushViewController(web, animated: true)
                }
            case 20://内链公告
                if DQSUtils.isNotBlank(bannberBean.bannerLink) {
                    let platformNoticeDetailVC = THJGPlatformNoticeDetailController()
                    platformNoticeDetailVC.noticeId = bannberBean.bannerLink
                    navigationController?.pushViewController(platformNoticeDetailVC, animated: true)
                }
            default:
                break
            }
        } else if instanceName == kBulletinViewIdentifier {// bulletin click event
           let platformBean = homePageBean.bulletins[index]
            let detailVC = THJGPlatformNoticeDetailController()
            detailVC.noticeId = platformBean.noticeId
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    func collectionViewDidEndDecelerating(instanceName: String?, index: Int) {
        if instanceName == kBannerViewIdentifier {
            pageCtl.currentPage = index
        }
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension THJGHomePageController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard nil != homePageBean, !homePageBean.projects.isEmpty  else {
            return 0
        }
        return homePageBean.projects.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kProjectCellIdentifier) as! THJGProjectCell
        cell.reloadData(homePageBean.projects[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let projectBean = homePageBean.projects[indexPath.row]
        let projectDetailVC = THJGProjectDetailController()
        projectDetailVC.param = (projectBean.projectId, projectBean.projectName)
        navigationController?.pushViewController(projectDetailVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
