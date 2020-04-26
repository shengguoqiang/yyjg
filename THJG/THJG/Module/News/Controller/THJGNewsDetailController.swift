/**
 * 资讯详情控制器
 */

import UIKit
import WebKit

class THJGNewsDetailController: THJGBaseController {
    
    //MARK: - UI Elements
    @IBOutlet weak var newsDateLabel: UILabel!
    @IBOutlet weak var newsSourceLabel: UILabel!
    @IBOutlet weak var newsTypeBtn: UIButton!
    var webView: WKWebView!
    
    //MARK: - Properties
    var newsId: String!
    var detailVM = THJGNewsDetailViewModel()
    

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        //setup
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //注册请求通知
        NotificationCenter.default.addObserver(self, selector: #selector(requestSuccess(_:)), name: Notification.Name(THJG_NOTIFICATION_NEWS_DETAIL_SUCCESS), object: nil)
        
        //发送请求
        requestForData()
    }

}

//MARK: - METHODS
extension THJGNewsDetailController {
    
    //setup
    func setup() {
        //添加web容器
        webView = WKWebView(frame: CGRect(x: 0, y: 75, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 75 - (navigationController?.navigationBar.bounds.height ?? 0)), configuration:  WKWebViewConfiguration())
        view.addSubview(webView)
    }
    
    func requestForData() {
        DQSUtils.showLoading(view)
        detailVM.requestForNewsDetailData(param: ["newsId": newsId])
    }
    
    //请求成功回调
    override func requestSuccess(_ notification: Notification) {
        super.requestSuccess(notification)
        let specBean = notification.object as! THJGSuccessBean
        let newsDetailBean = specBean.bean as! THJGNewsDetailBean
        refreshUI(newsDetailBean)
    }
    
    func refreshUI(_ bean: THJGNewsDetailBean) {
        navigationItem.title = bean.newsTitle
        newsDateLabel.text = "发布日期：\(DQSUtils.showTime(interval: TimeInterval(bean.newsDate/1000), timeFormate: "yyyy-MM-dd"))"
        newsSourceLabel.text = "信息来源：\(bean.newsSource)"
        // 10 新闻资讯 20 企业资讯 30 行业动态 40 政策动向
        switch bean.newsType {
        case 10:
            newsTypeBtn.setTitle("新闻资讯", for: .normal)
        case 20:
            newsTypeBtn.setTitle("企业资讯", for: .normal)
        case 30:
            newsTypeBtn.setTitle("行业动态", for: .normal)
        case 40:
            newsTypeBtn.setTitle("政策动向", for: .normal)
        default:
            break
        }
        if DQSUtils.isBlank(bean.newsContent) {
            //添加占位图
            DQSUtils.showPlaceholderImg(webView)
        } else {
            //删除占位图
            DQSUtils.hidePlaceholderImg(webView)
            //加载内容
            let header = "<!DOCTYPE html><html><head><meta charset='UTF-8' ><meta name='viewport' content='width=device-width,initial-scale=1,minimum-scale=1,maximum-scale=1,user-scalable=no'><title></title></head><body>"
            let content = bean.newsContent 
            let footer = "<br/></body></html>"
            webView.loadHTMLString(header+content+footer, baseURL: nil)
        }
    }
}
