/**
 * 竞品楼盘控制器
 */

import UIKit

class THJGProCompetionController: THJGBaseController {
    
    //MARK: - UI Elements
    @IBOutlet weak var projectNameLabel: UILabel!
    @IBOutlet weak var competeView: THJGProSellInfoCompeteView!
    
    //MARK: - Properties
    var projectId: String!
    //VM
    lazy var sellInfoVM = THJGProjectSellInfoViewModel()

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        //初始化
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //管理地图生命周期
        competeView.mapView.viewWillAppear()
        
        /* 注册网络请求回调通知 */
        //竞品楼盘
        NotificationCenter.default.addObserver(self, selector: #selector(requestCompetionSuccess(_:)), name: Notification.Name(THJG_NOTIFICATION_SELLINFO_COMPETION_SUCCESS), object: nil)
        
        //发送请求
        requestForCompetionData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //代理清空
        competeView.mapView.delegate = nil
        for search in competeView.searchArray {
            search.delegate = nil
        }
        //管理地图生命周期
        competeView.mapView.viewWillDisappear()
    }
    
}

//MARK: - METHODS
extension THJGProCompetionController {
    
    //初始化
    func setup() {
        //设置标题
        navigationItem.title = "竞品楼盘"
        
        //屏蔽全屏手势
        fd_interactivePopDisabled = true
    }
    
    //竞品楼盘
    fileprivate func requestForCompetionData() {
        DQSUtils.showLoading(view)
        sellInfoVM.requestForProjectCompetionData(param: ["projectId": projectId])
    }
    
    @objc func requestCompetionSuccess(_ notification: Notification) {
        DQSUtils.hideLoading(view)
        //获取数据
        let specBean = notification.object as! THJGSuccessBean
        let competionBean = (specBean.bean as! THJGProjectSellCompetionBean)
        
        //更新页面
        projectNameLabel.text = competionBean.curProject.curProName
        competeView.reloadData(curProject: competionBean.curProject, competions: competionBean.competions)
    }
    
}
