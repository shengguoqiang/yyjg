/**
 * 合同台账付款明细
 */

import UIKit

//cell 标识
fileprivate let kProContractDetailAppointCellIdentifier = "proContractDetailAppointCellIdentifier"
fileprivate let kProContractDetailActualCellIdentifier = "proContractDetailActualCellIdentifier"

class THJGProjectContractDetailController: THJGBaseController {
    
    //MARK: - UI Elements
    @IBOutlet var tableHeaderView: UIView!
    @IBOutlet weak var conNameLabel: UILabel!
    @IBOutlet weak var contractNameTrailing: NSLayoutConstraint!
    
    @IBOutlet weak var checkContractBtn: UIButton!
    @IBOutlet weak var departNameLabel: UILabel!
    @IBOutlet weak var dealAmountLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties
    var contractBean: ProjectContractBean! {
        didSet {
            //加载数据
            requestForData()
        }
    }
    lazy var detailVM = THJGProjectContractDetailViewModel()
    var beans: [ProjectContractDetailHandledBean]! {
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
        NotificationCenter.default.addObserver(self, selector: #selector(requestSuccess(_:)), name: Notification.Name(THJG_NOTIFICATION_CONTRACT_DETAIL_SUCCESS), object: nil)
    }
    
}

//MARK: - METHODS
extension THJGProjectContractDetailController {
    
    //setup
    func setup() {
        //设置导航栏标题
        navigationItem.title = "合同付款信息"
        
        //设置滚动视图顶部视图
        tableHeaderView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 190)
        tableView.tableHeaderView = tableHeaderView
        
        //注册cell
        tableView.register(UINib(nibName: "THJGConDetailAppointInfoCell", bundle: nil), forCellReuseIdentifier: kProContractDetailAppointCellIdentifier)
        tableView.register(UINib(nibName: "THJGConDetailActualInfoCell", bundle: nil), forCellReuseIdentifier: kProContractDetailActualCellIdentifier)
    }
    
    //send request for data
    func requestForData() {
        DQSUtils.showLoading(view)
        detailVM.requestForContractDetailData(param: ["projectId": contractBean.conProjectId, "departmentName": contractBean.conDepartmentName, "contractName": contractBean.conName])
    }
    
    @objc override func requestSuccess(_ notification: Notification) {
        super.requestSuccess(notification)
        //刷新顶部
        refreshUI()
        
        //刷新底部列表
        let specBean = notification.object as! THJGSuccessBean
        beans = detailVM.handleContractDetailData(detailBean: specBean.bean as! THJGProjectContractDetailBean)
    }
    
    //describe UI
    func refreshUI()  {
        //刷新顶部视图
        conNameLabel.text = contractBean.conName
        checkContractBtn.isHidden = DQSUtils.isBlank(contractBean.conContentUrl)
        contractNameTrailing.constant = checkContractBtn.isHidden ? 16 : 60
        departNameLabel.text = contractBean.conDepartmentName
        dealAmountLabel.text = "\(DQSUtils.showNumWithComma(num: DQSUtils.showDoubleNum(sourceDouble: contractBean.conSum, floatNum: 2, showStyle: .showStyleNoZero)))万元"
    }
    
    //MARK: - 查看合同事件监听
    @IBAction func checkContractDidClicked(_ sender: UIButton) {
        let request = URLRequest(url: URL(string: contractBean.conContentUrl)!)
        let webVC = THJGWebController()
        webVC.request = request
        navigationController?.pushViewController(webVC, animated: true)
    }
    
}

extension THJGProjectContractDetailController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        guard beans != nil else {
            return 0
        }
        return beans.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beans[section].details.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if beans[indexPath.section].detailName == "约定付款信息" {
            return (beans[indexPath.section].details[indexPath.row] as! ProjectContractAppointDetailBean).cellHeight
        }
        return 45
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 65))
        headerView.backgroundColor = UIColor.white
        //灰色分割线
        let seperator = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 10))
        seperator.backgroundColor = DQSUtils.rgbColor(242, 242, 243)
        headerView.addSubview(seperator)
        
        //图标
        let icon = UIImageView(image: UIImage(named: "project_contract_pay"))
        icon.frame = CGRect(x: 16, y: 25, width: icon.bounds.width, height: icon.bounds.height)
        headerView.addSubview(icon)
        
        //标题
        let header = UILabel(frame: CGRect(x: 50, y: 10, width: SCREEN_WIDTH-50, height: 54))
        header.textColor = DQSUtils.rgbColor(33, 33, 33)
        header.font = UIFont.boldSystemFont(ofSize: 16)
        header.text = beans[section].detailName
        headerView.addSubview(header)
        
        //分割线
        let sep = UIView(frame: CGRect(x: 0, y: 64, width: SCREEN_WIDTH, height: 1))
        sep.backgroundColor = DQSUtils.rgbColor(242, 242, 243)
        headerView.addSubview(sep)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let bean = beans[indexPath.section]
        if bean.detailName == "约定付款信息" {
            let cell = tableView.dequeueReusableCell(withIdentifier: kProContractDetailAppointCellIdentifier) as! THJGConDetailAppointInfoCell
            let detailbean = bean.details[indexPath.row] as! ProjectContractAppointDetailBean
            cell.reloadData(detailbean, curIndex: indexPath.row, totalIndex: bean.details.count - 1)
            return cell
        } else {//实际付款信息
           let cell = tableView.dequeueReusableCell(withIdentifier: kProContractDetailActualCellIdentifier) as! THJGConDetailActualInfoCell
            let detailbean = bean.details[indexPath.row] as! ProjectContractActualDetailBean
            cell.reloadData(detailbean, curIndex: indexPath.row, totalIndex: bean.details.count - 1)
            return cell
        }
    }
}
