/**
 * 销售消息-计划与进度
 */

import UIKit

// header复用标识
fileprivate let kTHJGProjectSellPlanSectionHeaderViewIdentifier = "THJGProjectSellPlanSectionHeaderView"
//cell 标识
fileprivate let kTHJGProjectSellPlanCellIdentifier = "THJGProjectSellPlanCell"

class THJGProSellInfoPlanView: UIView {

    @IBOutlet weak var tableView: UITableView!
    
    /**
     * 数据源
     */
    var vm: THJGProjectSellPlanViewModel! {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // 初始化设置
        setupConfig()
    }
    
    func reloadData(_ vm: THJGProjectSellPlanViewModel) {
        self.vm = vm
    }
    
}

//MARK: - 类中方法
extension THJGProSellInfoPlanView {
    
    //MARK: 初始化方法
    fileprivate func setupConfig() {
        // 设置滚动视图
        tableView.register(UINib(nibName: "THJGProjectSellPlanSectionHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: kTHJGProjectSellPlanSectionHeaderViewIdentifier)
        //注册cell
        tableView.register(UINib(nibName: "THJGProjectSellPlanCell", bundle: nil), forCellReuseIdentifier: kTHJGProjectSellPlanCellIdentifier)
    }
    
}

extension THJGProSellInfoPlanView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard vm != nil else {
            return 0
        }
        return vm.plans.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.plans[section].blockPlans.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return vm.plans[indexPath.section].blockPlans[indexPath.row].cellHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: kTHJGProjectSellPlanSectionHeaderViewIdentifier) as! THJGProjectSellPlanSectionHeaderView
        headerView.reloadData(vm.plans[section])
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kTHJGProjectSellPlanCellIdentifier) as! THJGProjectSellPlanCell
        cell.reloadData(vm.plans[indexPath.section].blockPlans[indexPath.row], indexPath.row == vm.plans[indexPath.section].blockPlans.count - 1)
        return cell
    }
    
    
}


