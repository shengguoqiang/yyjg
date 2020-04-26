/**
 * 重要时间节点考核
 */

import UIKit

//cell identifier
fileprivate let kProTimesCellIdentifier = "proTimesCellIdentifier"

class THJGProjectTimesController: THJGBaseController {
    
    //MARK: - UI Elements
    @IBOutlet weak var projectNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties
    var projectId: String! {
        didSet {
            requestForData()
        }
    }
    var proTimesBean: THJGProjectTimesBean!
    lazy var proTimesHandledBeans = [ProTimesHandledBean]()
    lazy var proTimesVM = THJGProjectTimesViewModel()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        //setup
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //注册网络请求回调通知
        NotificationCenter.default.addObserver(self, selector: #selector(requestSuccess(_:)), name: Notification.Name(THJG_NOTIFICATION_PROJECTTIMES_SUCCESS), object: nil)
    }

}

//MARK: - METHODS
extension THJGProjectTimesController {
    
    //setup
    func setup() {
        //设置导航栏标题
        navigationItem.title = "节点考核"
        
        //register the tableView cell
        tableView.register(UINib(nibName: "THJGProjectTimesCell", bundle: nil), forCellReuseIdentifier: kProTimesCellIdentifier)
    }
    
    //send request for data
    /**
     * @param projectId 项目ID
     * @param pageNum   页码
     * @param pageSize  每页条数
     */
    func requestForData() {
        DQSUtils.showLoading(view)
        proTimesVM.requestForProTimesData(param: ["projectId": projectId])
    }
    
    @objc override func requestSuccess(_ notification: Notification) {
        super.requestSuccess(notification)
        //获取数据
        let specBean = notification.object as! THJGSuccessBean
        proTimesBean = (specBean.bean as! THJGProjectTimesBean)
        //project name
        projectNameLabel.text = proTimesBean.proName
        //project list
        proTimesHandledBeans = proTimesVM.handleData(proTimesBean)
        if proTimesHandledBeans.isEmpty {
            //添加占位图
            DQSUtils.showPlaceholderImg(tableView)
        } else {
            //删除占位图
            DQSUtils.hidePlaceholderImg(tableView)
            //刷新页面
            refreshUI()
        }
    }
    
    //describe the UI
    func refreshUI() {
        //tableView
        tableView.reloadData()
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension THJGProjectTimesController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard !proTimesHandledBeans.isEmpty else {
            return 0
        }
        return proTimesHandledBeans.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return proTimesHandledBeans[indexPath.row].cellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kProTimesCellIdentifier) as! THJGProjectTimesCell
        cell.reloadData(proTimesHandledBeans[indexPath.row].cellBean)
        return cell
    }
}
