/**
 * 全局TabBar控制器
 */

import UIKit

class THJGTabBarController: UITabBarController {

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        //setup controllers
        setup()
    }

}

//MARK: - METHODS
extension THJGTabBarController {
    
    //setup
    fileprivate func setup() {
        //add controllers
        let projectNav = THJGNavigationController(rootViewController: THJGHomePageController())
        projectNav.tabBarItem = UITabBarItem(title: "项目", image: UIImage(named: "tab_project_nor"), selectedImage: UIImage(named: "tab_project_sel"))
        addChild(projectNav)
        
        let newsNav = THJGNavigationController(rootViewController: THJGNewsController())
        newsNav.tabBarItem = UITabBarItem(title: "资讯", image: UIImage(named: "tab_news_nor"), selectedImage: UIImage(named: "tab_news_sel"))
        addChild(newsNav)
        
        let myNav = THJGNavigationController(rootViewController: THJGMyController())
        myNav.tabBarItem = UITabBarItem(title: "我的", image: UIImage(named: "tab_my_nor"), selectedImage: UIImage(named: "tab_my_sel"))
        addChild(myNav)
        
        //取消图片和文字默认效果
        let bar = UITabBarItem.appearance()
        bar.setTitleTextAttributes([NSMutableAttributedString.Key.font: UIFont.systemFont(ofSize: 10), NSMutableAttributedString.Key.foregroundColor: DQSUtils.rgbColor(176, 30, 49)], for: .normal)
        bar.setTitleTextAttributes([NSMutableAttributedString.Key.font: UIFont.systemFont(ofSize: 10), NSMutableAttributedString.Key.foregroundColor: DQSUtils.rgbColor(176, 30, 49)], for: .selected)
    }
}

