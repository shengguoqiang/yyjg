/**
 * 销售进度headerView
 */

import UIKit

class THJGProjectSellPlanSectionHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var blockNameLabel: UILabel!
    
    
    func reloadData(_ vm: THJGProjectSellPlanBlockViewModel)  {
        // 幢号
        blockNameLabel.text = "幢号：\(vm.blockNum)"
    }

}
