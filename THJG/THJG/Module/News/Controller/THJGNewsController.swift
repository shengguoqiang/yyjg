/**
 * 动态资讯控制器
 */

import UIKit
import MJRefresh

//cell标识
let kTHJGNewsCellIdentifier = "THJGNewsCellIdentifier"

class THJGNewsController: THJGBaseController {
    
    //MARK: - UI Elements
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties
    var newsVM = THJGNewsViewModel()
    var curPage: Int = 1
    var bean: THJGNewsInfoBean! {
        didSet {
            tableView.reloadData()
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
        //注册网络请求回调通知
        NotificationCenter.default.addObserver(self, selector: #selector(requestNewDataSuccess(_:)), name: Notification.Name(THJG_NOTIFICATION_NEWS_NEWDATA_SUCCESS), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(requestNewDataFailure(_:)), name: Notification.Name(THJG_NOTIFICATION_NEWS_NEWDATA_FAILURE), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(requestMoreDataSuccess(_:)), name: Notification.Name(THJG_NOTIFICATION_NEWS_MOREDATA_SUCCESS), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(requestMoreDataFailure(_:)), name: Notification.Name(THJG_NOTIFICATION_NEWS_MOREDATA_FAILURE), object: nil)
    }

}

//MARK: - METHODS
extension THJGNewsController {
    
    //初始化
    func setup() {
        //导航栏标题
        navigationItem.title = "动态资讯"
        
        //注册cell
        tableView.register(UINib(nibName: "THJGNewsCell", bundle: nil), forCellReuseIdentifier: kTHJGNewsCellIdentifier)
        tableView.rowHeight = 200
        
        //分页
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            [unowned self] in
            self.requestForNewData()
        })
        //刷新列表
        tableView.mj_header.beginRefreshing()
    }
    
    //request for new data
    fileprivate func requestForNewData() {
        curPage = 1
        tableView.mj_footer = nil
        newsVM.requestForNewsNewData(param: ["pageNum": curPage, "pageSize": 20])
    }
    
    @objc func requestNewDataSuccess(_ notification: Notification) {
        //结束刷新
        tableView.mj_header.endRefreshing()
        //处理数据
        let specBean = notification.object as! THJGSuccessBean
        bean = (specBean.bean as! THJGNewsInfoBean)
        if bean.newsInfos.isEmpty {
            //添加默认占位图
            DQSUtils.showPlaceholderImg(tableView)
        } else {
            //删除默认占位图
            DQSUtils.hidePlaceholderImg(tableView)
            //处理分页
            if bean.newsInfos.count == 20 {
                tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
                    [unowned self] in
                    self.requestForMoreData()
                })
            }
        }
    }
    
    @objc func requestNewDataFailure(_ notification: Notification) {
        //结束刷新
        tableView.mj_header.endRefreshing()
        //提示
        let specBean = notification.object as! THJGFailureBean
        DQSUtils.showToast(specBean.msg, view)
    }
    
    fileprivate func requestForMoreData() {
        curPage += 1
        newsVM.requestForNewsMoreData(param: ["pageNum": curPage, "pageSize": 20])
    }
    
    @objc func requestMoreDataSuccess(_ notification: Notification) {
        let specBean = notification.object as! THJGSuccessBean
        let loadedBean = (specBean.bean as! THJGNewsInfoBean)
        //处理分页
        guard !loadedBean.newsInfos.isEmpty else {//无更多数据
            (tableView.mj_footer as! MJRefreshAutoNormalFooter).endRefreshingWithNoMoreData()
            return
        }
        if loadedBean.newsInfos.count < 20 {
            (tableView.mj_footer as! MJRefreshAutoNormalFooter).endRefreshingWithNoMoreData()
        } else {
            (tableView.mj_footer as! MJRefreshAutoNormalFooter).endRefreshing()
        }
        //赋值
        bean.newsInfos += loadedBean.newsInfos
    }
    
    @objc func requestMoreDataFailure(_ notification: Notification) {
        //当前页递减
        curPage -= 1
        //结束刷新
        (tableView.mj_footer as! MJRefreshAutoNormalFooter).endRefreshing()
        //提示
        let specBean = notification.object as! THJGFailureBean
        DQSUtils.showToast(specBean.msg, view)
    }
    
}

//MARK: - UITableViewDataSource, UITableViewDelegate
extension THJGNewsController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard bean != nil else {
            return 0
        }
        return bean.newsInfos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kTHJGNewsCellIdentifier) as! THJGNewsCell
        cell.bean = bean.newsInfos[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newsBean = bean.newsInfos[indexPath.row]
        let detailVC = THJGNewsDetailController()
        detailVC.newsId = newsBean.newsId
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
