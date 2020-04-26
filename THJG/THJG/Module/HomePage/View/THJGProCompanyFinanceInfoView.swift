/**
 * 企业信息-财务信息
 */

/* 财务信息 cell */
fileprivate let kProCompanyFinanceCellIdentifier = "proCompanyFinanceCellIdentifier"

import UIKit

class THJGProCompanyFinanceInfoView: UIView {
    
    @IBOutlet weak var tableView: UITableView!
    
    var bean: THJGProCompanyBean! {
        didSet {
            if bean.financeInfo.isEmpty {
                //添加占位图片
                DQSUtils.showPlaceholderImg(tableView)
            } else {
                //隐藏占位图片
                DQSUtils.hidePlaceholderImg(tableView)
            }
            tableView.reloadData()
        }
    }
    
    var financeBlock: THJGProDetailTabBlock!

    override func awakeFromNib() {
        super.awakeFromNib()
        //初始化
        setup()
    }
    
    func reloadData(bean:THJGProCompanyBean,
                    bloc: @escaping THJGProDetailTabBlock) {
        self.bean = bean
        financeBlock = bloc
    }
    
}

//MARK: - METHODS
extension THJGProCompanyFinanceInfoView {
    
    //初始化
    func setup() {
        //注册cell
        tableView.register(UINib(nibName: "THJGProCompanyFinanceCell", bundle: nil), forCellReuseIdentifier: kProCompanyFinanceCellIdentifier)
        //设置cell高度
        tableView.rowHeight = 155
    }
}

//MARK: - UITableViewDataSource, UITableViewDelegate
extension THJGProCompanyFinanceInfoView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if nil == bean {
            return 0
        }
        return bean.financeInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kProCompanyFinanceCellIdentifier) as! THJGProCompanyFinanceCell
        cell.reloadData(bean: bean.financeInfo[indexPath.row], index: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let financeBean = bean.financeInfo[indexPath.row]
        financeBlock(financeBean.resourceUrl, nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
