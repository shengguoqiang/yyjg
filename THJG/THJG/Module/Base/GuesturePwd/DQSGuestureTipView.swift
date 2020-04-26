/**
 * 手势密码视图顶部提示视图
 */

import UIKit

/* 常量 */
fileprivate let kGuestureTipBtnW: CGFloat = 10
fileprivate let kGuestureTipBtnH: CGFloat = 10

class DQSGuestureTipView: UIView {

    /* 按钮数组 */
    lazy var tipButtons = [UIButton]()
    
    /* 调整小按钮样式 */
    func refresh(_ tip: String) {
        for (index, btn) in tipButtons.enumerated() {
            if tip.contains("\(index+1)") {
                btn.backgroundColor = DQSUtils.rgbColor(176, 30, 49)
            }
        }
    }
    
    func reset() {
        for btn in tipButtons {
            btn.backgroundColor = UIColor.white
        }
    }
}

//MARK: - METHODS
extension DQSGuestureTipView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //创建小按钮
        createGuestureTipButtons(self)
    }
    
    /* 创建小按钮 */
    func createGuestureTipButtons(_ parView: UIView) {
        let colMargin = (parView.bounds.width - kGuestureTipBtnW * 3) / 2
        let rowMargin = (parView.bounds.height - kGuestureTipBtnH * 3) / 2
        for i in 0..<9 {
            let row = (CGFloat)(i/3)
            let col = (CGFloat)(i%3)
            let tipBtn = UIButton.init(frame: CGRect(x: col*(kGuestureTipBtnW+colMargin), y: row*(kGuestureTipBtnH+rowMargin), width: kGuestureTipBtnW, height: kGuestureTipBtnH))
            tipBtn.layer.cornerRadius = 5
            tipBtn.layer.borderWidth = 0.5
            tipBtn.layer.borderColor = DQSUtils.rgbColor(150, 150, 150).cgColor
            tipButtons.append(tipBtn)
            addSubview(tipBtn)
        }
    }
}
