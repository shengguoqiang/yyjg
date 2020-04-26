/**
 * web容器
 */

import UIKit
import WebKit

class THJGWebController: THJGBaseController {
    
    //MARK; - UI Elements
    var webView: WKWebView!
    var progressView: UIProgressView!
    
    //MARK: - Properties
    var navTitle: String?
    var request: URLRequest!

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        //setup
        setup()
        
        //发送请求
        requestForData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //kvo监听标题和进度条
        webView.addObserver(self, forKeyPath: "title", options: .new, context: nil)
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //移除kvo监听
        webView.removeObserver(self, forKeyPath: "title")
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }

}

//MARK: - METHODS
extension THJGWebController {
    
    //setup
    func setup() {
        //设置导航栏标题
        if DQSUtils.isNotBlank(navTitle) {
            navigationItem.title = navTitle
        }
        
        //添加web容器
        webView = WKWebView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - (navigationController?.navigationBar.bounds.height ?? 0)), configuration: WKWebViewConfiguration())
        webView.navigationDelegate = self
        view.addSubview(webView)
        
        //添加进度条
        progressView = UIProgressView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 2))
        progressView.backgroundColor = UIColor.white
        progressView.tintColor = DQSUtils.rgbColor(176, 30, 49)
        view.addSubview(progressView)
    }
    
    //发送请求
    func requestForData() {
        DQSUtils.showLoading(view)
        webView.load(request)
    }
    
    //kvo事件
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard keyPath != nil else {
            return
        }
        if keyPath! == "title", DQSUtils.isBlank(navTitle) {
            navigationItem.title = webView.title
        } else if keyPath! == "estimatedProgress" {
            progressView.alpha = 1.0
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
            if webView.estimatedProgress >= 1.0 {
                UIView.animate(withDuration: 0.5, delay: 0.3, options: .curveEaseOut, animations: {
                    self.progressView.alpha
                     = 0
                }) { (finished) in
                    self
                    .progressView.setProgress(0, animated: true)
                }
            }
        }
    }
}

//MARK: - WKNavigationDelegate
extension THJGWebController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("请求开始：\(webView.url?.absoluteString ?? "")")
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("请求完成")
        DQSUtils.hideLoading(view)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("请求失败：\(error.localizedDescription)")
        DQSUtils.showToast(error.localizedDescription, view)
    }
}

