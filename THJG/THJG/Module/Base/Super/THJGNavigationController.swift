/**
 * 导航控制器基类
 */

import UIKit

class THJGNavigationController: UINavigationController {

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setup
        setup()
    }
    
    //MARK: - Rewrite the push method
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count >= 1 {
            //导航栏返回按钮
            let targetVC = viewController as! THJGBaseController
            targetVC.navigationItem.leftBarButtonItem = UIBarButtonItem.item(image_nor: "common_navBack_arrow", image_hl: nil, target: targetVC, action: #selector(targetVC.popBack))
            //页面push隐藏底部工具栏
            targetVC.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }

}

//MARK: - METHODS
extension THJGNavigationController {
    
    //设置
    func setup() {
        //设置导航栏背景
        let bar = UINavigationBar.appearance()
        bar.setBackgroundImage(UIImage(named: "common_navbar_bg"), for: .default)
        
        //设置导航栏文字
        bar.titleTextAttributes = [NSMutableAttributedString.Key.font: UIFont.systemFont(ofSize: 20),
                                   NSMutableAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    
    
}
