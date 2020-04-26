/**
 * 引导页
 */

import UIKit

class THJGGuideController: THJGBaseController {
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tabBtn: UIButton!
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        //加载图片
        loadImage()
    }
   
}

//MARK: - METHODS
extension THJGGuideController {
    
    //加载图片
    func loadImage() {
        let images = ["guide_001","guide_002","guide_003"]
        scrollView.contentSize = CGSize(width: SCREEN_WIDTH*3, height: scrollView.bounds.height)
        for (index, image) in images.enumerated() {
            let imageView = UIImageView(image: UIImage(named: image))
            scrollView.addSubview(imageView)
            imageView.snp.makeConstraints { (make) in
                make.size.equalToSuperview()
                make.top.equalToSuperview()
                make.leading.equalTo(SCREEN_WIDTH*CGFloat(index))
            }
        }
    }
    
    //立即体验事件监听
    @IBAction func tabBtnDidClicked(_ sender: UIButton) {
        //页面跳转
        (UIApplication.shared.delegate as! THJGAppDelegate).window?.rootViewController = THJGNavigationController(rootViewController: THJGLoginController())
    }
    
}

//MARK: - UIScrollViewDelegate
extension THJGGuideController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let index = scrollView.contentOffset.x / SCREEN_WIDTH
        if index > 2.1 {
            //页面跳转
            (UIApplication.shared.delegate as! THJGAppDelegate).window?.rootViewController = THJGNavigationController(rootViewController: THJGLoginController())
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = scrollView.contentOffset.x / SCREEN_WIDTH
        tabBtn.isUserInteractionEnabled = index == 2
    }
}
