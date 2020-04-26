/**
 * 项目用章登记信息控制器
 */

import UIKit
import MJRefresh

//Cell 标识
fileprivate let kProjectCachetCellIdentifier = "projectCachetCellIdentifier"

class THJGProjectCachetController: THJGBaseController {
    
    //MARK: - UI Elements
    @IBOutlet weak var projectNameLabel: UILabel!
    @IBOutlet weak var startDateBtn: UIButton!
    @IBOutlet weak var endDateBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties
    var projectId: String!
    var projectName: String!
    lazy var cachetVM = THJGProjectCachetViewModel()
    //查询条件
    var startDate: String = ""
    var endDate: String = ""
    var curPage: Int = 1
    var beans: [ProjectCachetSectionHandledBean]! {
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
        NotificationCenter.default.addObserver(self, selector: #selector(requestNewDataSuccess(_:)), name: Notification.Name(THJG_NOTIFICATION_CACHET_NEWDATA_SUCCESS), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(requestNewDataFailure(_:)), name: Notification.Name(THJG_NOTIFICATION_PLATFORMINFO_NEW_DATA_FAILURE), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(requestMoreDataSuccess(_:)), name: Notification.Name(THJG_NOTIFICATION_CACHET_MOREDATA_SUCCESS), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(requestMoreDataFailure(_:)), name: Notification.Name(THJG_NOTIFICATION_CACHET_MOREDATA_FAILURE), object: nil)
        
        //注册全屏通知
        NotificationCenter.default.addObserver(self, selector: #selector(requestForFullScreen(_:)), name: Notification.Name(NOTIFICATION_VIDEO_REC_FULLSCREEN), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(requestForSmallScreen), name: Notification.Name(NOTIFICATION_VIDEO_REC_SMALLSCREEN), object: nil)
    }
     
}

//MARK: - METHODS
extension THJGProjectCachetController {
    
    //setup
    fileprivate func setup() {
        //设置导航栏标题
        navigationItem.title = "用章登记"
        
        //项目名称
        projectNameLabel.text = projectName
        
        //注册cell
        tableView.register(UINib(nibName: "THJGProjectCachetCell", bundle: nil), forCellReuseIdentifier: kProjectCachetCellIdentifier)
        
        //调整tableview布局
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0)
        
        //分页
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {[unowned self] in
            self.requestForNewData()
        })
        tableView.mj_header.beginRefreshing()
    }
    
    //send request for data
    fileprivate func requestForNewData() {
        curPage = 1
        tableView.mj_footer = nil
        cachetVM.requestForProjectCachetNewData(param: ["projectId": projectId, "pageNum": curPage, "pageSize": 20, "startDate": startDate, "endDate": endDate])
    }
    
