/**
 * 销售详情-销售明细view
 */
import UIKit

//header 标识
fileprivate let kProjectSellDetailHeaderIdentifier = "kProjectSellDetailHeaderIdentifier"

//cell 标识
fileprivate let kProjectSellDetailBlockCellIdentifier = "projectSellDetailBlockCellIdentifier"

protocol THJGProSellInfoDetailViewDelete {
    //查看室销售详情
    func checkRoomDetail(_ bean: ProjectBlockSellDetailBean)
}

class THJGProSellInfoDetailView: UIView {
    
    @IBOutlet weak var tableView: UITableView!
    
    lazy var sellInfoVM = THJGProjectSellInfoViewModel()
    var curSelectSection: Int = 0
    var lastSelectedSection: Int?
    var detailViewDelegate: THJGProSellInfoDetailViewDelete?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //注册header
        tableView.register(UINib(nibName: "THJGProjectSellInfoDetailSectionHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: kProjectSellDetailHeaderIdentifier)
        
        //注册cell
        tableView.register(UINib(nibName: "THJGProjectSellDetailBlockCell", bundle: nil), forCellReuseIdentifier: kProjectSellDetailBlockCellIdentifier)
        
        //设置行高
        tableView.rowHeight = 45
        
        //调整滚动视图内部距离
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        
        //设置预计高度
        tableView.estimatedRowHeight = 45
        tableView.estimatedSectionHeaderHeight = 45
    }

    var beans = [ProjectSellDetailHandledBean]()
    
    func reloadData(_ beans: [ProjectSellDetailHandledBean]) {
        self.beans = beans
        lastSelectedSection = nil
        tableView.reloadData()
    }

}

extension THJGProSellInfoDetailView {
    
    @objc func requestSuccess(_ notification: Notification) {
        //注销通知
        NotificationCenter.default.removeObserver(self)
        
        DQSUtils.hideLoading(self)
        let specBean = notification.object as! THJGSuccessBean
        let detailBean = specBean.bean as! THJGProjectBlockSellDetailBean
        if detailBean.blockDetails.count > 0, beans.count > 0 {
            var details = detailBean.blockDetails
            details.insert(ProjectBlockSellDetailBean(projectId: "", blockNum: "", blockUnit: "", unitRoom: "", roomSquare: 0, roomSellStatus: 0), at: 0)
            beans[curSelectSection].isSelected = (true, details)
            if lastSelectedSection != nil {//之前有展开明细
                beans[lastSelectedSection!].isSelected = (false, nil)
                //tableView.reloadSections([lastSelectedSection!, curSelectSection], with: .automatic)
                tableView.reloadData()
            } else {//之前无展开明细
                //tableView.reloadSections([curSelectSection], with: .automatic)
                tableView.reloadData()
            }
            lastSelectedSection = curSelectSection
        }
    }
}

extension THJGProSellInfoDetailView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return beans.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beans[section].isSelected.1?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: kProjectSellDetailHeaderIdentifier) as! THJGProjectSellInfoDetailSectionHeaderView
        let bean = beans[section]
        header.reloadData(bean) {
            [unowned self] in
            if !bean.isSelected.0 {//展开明细
                //注销通知
                NotificationCenter.default.removeObserver(self)
                //注册幢明细网络请求通知
                NotificationCenter.default.addObserver(self, selector: #selector(self.requestSuccess(_:)), name: Notification.Name(THJG_NOTIFICATION_SELLINFO_BLOCK_DETAIL_SUCCESS), object: nil)
                
                DQSUtils.showLoading(self)
                self.curSelectSection = section
                self.sellInfoVM.requestForProjectBlockSellDetailData(param: ["projectId": bean.headerBean.projectId, "projectBlock": bean.headerBean.proBlock])
            } else {//收起明细
                self.beans[section].isSelected = (false, nil)
                //self.tableView.reloadSections([section], with: .automatic)
                self.tableView.reloadData()
                self.lastSelectedSection = nil
            }
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kProjectSellDetailBlockCellIdentifier) as! THJGProjectSellDetailBlockCell
        cell.reloadData(beans[indexPath.section].isSelected.1![indexPath.row], index: indexPath.row, totalIndex: beans[indexPath.section].isSelected.1!.count-1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bean = beans[indexPath.section].isSelected.1![indexPath.row]
        detailViewDelegate?.checkRoomDetail(bean)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
