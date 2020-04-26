/**
 * 站内信详情
 */

import UIKit

class THJGInnerMsgDetailController: THJGBaseController {
    
    //MARK: - UI Elements
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var contentView: UITextView!
    
    //MARK: - Properties
    var msgId: String!
    lazy var detailVM = THJGInnerMsgDetailViewModel()

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //请求详情
        DQSUtils.showLoading(view)
        detailVM.requestForMsgDetail(param: ["msgId": msgId])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //注册成功通知
        NotificationCenter.default.addObserver(self, selector: #selector(requestSuccess(_:)), name: NSNotification.Name(THJG_NOTIFICATION_INNER_MSG_DETAIL_SUCCESS), object: nil)
    }
    
    
}

//MARK: - METHODS
extension THJGInnerMsgDetailController {
    //describe the UI
    fileprivate func refreshUI(_ bean: InnerMsgBean) {
        //设置标题
        navigationItem.title = bean.msgTitle
        
        //发布时间
        timeLabel.text = "发布时间：\(DQSUtils.showTime(interval: TimeInterval(bean.msgSendDate/1000), timeFormate: "yyyy-MM-dd HH:mm"))"
        
        //内容
        contentView.text = bean.msgContent
    }
    
    @objc override func requestSuccess(_ notification: Notification) {
        super.requestSuccess(notification)
        let specBean = notification.object as! THJGSuccessBean
        let detailBean = specBean.bean as! InnerMsgBean
        //刷新界面
        refreshUI(detailBean)
        
        //将消息置为已读
        detailVM.requestForReadMsg(param: ["msgId": detailBean.msgId], success: { (_, _) in
            
        }) { (code, msg) in
            
        }
    }
}
