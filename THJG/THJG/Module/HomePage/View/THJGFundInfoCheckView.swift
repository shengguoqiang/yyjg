/**
 * 资金信息-用款登记
 */

import UIKit

//cell 标识
fileprivate let kProFundInfoCheckCellIdentifier = "proFundInfoCheckCellIdentifier"

protocol THJGFundInfoCheckViewDelegate {
    func checkPdf(_ bean: THJGImgShowBean)
}

class THJGFundInfoCheckView: UIView {
    
    @IBOutlet weak var tableView: UITableView!
    
    var infoDelegate: THJGFundInfoCheckViewDelegate?
    var beans: [ProFundInfoCheckHandledBean]!
    var lastSelectedIndexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //注册cell
        tableView.register(UINib(nibName: "THJGProjectFundCheckCell", bundle: nil), forCellReuseIdentifier: kProFundInfoCheckCellIdentifier)
        
        //调整tableview内部滚动距离
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
        
        //设置预计高度
        tableView.estimatedRowHeight = 200
        tableView.estimatedSectionHeaderHeight = 40
    }
    
}

//MARK: - METHODS
extension THJGFundInfoCheckView {
    //加载第一页数据
    func reloadNewData(_ newBeans: [ProFundInfoCheckHandledBean]) {
        //赋值数据源
        beans = newBeans
        //将之前选中状态置空
        lastSelectedIndexPath = nil
        //刷新视图
        tableView.reloadData()
    }
    
    //加载更多数据
    func reloadMoreData(_ moreBeans: [ProFundInfoCheckHandledBean]) {
        var loadedBeans = moreBeans
        //处理最新的数据是否与之前的数据的重叠情形，并赋值数据源
        if beans.last!.payTime == loadedBeans.first!.payTime {//有重叠
            var lastBean = beans.removeLast()
            let loadBean = loadedBeans.removeFirst()
            for detailBean in loadBean.payDetails {
                lastBean.payDetails.append(detailBean)
            }
            beans.append(lastBean)
            beans += loadedBeans
        } else {//没有重叠
            beans += loadedBeans
        }
        //刷新视图
        tableView.reloadData()
    }

}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension THJGFundInfoCheckView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard beans != nil, !beans.isEmpty else {
            return 0
        }
        return beans.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beans[section].payDetails.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let detailBean = beans[indexPath.section].payDetails[indexPath.row]
        return detailBean.isSelected ? detailBean.cellHeight : 190
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 40))
        headerView.backgroundColor = DQSUtils.rgbColor(242, 242, 243)
        let header = UILabel(frame: CGRect(x: 15, y: 0, width: SCREEN_WIDTH-30, height: 40))
        header.textColor = DQSUtils.rgbColor(33, 33, 33)
        header.font = UIFont.systemFont(ofSize: 14)
        header.text = DQSUtils.showTime(interval: TimeInterval(beans[section].payTime/1000), timeFormate: "yyyy-MM-dd")
        headerView.addSubview(header)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kProFundInfoCheckCellIdentifier) as! THJGProjectFundCheckCell
        let res = indexPath.row == beans[indexPath.section].payDetails.count - 1
        cell.reloadData(beans[indexPath.section].payDetails[indexPath.row], res) {[unowned self] (imgBeans, curIndex) in
            let bean = imgBeans[curIndex ?? 0]
            if bean.isPdf {//pdf
                self.infoDelegate?.checkPdf(bean)
            } else if bean.isVideo {//本地视频
                //剔除pdf和图片
                var handledBeans = [THJGImgShowBean]()
                for showBean in imgBeans {
                    if showBean.isVideo {
                        handledBeans.append(showBean)
                    }
                }
                let handledIndex = (imgBeans.count == handledBeans.count) ? (curIndex ?? 0) : 0
                let imgShowView = THJGImageShowView.showImgView()
                imgShowView.frame = UIScreen.main.bounds
                imgShowView.reloadData(handledBeans, curIndex: handledIndex/*, showType: .imgAndLocalVideo*/)
                self.window?.addSubview(imgShowView)
            } else {//图片
                let imgShowView = THJGBigImgShowView.showBigImageView()
                imgShowView.frame = UIScreen.main.bounds
                imgShowView.imageUrl = bean.imgUrl
                self.window?.addSubview(imgShowView)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        beans[indexPath.section].payDetails[indexPath.row].isSelected = !beans[indexPath.section].payDetails[indexPath.row].isSelected
        if lastSelectedIndexPath != nil, lastSelectedIndexPath! != indexPath {
            beans[lastSelectedIndexPath!.section].payDetails[lastSelectedIndexPath!.row].isSelected = false
//            tableView.reloadSections([lastSelectedIndexPath!.section, indexPath.section], with: .automatic)
            tableView.reloadData()
        } else {
//            tableView.reloadSections([indexPath.section], with: .none)
            tableView.reloadData()
        }
        lastSelectedIndexPath = indexPath
    }
    
}
