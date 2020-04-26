/**
 * 手势密码视图
 */

import UIKit

/* 手势密码视图类型 */
enum DQSGuestureViewType {
    case set      //初设
    case confirm  //确认
    case validate //校验
}

/* 常量 */
fileprivate let kGuestureBtnW: CGFloat = 65
fileprivate let kGuestureBtnH = kGuestureBtnW

/* 手势密码视图代理 */
protocol DQSGuestureViewDelegate {
    //绘制成功
    func drawFinished(_ type: DQSGuestureViewType, _ pwd: String)
}

class DQSGuestureView: UIView {
    
    /* 类型 */
    var gType: DQSGuestureViewType = .set
    
    /* 代理 */
    var gDelegate: DQSGuestureViewDelegate?
    
    /* 手势密码按钮属性 */
    //大圆-弧宽度
    var strokeWidth: CGFloat?
    //大圆-弧填充颜色
    var strokeColor: UIColor?
    //大圆-半径
    var circleRadius: CGFloat = kGuestureBtnW/2
    
    //中心圆-半径
    var centerCircleRadius: CGFloat?
    //中心圆-填充色
    var centerCircleColor: UIColor?
    
    //除中心圆外，其他部分填充色
    var fillColor: UIColor?
    
    /* 手势密码连接线属性 */
    //连接线宽度
    var lineWidth: CGFloat?
    //连接线颜色
    var lineColor: UIColor?
    
    /* 手势密码数据 */
    //总的按钮数组
    lazy var nodeButtons = [DQSGuestureButton]()
    //选中的按钮数组
    lazy var selectedButtons = [DQSGuestureButton]()
    //当前手势停留的位置
    var curPoint: CGPoint?
    
    /* 手势密码按钮类型 */
    var guestureButtonType: DQSGuestureButtonType = .normal {
        didSet {
            switch guestureButtonType {
            case .normal://正常
                strokeWidth = 1.0
                strokeColor = DQSUtils.rgbColor(150, 150, 150)
                centerCircleRadius = 10.0
                centerCircleColor = UIColor.white
                fillColor = UIColor.white
                lineWidth = 1.0
                lineColor = UIColor.white
                isUserInteractionEnabled = true
                //恢复normal
                resetNormal()
            case .selected://选中
                strokeWidth = 1.0
                strokeColor = DQSUtils.rgbColor(176, 30, 49)
                centerCircleRadius = 10.0
                centerCircleColor = DQSUtils.rgbColor(176, 30, 49)
                fillColor = UIColor.white
                lineWidth = 1.0
                lineColor = DQSUtils.rgbColor(176, 30, 49)
            case .error://错误
                strokeWidth = 1.0
                strokeColor = DQSUtils.rgbColor(150, 150, 150)
                centerCircleRadius = 10.0
                centerCircleColor = DQSUtils.rgbColor(150, 150, 150)
                fillColor = UIColor.white
                lineWidth = 1.0
                lineColor = DQSUtils.rgbColor(150, 150, 150)
                isUserInteractionEnabled = false
                //重绘页面，并在0.5秒后恢复normal
                setNeedsDisplay()
                perform(#selector(resetToNormal), with: self, afterDelay: 0.5)
            }
        }
    }

}

//MARK: - METHODS
extension DQSGuestureView {
    
    /* 手势密码视图加载至父视图，创建按钮 */
    override func layoutSubviews() {
        super.layoutSubviews()
        if nodeButtons.isEmpty {
            createGuestureButtons(self)
        }
    }
    
    /* 创建手势密码按钮 */
    func createGuestureButtons(_ parView: UIView) {
        
        //初始化样式
        guestureButtonType = .normal
        
        //绘制按钮
        let colMargin = (parView.bounds.width - kGuestureBtnW * 3) / 2
        let rowMargin = (parView.bounds.height - kGuestureBtnH * 3) / 2
        for i in 0..<9 {
            let row = (CGFloat)(i/3)
            let col = (CGFloat)(i%3)
            let gustureBtn = DQSGuestureButton.init(frame: CGRect(x: col*(kGuestureBtnW+colMargin), y: row*(kGuestureBtnH+rowMargin), width: kGuestureBtnW, height: kGuestureBtnH))
            gustureBtn.tag = i+1
            nodeButtons.append(gustureBtn)
            addSubview(gustureBtn)
        }
    }
    
    /* 手势相关事件监听 */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let touch = touches.first
        //获取触摸点在view中的位置
        let point = touch?.location(in: self)
        guard point != nil else {
            return
        }
        //设置当前点
        curPoint = point
        //判断触摸点是否在当前btn范围内
        for btn in subviews {
            if btn is DQSGuestureButton, btn.frame.contains(point!) {
                let guestureBtn = btn as! DQSGuestureButton
                guestureBtn.isSelected = true
                if !selectedButtons.contains(guestureBtn) {
                    selectedButtons.append(guestureBtn)
                    guestureButtonType = .selected
                }
            }
        }
        //重绘View画线
        setNeedsDisplay()
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        let touch = touches.first
        //获取触摸点在view中的位置
        let point = touch?.location(in: self)
        guard point != nil else {
            return
        }
        //设置当前点
        curPoint = point
        //判断触摸点是否在当前btn范围内
        for btn in subviews {
            if btn is DQSGuestureButton, btn.frame.contains(point!) {
                let guestureBtn = btn as! DQSGuestureButton
                guestureBtn.isSelected = true
                if !selectedButtons.contains(guestureBtn) {
                    selectedButtons.append(guestureBtn)
                    guestureButtonType = .selected
                }
            }
        }
        //重绘View画线
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        //获取最后选择按钮
        let lastSelectedBtn = selectedButtons.last
        curPoint = lastSelectedBtn?.center
        //重绘View画线
        setNeedsDisplay()
        //绘制成功响应
        var tempPwd = ""
        for btn in selectedButtons {
            tempPwd.append("\(btn.tag)")
        }
        gDelegate?.drawFinished(gType, tempPwd)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        /* 判断选中数组是否非空 */
        guard !selectedButtons.isEmpty else {
            return
        }
        /* 渲染 */
        //画线
        let path = UIBezierPath()
        path.lineWidth = lineWidth ?? 1
        lineColor?.set()
        path.lineJoinStyle = .round
        path.lineCapStyle = .round
        //重绘选中按钮
        for (index, btn) in selectedButtons.enumerated() {
            if index == 0 {
                path.move(to: btn.center)
            } else {
                path.addLine(to: btn.center)
            }
            btn.setNeedsDisplay()
        }
        path.addLine(to: curPoint ?? .zero)
        path.stroke()
    }
    
    /* 手势密码按钮常态重置 */
    @objc func resetToNormal() {
        guestureButtonType = .normal
    }
    
    func resetNormal() {
        if !selectedButtons.isEmpty {
            //清空选中数组
            selectedButtons.removeAll()
            //重绘页面上所有的按钮
            for btn in nodeButtons {
                btn.setNeedsDisplay()
            }
            //此处作用是移除线条
            setNeedsDisplay()
        }
    }
    
}
