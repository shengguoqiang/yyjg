/**
 * 项目详情点击tab
 * 上图下文字
 */

import UIKit

fileprivate let imageHeightRate: CGFloat = 0.6875
fileprivate let imageAndTitleOffset: CGFloat = 12

class THJGProDetailTapButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        //图片圆角
        imageView?.cornerR = 3
        
        //取消高亮
        adjustsImageWhenHighlighted = false
        
        //文字属性
        setTitleColor(DQSUtils.rgbColor(33, 33, 33), for: .normal)
        setTitleColor(DQSUtils.rgbColor(33, 33, 33), for: .selected)
        titleLabel?.font = UIFont.systemFont(ofSize: 13)
        titleLabel?.textAlignment = .center
    }
    
}

//MARK: - METHODS
extension THJGProDetailTapButton {
    
    //图片布局修改
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        return CGRect(x: 0, y: 0, width: contentRect.width, height: contentRect.height*imageHeightRate)
    }
    
    //文字布局修改
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        return CGRect(x: 0, y: contentRect.height*imageHeightRate + imageAndTitleOffset, width: contentRect.width, height: contentRect.height*(1-imageHeightRate) - imageAndTitleOffset)
    }
}

