/**
 * 市场情况控制器
 */

/* cell标识 */
fileprivate let kProMarketInfoCellIdentifier = "proMarketInfoCellIdentifier"

import UIKit

class THJGProMarketInfoController: THJGBaseController {
    
    //MARK: - UI Elements
    @IBOutlet weak var projectNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties
    var marketVM = THJGProMarketInfoViewModel()
    var projectId: String!
    var beans: [THJGProMarketHandledInfoBean]! {
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
        /* 请求成功通知 */
        NotificationCenter.default.addObserver(self, selector: #selector(requestSuccess(_:)), name: NSNotification.Name(THJG_NOTIFICATION_MARKETINFO_SUCCESS), object: nil)
        
        //请求数据
        requestForData()
    }

}

//MARK: - METHODS
extension THJGProMarketInfoController {
    
    //初始化
    func setup() {
        
        //设置导航栏标题
        navigationItem.title = "市场信息"
        
        //注册cell
        tableView.register(UINib(nibName: "THJGProMarketInfoCell", bundle: nil), forCellReuseIdentifier: kProMarketInfoCellIdentifier)
    }
    
    func requestForData() {
        DQSUtils.showLoading(view)
        marketVM.requestForProjectMarketInfoData(param: ["projectId": projectId])
    }
    
    override func requestSuccess(_ notification: Notification) {
        super.requestSuccess(notification)
        let specBean = notification.object as! THJGSuccessBean
        let marketInfoBean = specBean.bean as! THJGProMarketInfoBean
        
        //更新页面
        projectNameLabel.text = marketInfoBean.projectName
        beans = marketVM.handleData(bean: marketInfoBean)
        if beans.isEmpty {
           //添加占位图
            DQSUtils.showPlaceholderImg(tableView)
        } else {
            //删除占位图
            DQSUtils.hidePlaceholderImg(tableView)
        }
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension THJGProMarketInfoController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if nil == beans {
            return 0
        }
        return beans.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return beans[indexPath.row].cellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kProMarketInfoCellIdentifier) as! THJGProMarketInfoCell
        cell.bean = beans[indexPath.row]
        return cell
    }
}
