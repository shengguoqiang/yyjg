/**
 * 项目销售信息-销售详情-室销售详情
 */

import UIKit

//cell 标识
fileprivate let kProjectRoomSellDetailTypeOneCellIdentifier = "projectRoomSellDetailTypeOneCellIdentifier"
fileprivate let kProjectRoomSellDetailTypeTwoCellIdentifier = "projectRoomSellDetailTypeTwoCellIdentifier"

class THJGProjectRoomSellDetailController: THJGBaseController {
    
    //MARK: - UI Elements
    @IBOutlet weak var projectNameLabel: UILabel!
    @IBOutlet weak var blockLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties
    var params: (String, String, String?, String)! {
        didSet {
            requestForData()
        }
    }
    lazy var roomDetailVM = THJGProjectSellInfoViewModel()
    var detailBean: THJGProjectRoomSellDetailBean! {
        didSet {
            tableView.reloadData()
        }
    }
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        //setup
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //注册网络请求回调通知
        NotificationCenter.default.addObserver(self, selector: #selector(requestSuccess(_:)), name: Notification.Name(THJG_NOTIFICATION_SELLINFO_ROOM_DETAIL_SUCCESS), object: nil)
    }

}

//MARK: - METHODS
extension THJGProjectRoomSellDetailController {
    
    //MARK: - setup
    fileprivate func setup() {
        //设置导航栏标题
        navigationItem.title = "销售信息"
        
        //注册cell
        tableView.register( UINib(nibName: "THJGProjectRoomDetailTypeOneCell", bundle: nil), forCellReuseIdentifier: kProjectRoomSellDetailTypeOneCellIdentifier)
        tableView.register(UINib(nibName: "THJGProjectRoomDetailTypeTwoCell", bundle: nil), forCellReuseIdentifier: kProjectRoomSellDetailTypeTwoCellIdentifier)
    }
    
    //MARK: - request for data
    fileprivate func requestForData() {
        DQSUtils.showLoading(view)
        roomDetailVM.requestForProjectRoomSellDetailData(param: ["projectId": params.0, "projectBlock": params.1, "blockUnit": params.2 ?? "", "unitRoom": params.3])
    }
    
    @objc override func requestSuccess(_ notification: Notification) {
        super.requestSuccess(notification)
        //获取数据
        let specBean = notification.object as! THJGSuccessBean
        detailBean = (specBean.bean as! THJGProjectRoomSellDetailBean)
        
        //加载顶部信息
        projectNameLabel.text = detailBean.projectName
        if DQSUtils.isNotBlank(params.2) {
            blockLabel.text = "\(params.1)幢\(params.2!)单元\(params.3)室"
        } else {
            blockLabel.text = "\(params.1)幢\(params.3)室"
        }
    }
    
}

extension THJGProjectRoomSellDetailController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        guard detailBean != nil else {
            return 0
        }
        return detailBean.resList.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 45))
        headerView.backgroundColor = DQSUtils.rgbColor(242, 242, 243)
        let header = UILabel(frame: CGRect(x: 15, y: 0, width: SCREEN_WIDTH-30, height: 45))
        header.text = detailBean.resList[section].typeName
        header.font = UIFont.systemFont(ofSize: 13)
        header.backgroundColor = UIColor.clear
        headerView.addSubview(header)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailBean.resList[section].infos.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let bean = detailBean.resList[indexPath.section].infos[indexPath.row]
        if bean.infoTitle == "备注" {
           let textHeight = DQSUtils.heightForText(text: (bean.infoContent as! String), fixedWidth: SCREEN_WIDTH-30, fixedFont: UIFont.systemFont(ofSize: 14)) + 40
            return textHeight
        }
        return 45
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let bean = detailBean.resList[indexPath.section].infos[indexPath.row]
        if bean.infoTitle == "备注" {
           let cell = tableView.dequeueReusableCell(withIdentifier: kProjectRoomSellDetailTypeTwoCellIdentifier) as! THJGProjectRoomDetailTypeTwoCell
            cell.bean = bean
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: kProjectRoomSellDetailTypeOneCellIdentifier) as! THJGProjectRoomDetailTypeOneCell
            cell.bean = bean
            return cell
        }
    }
}
