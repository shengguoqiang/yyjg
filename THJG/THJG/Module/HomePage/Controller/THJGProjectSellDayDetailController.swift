/**
 * 每日销售详情
 */

import UIKit

/**
 * header复用标识
 */
fileprivate let kTHJGProjectSellDayDetailHeaderViewIdentifier = "THJGProjectSellDayDetailHeaderView"

/**
 * cell复用标识
 */
fileprivate let kTHJGProjectSellDayDetailCellIdentifier = "THJGProjectSellDayDetailCell"

class THJGProjectSellDayDetailController: THJGBaseController {
    
    //MARK: UI元素
    @IBOutlet weak var headerView: THJGProjectSellDayDetailTabHeaderView!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: 数据属性
    /**
     * 项目ID
     */
    var projectId: String!
    /**
     * 项目名称
     */
    var projectName: String!
    /**
     * dataCtl
     */
    fileprivate lazy var dataCtl = THJGProjectSellDayDetailDataController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 初始化设置
        setupConfig()
        
        // 请求数据
        requestForData()
    }

}

//MARK: - 类中方法
extension THJGProjectSellDayDetailController {
    
    //MARK: 初始化设置
    fileprivate func setupConfig() {
        navigationItem.title = "销售日期明细"
        
        // 设置滚动视图
        tableView.tableHeaderView = headerView
        tableView.register(UINib(nibName: "THJGProjectSellDayDetailHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: kTHJGProjectSellDayDetailHeaderViewIdentifier)
        
        tableView.register(UINib(nibName: "THJGProjectSellDayDetailCell", bundle: nil), forCellReuseIdentifier: kTHJGProjectSellDayDetailCellIdentifier)
        tableView.rowHeight = 35
    }
    
    //MARK: 请求数据
    fileprivate func requestForData() {
        DQSUtils.showLoading(view)
        dataCtl.requestForData(["projectId": projectId], { [weak self] (_, _) in
            guard self != nil else {
                return
            }
            // 隐藏loading
            DQSUtils.hideLoading(self!.view)
            // 刷新列表
            self!.tableView.isHidden = false
            self!.headerView.reloadData(self!.projectName, self!.dataCtl.detailBean)
            self!.tableView.reloadData()
        }, nil)
    }
    
}

//MARK: 滚动视图数据源
extension THJGProjectSellDayDetailController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard dataCtl.detailBean != nil else {
            return 0
        }
        return dataCtl.detailBean.projectSellDailyDetails.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataCtl.detailBean.projectSellDailyDetails[section].isSelected ? dataCtl.detailBean.projectSellDailyDetails[section].proSellDetails.count : 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: kTHJGProjectSellDayDetailHeaderViewIdentifier) as! THJGProjectSellDayDetailHeaderView
        headerView.reloadData(dataCtl.detailBean.projectSellDailyDetails[section])
        headerView.clickAction = { [weak self] in
            guard self != nil else {
                return
            }
            // 修改数据源
            self!.dataCtl.detailBean.projectSellDailyDetails[section].isSelected = !self!.dataCtl.detailBean.projectSellDailyDetails[section].isSelected
            // 刷新列表
            tableView.reloadData()
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kTHJGProjectSellDayDetailCellIdentifier) as! THJGProjectSellDayDetailCell
        cell.reloadData(dataCtl.detailBean.projectSellDailyDetails[indexPath.section].proSellDetails[indexPath.row])
        return cell
    }
    
}

//MARK: - 顶部视图
class THJGProjectSellDayDetailTabHeaderView: UIView {
    
    @IBOutlet weak var projectNameLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!

    func reloadData(_ projectName: String,
                    _ bean: THJGProjectSellDayDetailBean) {
        // 项目名称
        projectNameLabel.text = projectName
        // 销售量
        amountLabel.text = "\(bean.projectSellSoldTotal)"
        // 销售金额
        moneyLabel.text = "\(DQSUtils.showNumWithComma(num: DQSUtils.showDoubleNum(sourceDouble: bean.projectSellDfinalAmountTotal/10000, floatNum: 2, showStyle: .showStyleNoZero)))"
    }
    
}
