/**
 * 竞品楼盘详情
 */

import UIKit

//cell 标识
fileprivate let kProjectCompetionDetialCellIdentifier = "projectCompetionDetialCellIdentifier"

class THJGProjectCompetionDetailView: UIView {

    @IBOutlet weak var tableView: UITableView!
    
    var beans: [ProjectSellCompetionDetailBean]! {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //注册cell
        tableView.register( UINib(nibName: "THJGProjectCompetionDetailCell", bundle: nil), forCellReuseIdentifier: kProjectCompetionDetialCellIdentifier)
    }

}

extension THJGProjectCompetionDetailView: UITableViewDelegate, UITableViewDataSource {
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: kProjectCompetionDetialCellIdentifier) as! THJGProjectCompetionDetailCell
        cell.bean = beans[indexPath.row]
        return cell
    }
}
