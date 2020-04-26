/**
 * 手势密码按钮
 */

import UIKit

/* 手势密码按钮类型 */
enum DQSGuestureButtonType {
    case normal   //正常
    case selected //选中
    case error    //错误
}

class DQSGuestureButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        //取消交互
        isUserInteractionEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - METHODS
extension DQSGuestureButton {
    
    //重写绘制方法
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        //获取父视图
        var guestureView: DQSGuestureView!
        if superview!.isMember(of: DQSGuestureView.self) {
            guestureView = superview as? DQSGuestureView
        }
        
        //获取上下文
        let context = UIGraphicsGetCurrentContext()!
        //大圆
        context.setLineWidth(guestureView.strokeWidth ?? 1)
        let centerPoint = CGPoint(x: rect.size.width/2, y: rect.size.height/2)
        let startAngle = -Double.pi/2
        let endAngle = 2*Double.pi + startAngle
        let radius = guestureView.circleRadius - (guestureView.strokeWidth ?? 1)
        context.addArc(center: centerPoint, radius: radius, startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle), clockwise: false)
        guestureView.strokeColor?.setStroke()
        context.strokePath()
        
        //大圆与中心圆中间
        guestureView.fillColor?.set()
        context.addArc(center: centerPoint, radius: radius, startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle), clockwise: false)
        context.fillPath()
        
        //中心圆
        guestureView.centerCircleColor?.set()
        context.addArc(center: centerPoint, radius: guestureView.centerCircleRadius ?? 10, startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle), clockwise: false)
        context.fillPath()
    }
}
