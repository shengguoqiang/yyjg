/**
 * 资金信息-合同台账
 */

import UIKit

//header 标识
fileprivate let kProjectContractHeaderIdentifier = "projectContractHeaderIdentifier"

class THJGFundInfoContractView: UIView {

    @IBOutlet weak var tableView: UITableView!
    
    var beans: [ProContractHandledBean]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //注册header
        tableView.register(UINib(nibName: "THJGProjectContractHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: kProjectContractHeaderIdentifier)
    }
    
}

//MARK: - METHODS
extension THJGFundInfoContractView {
    //加载第一页数据
    func reloadNewData(_ newBeans: [ProContractHandledBean]) {
        //赋值数据源
        beans = newBeans
        tableView.reloadData()
    }
    
    //加载更多数据
    func reloadMoreData(_ moreBeans: [ProContractHandledBean]) {
        //赋值数据源
        beans += moreBeans
        //刷新视图
        tableView.reloadData()
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension THJGFundInfoContractView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard beans != nil, !beans.isEmpty else {
            return 0
        }
        return beans.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: kProjectContractHeaderIdentifier) as! THJGProjectContractHeaderView
        header.bean = beans[section].headerBean
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell(style: .default, reuseIdentifier: nil)
    }
    
}
