/**
 * 销售消息-计划与进度
 */

import UIKit

//cell 标识
fileprivate let kProjectSellPlanCellIdentifier = "projectSellPlanCellIdentifier"

class THJGProSellInfoPlanView: UIView {

    @IBOutlet weak var tableView: UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //注册cell
        tableView.register(UINib(nibName: "THJGProjectSellPlanCell", bundle: nil), forCellReuseIdentifier: kProjectSellPlanCellIdentifier)
    }
    
    var beans: [ProjectSellPlanHandledBean]! {
        didSet {
            tableView.reloadData()
        }
    }
    
}

extension THJGProSellInfoPlanView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard beans != nil else {
            return 0
        }
        return beans.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return beans[indexPath.row].cellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kProjectSellPlanCellIdentifier) as! THJGProjectSellPlanCell
        cell.reloadData(beans[indexPath.row])
        return cell
    }
}