    @objc func requestNewDataSuccess(_ notification: Notification) {
        //结束刷新
        tableView.mj_header.endRefreshing()
        //赋值
        let specBean = notification.object as! THJGSuccessBean
        let cachetBean = specBean.bean as! THJGProjectCachetBean
        beans = cachetVM.handleCachetData(cachetBean)
        if beans.isEmpty {
            //添加占位图
            DQSUtils.showPlaceholderImg(tableView, 45)
            //刷新空数据
            beans = [ProjectCachetSectionHandledBean]()
        } else {
            //删除占位图
            DQSUtils.hidePlaceholderImg(tableView)
            //处理分页
            if cachetBean.medalsTotal == 20 {
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
        cachetVM.requestForProjectCachetMoreData(param: ["projectId": projectId, "pageNum": curPage, "pageSize": 20, "startDate": startDate, "endDate": endDate])
    }
    
    @objc func requestMoreDataSuccess(_ notification: Notification) {
        //处理分页逻辑
        let specBean = notification.object as! THJGSuccessBean
        let cachetBean = specBean.bean as! THJGProjectCachetBean
        let sectionHanledBeans = cachetVM.handleCachetData(cachetBean)
        guard !sectionHanledBeans.isEmpty else {//没有更多数据
            (tableView.mj_footer as! MJRefreshAutoNormalFooter).endRefreshingWithNoMoreData()
            return
        }
        if cachetBean.medalsTotal < 20 {
            (tableView.mj_footer as! MJRefreshAutoNormalFooter).endRefreshingWithNoMoreData()
        } else {
            (tableView.mj_footer as! MJRefreshAutoNormalFooter).endRefreshing()
        }
        //处理数据
        var loadedBeans = sectionHanledBeans
        //处理最新的数据是否与之前的数据的重叠情形，并赋值数据源
        if beans.last!.useDate == loadedBeans.first!.useDate {//有重叠
            var lastBean = beans.removeLast()
            let loadBean = loadedBeans.removeFirst()
            for detailBean in loadBean.useDetails {
                lastBean.useDetails.append(detailBean)
            }
            beans.append(lastBean)
            beans += loadedBeans
        } else {//没有重叠
            beans += loadedBeans
        }
    }
    
    @objc func requestMoreDataFailure(_ notification: Notification) {
        //当前页递减
        curPage -= 1
        //结束底部刷新
        (tableView.mj_footer as! MJRefreshAutoNormalFooter).endRefreshing()
        //提示
        let specBean = notification.object as! THJGFailureBean
        DQSUtils.showToast(specBean.msg, view)
    }
    
    @objc func requestForFullScreen(_ notification: Notification) {
        let value = UIInterfaceOrientation.landscapeRight.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
        let specBean = notification.object as! String
        let fullView = THJGLocalVideoFullScreenView.showLocalVideoFullScreen()
        fullView.frame = UIScreen.main.bounds
        view.window?.addSubview(fullView)
        fullView.url = specBean
    }
    
    @objc func requestForSmallScreen() {
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
}

extension THJGProjectCachetController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        guard beans != nil, !beans.isEmpty else {
            return 0
        }
        return beans.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 40))
        headerView.backgroundColor = DQSUtils.rgbColor(242, 242, 243)
        let header = UILabel(frame: CGRect(x: 16, y: 0, width: SCREEN_WIDTH-32, height: 40))
        header.text = DQSUtils.showTime(interval: TimeInterval(beans[section].useDate/1000), timeFormate: "yyyy-MM-dd")
        header.font = UIFont.systemFont(ofSize: 14)
        header.backgroundColor = UIColor.clear
        headerView.addSubview(header)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beans[section].useDetails.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return beans[indexPath.section].useDetails[indexPath.row].cellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kProjectCachetCellIdentifier) as! THJGProjectCachetCell
        //判断当前对象是否是当前section中的最后一个
        let res = indexPath.row == beans[indexPath.section].useDetails.count - 1
        cell.reloadData(beans[indexPath.section].useDetails[indexPath.row].cellBean, isLastBean: res) { [unowned self] (imgBeans, curIndex) in
            guard !imgBeans.isEmpty else {
                return
            }
            let bean = imgBeans[curIndex ?? 0]
            if bean.isPdf {//pdf
                let request = URLRequest(url: URL(string: bean.imgUrl)!)
                let webVC = THJGWebController()
                webVC.request = request
                self.navigationController?.pushViewController(webVC, animated: true)
            } else if bean.isVideo {//本地视频
                //剔除pdf和图片
                var handledBeans = [THJGImgShowBean]()
                for showBean in imgBeans {
                    if showBean.isVideo {
                        handledBeans.append(showBean)
                    }
                }
                let handledIndex = (imgBeans.count == handledBeans.count) ? (curIndex ?? 0) : 0
                let imgShowView = THJGImageShowView.showImgView()
                imgShowView.frame = UIScreen.main.bounds
                imgShowView.reloadData(handledBeans, curIndex: handledIndex)
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

extension THJGProjectCachetController {
    
    //起始日期
    @IBAction func startDateBtnDidClicked(_ sender: UIButton) {
        
        let datePickerView = THJGDatePickerView.showDatePickerView()
        datePickerView.completeBlock = {
            [unowned self] result in
            self.startDateBtn.setTitle(result, for: .normal)
            self.startDate = result ?? ""
            (self.tableView.mj_header as! MJRefreshNormalHeader).beginRefreshing()
        }
        datePickerView.frame = UIScreen.main.bounds
        view.window?.addSubview(datePickerView)
    
    }
    
    //截止日期
    @IBAction func endDateBtnDidClicked(_ sender: UIButton) {
        
        let datePickerView = THJGDatePickerView.showDatePickerView()
        datePickerView.completeBlock = {
            [unowned self] result in
            self.endDateBtn.setTitle(result, for: .normal)
            self.endDate = result ?? ""
            (self.tableView.mj_header as! MJRefreshNormalHeader).beginRefreshing()
        }
        datePickerView.frame = UIScreen.main.bounds
        view.window?.addSubview(datePickerView)
    }
    
}
