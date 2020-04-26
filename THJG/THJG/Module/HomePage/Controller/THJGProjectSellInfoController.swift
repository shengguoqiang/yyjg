/**
 * 项目销售信息
 */

import UIKit

class THJGProjectSellInfoController: THJGBaseController {
    
    //MARK: - UI Elements
    @IBOutlet weak var projectNameLabel: UILabel!
    @IBOutlet weak var sellDetialBtn: UIButton!
    @IBOutlet weak var planBtn: UIButton!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var markView: UIView!
    
    @IBOutlet weak var sellDetailView: THJGProSellInfoDetailView!
    @IBOutlet var sellDetailHeaderView: THJGProSellInfoDetailHeaderView!
    @IBOutlet weak var planView: THJGProSellInfoPlanView!
    
    //MARK: - Properties
    //projectId
    var projectId: String!
    //VM
    lazy var sellInfoVM = THJGProjectSellInfoViewModel()
    //tab相关
    var curSelectedTab: UIButton! {
        didSet {
            curSelectedTab.isSelected = true
        }
    }
    var curSelectedIndex: Int = 0 {
        didSet {
            switch curSelectedIndex {
            case 0://销售明细
                var center = markView.center
                center.x = sellDetialBtn.center.x
                markView.center = center
                tabBtnDidClicked(sellDetialBtn)
            case 1://计划与进度
                var center = markView.center
                center.x = planBtn.center.x
                markView.center = center
                tabBtnDidClicked(planBtn)
            default:
                break
            }
        }
    }
    //销售明细列表
    var sellDetailBeans: [ProjectSellDetailHandledBean]! {
        didSet {
            sellDetailView.reloadData(sellDetailBeans)
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
        /* 注册网络请求回调通知 */
        //销售明细
        NotificationCenter.default.addObserver(self, selector: #selector(requestSuccess(_:)), name: Notification.Name(THJG_NOTIFICATION_SELLINFO_DETAIL_SUCCESS), object: nil)
        
        //计划与进度
        NotificationCenter.default.addObserver(self, selector: #selector(requestPlanSuccess(_:)), name: Notification.Name(THJG_NOTIFICATION_SELLINFO_PLAN_SUCCESS), object: nil)
    }

}

//MARK: - METHODS
extension THJGProjectSellInfoController {
    
    //MARK: - setup
    fileprivate func setup() {
        //设置导航栏标题
        navigationItem.title = "销售信息"
        
        //屏蔽全屏返回手势
        fd_interactivePopDisabled = true
        
        //add guesture to the view
        let guesture_left = UISwipeGestureRecognizer(target: self, action: #selector(swapSubViews))
        guesture_left.direction = .left
        view.addGestureRecognizer(guesture_left)
        
        let guesture_right = UISwipeGestureRecognizer(target: self, action: #selector(swapSubViews))
        guesture_right.direction = .right
        view.addGestureRecognizer(guesture_right)
        
        //默认选中【销售明细】
        curSelectedIndex = 0
        
        //销售明细滚动视图的顶部视图
        sellDetailView.tableView.tableHeaderView = sellDetailHeaderView
        sellDetailView.detailViewDelegate = self
    }
    
    //MARK: - request for data
    //销售明细
    fileprivate func requestForSellDetailData() {
        DQSUtils.showLoading(view)
        sellInfoVM.requestForProjectSellDetailData(param: ["projectId": projectId])
    }
    
    @objc override func requestSuccess(_ notification: Notification) {
        super.requestSuccess(notification)
        //获取数据
        let specBean = notification.object as! THJGSuccessBean
        let sellDetailBean = specBean.bean as! THJGProjectSellDetailBean
        projectNameLabel.text = sellDetailBean.projectName
        if sellDetailBean.projectSellDetails.isEmpty {
            //添加默认占位图
            DQSUtils.showPlaceholderImg(sellDetailView)
        } else {
            //删除默认占位图
            DQSUtils.hidePlaceholderImg(sellDetailView)
            //刷新列表
            sellDetailHeaderView.bean = sellDetailBean
            sellDetailBeans = sellInfoVM.handleSellDetailData(sellDetailBean)
        }
    }
    
    //计划与进度
    fileprivate func requestForSellPlanData() {
        DQSUtils.showLoading(view)
        sellInfoVM.requestForProjectPlanData(param: ["projectId": projectId])
    }
    
    @objc func requestPlanSuccess(_ notification: Notification) {
        DQSUtils.hideLoading(view)
        //获取数据
        let specBean = notification.object as! THJGSuccessBean
        let planBean = specBean.bean as! THJGProjectSellPlanBean
        if planBean.plans.isEmpty {
            //添加默认占位图
            DQSUtils.showPlaceholderImg(planView)
        } else {
            //删除默认占位图
            DQSUtils.hidePlaceholderImg(planView)
            //刷新列表
            planView.beans = sellInfoVM.handleSellPlanData(planBean)
        }
    }
    
    //MARK: - switch the tab
    @objc func swapSubViews(_ guestureRecognizer: UISwipeGestureRecognizer) {
        switch guestureRecognizer.direction {
        case .left:
            if curSelectedIndex != 1 {
                curSelectedIndex += 1
            } else {
                curSelectedIndex = 0
            }
        case .right:
            if curSelectedIndex != 0 {
                curSelectedIndex -= 1
            } else {
                curSelectedIndex = 1
            }
        default:
            break
        }
    }
    
    //Tab切换事件监听
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
        case 2000:
            contentView.bringSubviewToFront(sellDetailView)
            requestForSellDetailData()
            curSelectedIndex = 0
        case 2001:
            contentView.bringSubviewToFront(planView)
            requestForSellPlanData()
            curSelectedIndex = 1
        default:
            break
        }
    }
    
}

//MARK: - THJGProSellInfoDetailViewDelete
extension THJGProjectSellInfoController :THJGProSellInfoDetailViewDelete {
    
    func checkRoomDetail(_ bean: ProjectBlockSellDetailBean) {
        guard DQSUtils.isNotBlank(bean.projectId) else {
            return
        }
        let roomDetailVC = THJGProjectRoomSellDetailController()
        roomDetailVC.params = (bean.projectId, bean.blockNum, bean.blockUnit, bean.unitRoom)
        navigationController?.pushViewController(roomDetailVC, animated: true)
    }
    
}
