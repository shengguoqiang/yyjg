/**
 * 版本升级视图
 */

import UIKit

class THJGVersionUpdateView: UIView {

    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var ignoreBtn: UIButton!
    @IBOutlet weak var updateBtn: UIButton!
    @IBOutlet weak var forceUpdateBtn: UIButton!
    
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
