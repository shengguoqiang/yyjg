/**
 * 站内信
 */

import UIKit
import MJRefresh

//cell 标识
fileprivate let kInnerMsgCellIdentifier = "innerMsgCellIdentifier"

class THJGInnerMsgController: THJGBaseController {
    
    //MARK: - UI Elements
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties
    lazy var msgVM = THJGInnerMsgViewModel()
    var bean: THJGInnerMsgBean! {
        didSet {
            tableView.reloadData()
        }
    }
    var curPage: Int = 1

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        //setup
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //注册网络请求回调通知
        NotificationCenter.default.addObserver(self, selector: #selector(requestNewDataSuccess(_:)), name: Notification.Name(THJG_NOTIFICATION_INNERMSG_NEW_DATA_SUCCESS), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(requestNewDataFailure(_:)), name: Notification.Name(THJG_NOTIFICATION_INNERMSG_NEW_DATA_FAILURE), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(requestMoreDataSuccess(_:)), name: Notification.Name(THJG_NOTIFICATION_INNERMSG_MORE_DATA_SUCCESS), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(requestMoreDataFailure(_:)), name: Notification.Name(THJG_NOTIFICATION_INNERMSG_MORE_DATA_FAILURE), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(requestSuccess(_:)), name: Notification.Name(THJG_NOTIFICATION_INNERMSG_READ_SUCCESS), object: nil)
        
        //刷新列表
        tableView.mj_header.beginRefreshing()
    }

}

//MARK: - METHODS
extension THJGInnerMsgController {
    
    //setup
    fileprivate func setup() {
        //设置导航栏标题
        navigationItem.title = "我的消息"
        
        //注册cell
        tableView.register(UINib(nibName: "THJGInnerMsgCell", bundle: nil), forCellReuseIdentifier: kInnerMsgCellIdentifier)
        
        //分页
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            [unowned self] in
            self.requestForNewData()
        })
    }
    
    //request for new data
    fileprivate func requestForNewData() {
        curPage = 1
        tableView.mj_footer = nil
        let user = THJGStorageManager.readUser()!
        msgVM.requestForInnerMsgNewData(param: ["mobile": user.userMobile, "pageNum": curPage, "pageSize": 20])
    }
    
    @objc func requestNewDataSuccess(_ notification: Notification) {
        //结束刷新
        tableView.mj_header.endRefreshing()
        //处理数据
        let specBean = notification.object as! THJGSuccessBean
        bean = (specBean.bean as! THJGInnerMsgBean)
        if bean.msgs.isEmpty {
            //添加默认占位图
            DQSUtils.showPlaceholderImg(view)
        } else {
            //删除默认占位图
            DQSUtils.hidePlaceholderImg(view)
            //导航栏逻辑
            refreshUI()
            //处理分页
            if bean.msgs.count == 20 {
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
         let user = THJGStorageManager.readUser()!
        msgVM.requestForInnerMsgMoreData(param: ["mobile": user.userMobile, "pageNum": curPage, "pageSize": 20])
    }
    
    @objc func requestMoreDataSuccess(_ notification: Notification) {
        let specBean = notification.object as! THJGSuccessBean
        let loadedBean = (specBean.bean as! THJGInnerMsgBean)
        //处理分页
        guard !loadedBean.msgs.isEmpty else {//无更多数据
            (tableView.mj_footer as! MJRefreshAutoNormalFooter).endRefreshingWithNoMoreData()
            return
        }
        if loadedBean.msgs.count < 20 {
            (tableView.mj_footer as! MJRefreshAutoNormalFooter).endRefreshingWithNoMoreData()
        } else {
            (tableView.mj_footer as! MJRefreshAutoNormalFooter).endRefreshing()
        }
        //赋值
        bean.msgs += loadedBean.msgs
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
    
    //refresh ui
    fileprivate func refreshUI() {
        if bean.unRead > 0 {
            //显示导航按钮【全部已读】
            navigationItem.rightBarButtonItem = UIBarButtonItem.item(title: "全部已读", target: self, action: #selector(allReadDidClick))
        } else {
            //隐藏导航按钮【全部已读】
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    @objc func allReadDidClick() {
        DQSUtils.showLoading(view)
        let user = THJGStorageManager.readUser()!
        msgVM.requestForAllReadMsgs(param: ["mobile": user.userMobile])
    }
    
    @objc override func requestSuccess(_ notification: Notification) {
        let specBean = notification.object as! THJGSuccessBean
        DQSUtils.showToast(specBean.msg ?? "消息已置为已读", view)
        tableView.mj_header.beginRefreshing()
    }
}

extension THJGInnerMsgController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard bean != nil else {
            return 0
        }
        return bean.msgs.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kInnerMsgCellIdentifier) as! THJGInnerMsgCell
        cell.bean = bean.msgs[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = THJGInnerMsgDetailController()
        detailVC.msgId = bean.msgs[indexPath.row].msgId
        navigationController?.pushViewController(detailVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
