/**
 * 平台公告
 */

import UIKit
import MJRefresh

//cell 标识
fileprivate let kPlatformNoticeCellIdentifier = "platformNoticeCellIdentifier"

class THJGPlatformNoticeController: THJGBaseController {
    
    //MARK: - UI Elements
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties
    lazy var noticeVM = THJGPlatformNoticeViewModel()
    var curPage: Int = 1
    var bean: THJGPlatformNoticeBean! {
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
        NotificationCenter.default.addObserver(self, selector: #selector(requestNewDataSuccess(_:)), name: Notification.Name(THJG_NOTIFICATION_PLATFORMINFO_NEW_DATA_SUCCESS), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(requestNewDataFailure(_:)), name: Notification.Name(THJG_NOTIFICATION_PLATFORMINFO_NEW_DATA_FAILURE), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(requestMoreDataSuccess(_:)), name: Notification.Name(THJG_NOTIFICATION_PLATFORMINFO_MORE_DATA_SUCCESS), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(requestMoreDataFailure(_:)), name: Notification.Name(THJG_NOTIFICATION_PLATFORMINFO_MORE_DATA_FAILURE), object: nil)
    }

}

//MARK: - METHODS
extension THJGPlatformNoticeController {
    
    //setup
    fileprivate func setup() {
        //设置导航栏标题
        navigationItem.title = "平台公告"
        
        //注册cell
        tableView.register(UINib(nibName: "THJGPlatformNoticeCell", bundle: nil), forCellReuseIdentifier: kPlatformNoticeCellIdentifier)
        
        //分页
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            [unowned self] in
            self.requestForNewData()
        })
        tableView.mj_header.beginRefreshing()
    }
    
    //request for data
    fileprivate func requestForNewData() {
        curPage = 1
        tableView.mj_footer = nil
        noticeVM.requestForNewPlatformNotices(param: ["pageNum": curPage, "pageSize": 20])
    }
    
    @objc func requestNewDataSuccess(_ notification: Notification) {
        //结束刷新
        (tableView.mj_header as! MJRefreshNormalHeader).endRefreshing()
        //赋值
        let sepcBean = notification.object as! THJGSuccessBean
        bean = (sepcBean.bean as! THJGPlatformNoticeBean)
        if bean.notices.isEmpty {
            //添加默认占位图
            DQSUtils.showPlaceholderImg(tableView)
        } else {
            //删除默认占位图
            DQSUtils.hidePlaceholderImg(tableView)
            //处理分页
            if bean.notices.count == 20 {
                tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
                    [unowned self] in
                    self.requestForMoreData()
                })
            }
        }
    }
    
    @objc func requestNewDataFailure(_ notification: Notification) {
        //结束刷新
        (tableView.mj_header as! MJRefreshNormalHeader).endRefreshing()
        
        //提示
        let sepcBean = notification.object as! THJGFailureBean
        DQSUtils.showToast(sepcBean.msg, view)
    }
    
    fileprivate func requestForMoreData() {
        curPage += 1
        noticeVM.requestForMorePlatformNotices(param: ["pageNum": curPage, "pageSize": 20])
    }
    
    @objc func requestMoreDataSuccess(_ notification: Notification) {
        let specBean = notification.object as! THJGSuccessBean
        let loadedBean = specBean.bean as! THJGPlatformNoticeBean
        //处理分页
        guard !loadedBean.notices.isEmpty else {//无更多数据
            (tableView.mj_footer as! MJRefreshAutoNormalFooter).endRefreshingWithNoMoreData()
            return
        }
        if loadedBean.notices.count < 20 {
            (tableView.mj_footer as! MJRefreshAutoNormalFooter).endRefreshingWithNoMoreData()
        } else {
            (tableView.mj_footer as! MJRefreshAutoNormalFooter).endRefreshing()
        }
        //赋值
        bean.notices += loadedBean.notices
    }
    
    @objc func requestMoreDataFailure(_ notification: Notification) {
        //当前页递减
        curPage -= 1
        //结束刷新
        (tableView.mj_footer as! MJRefreshAutoNormalFooter).endRefreshing()
        //提示
        let sepcBean = notification.object as! THJGFailureBean
        DQSUtils.showToast(sepcBean.msg, view)
    }
}

extension THJGPlatformNoticeController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard bean != nil else {
            return 0
        }
        return bean.notices.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kPlatformNoticeCellIdentifier) as! THJGPlatformNoticeCell
        cell.bean = bean.notices[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = THJGPlatformNoticeDetailController()
        detailVC.noticeId = bean.notices[indexPath.row].noticeId
        navigationController?.pushViewController(detailVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
