//
//  THJGLeChengVideoFullScreenView.swift
//  THJG
//
//  Created by 大强神 on 2020/7/16.
//  Copyright © 2020 中南金融. All rights reserved.
//

import UIKit

class THJGLeChengVideoFullScreenView: UIView {

    //MARK: UI元素
    /**
     * 容器视图
     */
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var noteLabel: UILabel!
    /**
     * 视频组件
     */
    var m_play: LCOpenSDK_PlayWindow!
    
    //MARK: 数据属性
    /**
     * 设备编号
     */
    var m_device: String!
    
    //MARK: 构造方法
    static func showFullScreen() -> THJGLeChengVideoFullScreenView {
        return Bundle.main.loadNibNamed("THJGLeChengVideoFullScreenView", owner: self, options: nil)?.last as! THJGLeChengVideoFullScreenView
    }
    
    deinit {
        stopRtspVideo()
    }
    
}

extension THJGLeChengVideoFullScreenView {
 
    //MARK: 关闭视频
    func stopRtspVideo() {
        guard m_play != nil else {
            return
        }
        m_play.stopRtspReal()
        m_play.getView()?.removeFromSuperview()
        m_play = nil
        
    }
    
    //MARK: 播放视频
    func startRtspVideo(_ serial: String) {
        
        if m_play == nil {
            m_play = LCOpenSDK_PlayWindow(playWindow: UIScreen.main.bounds, index: 0)
            //m_play.setSurfaceBGColor(.black)
            m_play.setWindowListener(self)
            containerView.addSubview(m_play.getView())
            containerView.bringSubviewToFront(backBtn)
            containerView.bringSubviewToFront(noteLabel)
        }
        
        // 保存设置序列号
        m_device = serial
        
        // 播放视频
        let token = (UIApplication.shared.delegate as! THJGAppDelegate).lcDataCtl.token
        m_play.playRtspReal(token ?? "",
                            devID: serial,
                            psk: "",
                            channel: 0,
                            definition: 1,
                            optimize: true)
        
    }
    
    //取消全屏事件监听
    @IBAction func backBtnDidClicked(_ sender: UIButton) {
        //发送切换屏通知
        NotificationCenter.default.post(name: NSNotification.Name(NOTIFICATION_VIDEO_REC_SMALLSCREEN), object: nil)
        
        //移除当前视图
        removeFromSuperview()
    }
    
}

extension THJGLeChengVideoFullScreenView: LCOpenSDK_EventListener {
    
    func onPlayerResult(_ code: String!, type: Int, index: Int) {
        DQSUtils.log("code:\(code ?? ""), type:\(type), index:\(index)")
    }
    
    func onSlipBegin(_ dir: Direction, dx: CGFloat, dy: CGFloat, index: Int) {
        var iH: Double = 0.0
        var iV: Double = 0.0
        let iZ: Double = 1.0
        let iDuration: Int = 100
        switch dir {
        case .Left:
            iH = -5
            iV = 0
        case .Right:
            iH = 5
            iV = 0
        case .Up:
            iH = 0
            iV = 5
        case .Down:
            iH = 0
            iV = -5
        case .Left_up:
            iH = -5
            iV = 5
        case .Left_down:
            iH = -5
            iV = -5
        case .Right_up:
            iH = 5
            iV = 5
        case .Right_down:
            iH = 5
            iV = -5
        default:
            break
        }
        let restApiService = (UIApplication.shared.delegate as! THJGAppDelegate).m_restApiService
        guard restApiService != nil else {
            return
        }
        DispatchQueue.global().async {
            var errMsg: NSString?
            restApiService!.controlPTZ(self.m_device, chnl: 0, operate: "move", horizon: iH, vertical: iV, zoom: iZ, duration: iDuration, msg: &errMsg)
        }
    }
    
    func onSlipping(_ dir: Direction, preX: CGFloat, preY: CGFloat, dx: CGFloat, dy: CGFloat, index: Int) {
        DQSUtils.log("onSlipping...")
    }
    
    func onSlipEnd(_ dir: Direction, dx: CGFloat, dy: CGFloat, index: Int) {
        DQSUtils.log("onSlipEnd...")
    }
    
}

