/**
 *  自定义按钮
 *  上图下文字
 */

fileprivate let imageWidthHeightRate: CGFloat = 0.6
fileprivate let imageAndTitleOffset: CGFloat = 12

import UIKit

class THJGVerticalButton: UIButton {
    
    var bean: THJGNewsBean! {
        didSet {
            self.kf.setImage(with: URL(string: bean.newsImg), for: .normal, placeholder: UIImage(named: "common_bg_placeholder_nodata"), options: nil, progressBlock: nil, completionHandler: nil)
            setTitle(bean.newsTitle, for: .normal)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //图片圆角
        imageView?.cornerR = 5
        
        //取消高亮
        adjustsImageWhenHighlighted = false
        
        //文字属性
        titleLabel?.lineBreakMode = .byTruncatingTail
        setTitleColor(DQSUtils.rgbColor(150, 150, 150), for: .normal)
        titleLabel?.numberOfLines = 0
        titleLabel?.font = UIFont.systemFont(ofSize: 14)
        titleLabel?.textAlignment = .center

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

//MARK: - METHODS
extension THJGVerticalButton {
    
    //图片布局修改
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        return CGRect(x: 0, y: 0, width: contentRect.width, height: contentRect.width*imageWidthHeightRate)
    }
    
    //文字布局修改
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        let imageHeight = contentRect.width*imageWidthHeightRate
        return CGRect(x: 0, y: imageHeight + imageAndTitleOffset, width: contentRect.width, height: contentRect.height - imageHeight - imageAndTitleOffset)
    }
}
