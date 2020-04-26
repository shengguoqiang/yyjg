/**
 * 平台公告详情
 */

import UIKit
import WebKit

class THJGPlatformNoticeDetailController: THJGBaseController {

    //MARK: - UI Elements
    @IBOutlet weak var timeLabel: UILabel!
    var webView: WKWebView!
    
    //MARK: - Properties
    var noticeId: String!
    lazy var detailVM = THJGPlatformNoticeDetailViewModel()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setup
        setup()

        //获取公告详情
        requestForDetail()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //注册网络请求回调通知
        NotificationCenter.default.addObserver(self, selector: #selector(requestSuccess(_:)), name: Notification.Name(THJG_NOTIFICATION_PLATFORM_DETAIL_SUCCESS), object: nil)
    }

}

//MARK: - METHODS
extension THJGPlatformNoticeDetailController {
    
    //setup
    fileprivate func setup() {
        //添加web容器
        webView = WKWebView(frame: CGRect(x: 0, y: 60, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 60 - (navigationController?.navigationBar.bounds.height ?? 0)), configuration:  WKWebViewConfiguration())
        view.addSubview(webView)
    }
    
    //request for data
    fileprivate func requestForDetail() {
        DQSUtils.showLoading(view)
        detailVM.requestForPlatformNoticeDetail(param: ["noticeId": noticeId])
    }
    
    @objc override func requestSuccess(_ notification: Notification) {
        super.requestSuccess(notification)
        //加载数据
        let specBean = notification.object as! THJGSuccessBean
        let detailBean = specBean.bean as! THJGPlatformNoticeDetailBean
        
        //刷新页面
        //设置导航栏标题
        navigationItem.title = detailBean.noticeTitle
        
        //设置发布时间
        timeLabel.text = "发布时间：\(DQSUtils.showTime(interval: TimeInterval(detailBean.noticeDate/1000), timeFormate: "yyyy-MM-dd HH:mm"))"
        
        //web容器
        let header = "<!DOCTYPE html><html><head><meta charset='UTF-8' ><meta name='viewport' content='width=device-width,initial-scale=1,minimum-scale=1,maximum-scale=1,user-scalable=no'><title></title></head><body>"
        let content = detailBean.noticeContent
        let footer = "<br/><br/></body></html>"
       webView.loadHTMLString(header+content+footer, baseURL: nil)
    }
}
