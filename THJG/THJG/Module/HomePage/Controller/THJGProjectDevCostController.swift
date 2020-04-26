/**
 * 项目开发成本及费用
 */

import UIKit

//header identifier
fileprivate let kProDevCostBigTypeHeaderViewIdentifier = "proDevCostBigTypeHeaderViewIdentifier"
fileprivate let kProDevCostSmallTypeHeaderViewIdentifier = "proDevCostSmallTypeHeaderViewIdentifier"

//detail cell identifier
fileprivate let kProDevCostDetailCellIdentifier = "proDevCostDetailCellIdentifier"

class THJGProjectDevCostController: THJGBaseController {
    
    //MARK: - UI Elements
    @IBOutlet weak var tableHeaderView: THJGProDevCostTopView!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties
    var projectId: String! {
        didSet {
            requestForData(projectId)
        }
    }
    lazy var proDevCostVM = THJGProjectDevCostViewModel()
    var proDevCostBean: THJGProjectDevCostBean!
    var proDevCostHanldedBeans: [ProDevCostHandledBean]!
    var curSelectDetailSection: Int!
    var lastShowDetailSection: Int?

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        //setup
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //注册网络请求回调通知
        NotificationCenter.default.addObserver(self, selector: #selector(requestDevCostSuccess(_:)), name: Notification.Name(THJG_NOTIFICATION_DEVCOST_SUCCESS), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(requestDevCostDetailSuccess(_:)), name: Notification.Name(THJG_NOTIFICATION_DEVCOST_DETAIL_SUCCESS), object: nil)
    }

}

//MARK: - METHODS
extension THJGProjectDevCostController {
    
    //setup
    func setup() {
        //设置导航栏标题
        navigationItem.title = "成本费用"
        
        //set the table headerView
        tableView.tableHeaderView = tableHeaderView
        
        //tableView reigster the headerView
        tableView.register(UINib(nibName: "THJGProDevCostBigTypeHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: kProDevCostBigTypeHeaderViewIdentifier)
        
        tableView.register(UINib(nibName: "THJGProDevCostSmallTypeHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: kProDevCostSmallTypeHeaderViewIdentifier)
        
        //tableView register the cell
        tableView.register(UINib(nibName: "THJGProjectDevCostDetailCell", bundle: nil), forCellReuseIdentifier: kProDevCostDetailCellIdentifier)
        
        //调整滚动视图内部距离
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
    }
    
    //send the request for data
    func requestForData(_ projectId: String) {
        DQSUtils.showLoading(view)
        proDevCostVM.requestForProDevCostData(param: ["projectId": projectId])
    }
    
    @objc func requestDevCostSuccess(_ notification: Notification) {
        DQSUtils.hideLoading(view)
        //获取数据
        let specBean = notification.object as! THJGSuccessBean
        proDevCostBean = (specBean.bean as! THJGProjectDevCostBean)
        proDevCostHanldedBeans = proDevCostVM.handleDevCostData(proDevCostBean)
        if proDevCostHanldedBeans.isEmpty {
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
        //headerView
        tableHeaderView.reloadData(proDevCostBean)
        
        //tableView
        tableView.reloadData()
    }
    
    @objc func requestDevCostDetailSuccess(_ notification: Notification) {
        DQSUtils.hideLoading(view)
        let beans = notification.object as! [ProDevCostDetailBean]
        guard !beans.isEmpty else {
            return
        }
        //展开当前选中明细
        proDevCostHanldedBeans[curSelectDetailSection].isSelected = (true, beans)
        //收起之前明细
        if let lastShowSection = lastShowDetailSection {
            proDevCostHanldedBeans[lastShowSection].isSelected = (false, nil)
            //刷新table的指定section
            tableView.reloadSections([curSelectDetailSection, lastShowSection], with: .none)
        } else {
            //刷新table的指定section
            tableView.reloadSections([curSelectDetailSection], with: .none)
        }
        //记录当前选中明细
        lastShowDetailSection = curSelectDetailSection
    }
    
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension THJGProjectDevCostController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        guard proDevCostHanldedBeans != nil else {
            return 0
        }
        return proDevCostHanldedBeans.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return proDevCostHanldedBeans[section].isSelected.1?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return proDevCostHanldedBeans[section].isHeader.0 ? 90 : 45
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let bean = proDevCostHanldedBeans[section]
        var headerView: THJGProDevCostHeaderViewProtocol!
        if bean.isHeader.0 {//大类标题
            headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: kProDevCostBigTypeHeaderViewIdentifier) as! THJGProDevCostBigTypeHeaderView
        } else { //小类标题
            headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: kProDevCostSmallTypeHeaderViewIdentifier) as! THJGProDevCostSmallTypeHeaderView
        }
        headerView.reloadData(bean) {
            [unowned self] in
            if !bean.isSelected.0 {//展示明细
                self.proDevCostVM.requestForProDevCostDetailData(param: ["projectId": self.projectId, "costDetailId": bean.smallBean.smallTypeId])
                self.curSelectDetailSection = section
            } else {//隐藏明细
                //收起当前明细
                self.proDevCostHanldedBeans[section].isSelected = (false, nil)
                //刷新指定section
                tableView.reloadSections([section], with: .none)
                //取消当年选中明细
                self.lastShowDetailSection = nil
            }
        }
        return headerView as? UIView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kProDevCostDetailCellIdentifier) as! THJGProjectDevCostDetailCell
         cell.reloadData(proDevCostHanldedBeans[indexPath.section].isSelected.1![indexPath.row], index: indexPath.row, totalIndex: proDevCostHanldedBeans[indexPath.section].isSelected.1!.count-1)
        return cell
    }
}
