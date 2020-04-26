/**
 * 项目计划及进度
 */

/* cell */
fileprivate let kProPlanCellIdentifier = "proPlanCellIdentifier"

import UIKit
import MJRefresh

class THJGProjectPlanController: THJGBaseController {
    
    //MARK: - UI Elements
    @IBOutlet weak var projectNameLabel: UILabel!
    @IBOutlet weak var typeBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties
    var projectId: String!
    var type: String = "1"
    var curPage: Int!
    lazy var proPlanVM = THJGProjectPlanViewModel()
    var proPlanHanledBeans: [THJGProPlanHandledBean]! {
        didSet {
            tableView.reloadData()
        }
    }
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        //setup
        setup()
        
        //请求数据
        tableView.mj_header.beginRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //注册网络请求回调通知
        NotificationCenter.default.addObserver(self, selector: #selector(requestNewDataSuccess(_:)), name: Notification.Name(THJG_NOTIFICATION_PROJECTPLAN_NEW_DATA_SUCCESS), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(requestNewDataFailure(_:)), name: Notification.Name(THJG_NOTIFICATION_PROJECTPLAN_NEW_DATA_FAILURE), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(requestMoreDataSuccess(_:)), name: Notification.Name(THJG_NOTIFICATION_PROJECTPLAN_MORE_DATA_SUCCESS), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(requestMoreDataFailure(_:)), name: Notification.Name(THJG_NOTIFICATION_PROJECTPLAN_MORE_DATA_FAILURE), object: nil)
    }
    
}

//MARK: - METHODS
extension THJGProjectPlanController {
    
    //setup
    func setup() {
        //设置导航栏标题
        navigationItem.title = "工程进度"
        
        //tableView register the cell
        tableView.register(UINib(nibName: "THJGProPlanCell", bundle: nil), forCellReuseIdentifier: kProPlanCellIdentifier)
        
        //分页
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            [unowned self] in
            self.requestForNewData(type: self.type)
        })
    }
    
    //send request for data
    func requestForNewData(type: String) {
        curPage = 1
        tableView.mj_footer = nil
        proPlanVM.requestForNewProPlanData(param: ["projectId": projectId, "type": type, "pageNum": curPage, "pageSize": 20])
    }
    
    @objc func requestNewDataSuccess(_ notification: Notification) {
        //结束刷新
        tableView.mj_header.endRefreshing()
        //加载页面
        let specBean = notification.object as! THJGSuccessBean
        let bean = specBean.bean as! THJGProjectPlanBean
        projectNameLabel.text = bean.proName
        proPlanHanledBeans = proPlanVM.handleData(bean)
        if proPlanHanledBeans.isEmpty {
            //添加占位图
            DQSUtils.showPlaceholderImg(tableView, 45)
        } else {
            //删除占位图
            DQSUtils.hidePlaceholderImg(tableView)
            // 处理分页
            if proPlanHanledBeans.count == 20, type == "2" {
                tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
                    [unowned self] in
                    self.requestForMoreData(type: self.type)
                })
            }
        }
    }
    
    @objc func requestNewDataFailure(_ notification: Notification) {
        //结束刷新
        tableView.mj_header.endRefreshing()
        
        //提示
        let specBean = notification.object as! THJGFailureBean
        DQSUtils.showToast(specBean.msg, self.view)
    }
    
    
    func requestForMoreData(type: String) {
        curPage += 1
        proPlanVM.requestForMoreProPlanData(param: ["projectId": projectId, "type": type, "pageNum": curPage, "pageSize": 20])
    }
    
    @objc func requestMoreDataSuccess(_ notification: Notification) {
        //处理分页
        let specBean = notification.object as! THJGSuccessBean
        let bean = specBean.bean as! THJGProjectPlanBean
        let handledBeans = proPlanVM.handleData(bean)
        guard !handledBeans.isEmpty else {//无更多数据
            (tableView.mj_footer as! MJRefreshAutoNormalFooter).endRefreshingWithNoMoreData()
            return
        }
        if handledBeans.count == 20 {
            (tableView.mj_footer as! MJRefreshAutoNormalFooter).endRefreshing()
        } else {
            (tableView.mj_footer as! MJRefreshAutoNormalFooter).endRefreshingWithNoMoreData()
        }
        
        //处理数据
        proPlanHanledBeans += handledBeans
    }
    
    @objc func requestMoreDataFailure(_ notification: Notification) {
        //当前页递减
        curPage -= 1
        
        //结束刷新
        (tableView.mj_footer as! MJRefreshAutoNormalFooter).endRefreshing()
        
        //提示
        let specBean = notification.object as! THJGFailureBean
        DQSUtils.showToast(specBean.msg, self.view)
    }
    
    //type btn click event
    @IBAction func typeButtonDidClicked(_ sender: UIButton) {
        typeBtn.isSelected = !typeBtn.isSelected
        self.type = typeBtn.isSelected ? "2" : "1"
        tableView.mj_header.beginRefreshing()
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension THJGProjectPlanController: UITableViewDelegate, UITableViewDataSource {
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard proPlanHanledBeans != nil else {
            return 0
        }
        return proPlanHanledBeans.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return proPlanHanledBeans[indexPath.row].cellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kProPlanCellIdentifier) as! THJGProPlanCell
        cell.reloadData(proPlanHanledBeans[indexPath.row].cellBean) {[unowned self] (beans, curIndex) in
            let bean = beans[curIndex ?? 0]
            if bean.isPdf {//pdf
                let request = URLRequest(url: URL(string: bean.imgUrl)!)
                let webVC = THJGWebController()
                webVC.request = request
                self.navigationController?.pushViewController(webVC, animated: true)
            } else if bean.isVideo {//本地视频
                //剔除pdf和图片
                var handledBeans = [THJGImgShowBean]()
                for showBean in beans {
                    if showBean.isVideo {
                        handledBeans.append(showBean)
                    }
                }
                let handledIndex = (beans.count == handledBeans.count) ? (curIndex ?? 0) : 0
                let imgShowView = THJGImageShowView.showImgView()
                imgShowView.frame = UIScreen.main.bounds
                imgShowView.reloadData(handledBeans, curIndex: handledIndex/*, showType: .imgAndLocalVideo*/)
                self.view.window?.addSubview(imgShowView)
            } else {//图片
                let imgShowView = THJGBigImgShowView.showBigImageView()
                imgShowView.frame = UIScreen.main.bounds
                imgShowView.imageUrl = bean.imgUrl
                self.view.window?.addSubview(imgShowView)
            }
        }
        return cell
    }
}
