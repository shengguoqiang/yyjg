/**
 * 版本升级视图
 */

import UIKit
import WebKit

class THJGVersionUpdateView: UIView {

    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var webContainerView: UIView!
    fileprivate var webView: WKWebView!
    @IBOutlet weak var ignoreBtn: UIButton!
    @IBOutlet weak var updateBtn: UIButton!
    @IBOutlet weak var forceUpdateBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
        webContainerView.addSubview(webView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        webView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    var bean: AppUpgradeBean! {
        didSet {
            versionLabel.text = "发现新版本V\(bean.upgradeVersion)"
            webView.loadHTMLString(bean.upgradeContent, baseURL: nil)
            ignoreBtn.isHidden = bean.upgradeForce == 1
            updateBtn.isHidden = ignoreBtn.isHidden
            forceUpdateBtn.isHidden = !ignoreBtn.isHidden
        }
    }
    
    static func showUpdateView() -> THJGVersionUpdateView {
        return Bundle.main.loadNibNamed("THJGVersionUpdateView", owner: self, options: nil)?.last as! THJGVersionUpdateView
    }
    
}

extension THJGVersionUpdateView {
    //忽略更新
    @IBAction func ignoreBtnDidClicked(_ sender: UIButton) {
        removeFromSuperview()
    }
    
    //更新
    @IBAction func updateBtnDidClicked(_ sender: UIButton) {
        DQSUtils.switchAppStore()
    }

}
