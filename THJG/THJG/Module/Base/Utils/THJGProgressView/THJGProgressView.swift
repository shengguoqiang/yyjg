/**
 * 进度条
 */
import UIKit

class THJGProgressView: UIView {
    
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var curProgressView: UIView!
    @IBOutlet weak var curProgressViewWidth: NSLayoutConstraint!
    @IBOutlet weak var tipBtn: UIButton!
    
    
    var progress: CGFloat = 0 {
        didSet {
            curProgressView.isHidden = progress <= 0
            tipBtn.isHidden = curProgressView.isHidden
            tipBtn.setTitle("\(DQSUtils.showDoubleNum(sourceDouble: Double(progress * 100), floatNum: 2, showStyle: .showStyleNoZero))%", for: .normal)
            curProgressView.backgroundColor = progress >= 1 ? DQSUtils.rgbColor(255, 0, 0) : DQSUtils.rgbColor(255, 144, 0)
            tipBtn.setBackgroundImage((progress >= 1 ? UIImage(named: "common_progress_tip_2") : UIImage(named: "common_progress_tip_1")), for: .normal)
        }
    }
    
    static func showProgressView() -> THJGProgressView {
        return Bundle.main.loadNibNamed("THJGProgressView", owner: self, options: nil)?.last as! THJGProgressView
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //获取具体尺寸后布局
        curProgressViewWidth.constant = bgView.bounds.width * min(progress, 1.0)
    }

}
