/**
 * 抵质押详情
 */

import UIKit
import WebKit

class THJGProDZYController: THJGBaseController {
    
    //MARK: - UI Elements
    @IBOutlet weak var projectNameLabel: UILabel!
    var webView: WKWebView!
    
    //MARK:- Properties
    var bean: THJGPldgeInfoBean!
    var projectName: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        //初始化
        setup()
    }

}

//MARK: - METHODS
extension THJGProDZYController {
  
    //初始化
    func setup() {
        //设置标题
        navigationItem.title = "\(bean.pledgeType == 10 ? "抵押物" : "质押物")\(bean.pledgeNodeType == 10 ? "设定时" : "目前现状")"
        
        //项目名称
        projectNameLabel.text = projectName
        
        //添加web容器
        webView = WKWebView(frame: CGRect(x: 0, y: 45, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 45 - (navigationController?.navigationBar.bounds.height ?? 0)), configuration:  WKWebViewConfiguration())
        view.addSubview(webView)
        
        if DQSUtils.isBlank(bean.pledgeContent) {
            //添加占位图
            DQSUtils.showPlaceholderImg(webView)
        } else {
            //删除占位图
            DQSUtils.hidePlaceholderImg(webView)
            //加载内容
            let header = "<!DOCTYPE html><html><head><meta charset='UTF-8' ><meta name='viewport' content='width=device-width,initial-scale=1,minimum-scale=1,maximum-scale=1,user-scalable=no'><title></title></head><body>"
            let content = bean.pledgeContent
            let footer = "</body></html>"
            webView.loadHTMLString(header+content+footer, baseURL: nil)
        }
    }
}
