/**
 * 重要节点时间CELL
 */

import UIKit

class THJGProjectTimesCell: UITableViewCell {

    @IBOutlet weak var statusView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var nodeNameLabel: UILabel!
    @IBOutlet weak var appointDateLabel: UILabel!
    @IBOutlet weak var expectDateTitleLabel: UILabel!
    @IBOutlet weak var expectDateLabel: UILabel!
    @IBOutlet weak var actualDateOrDelayTitleLabel: UILabel!
    @IBOutlet weak var actualDateOrDelayContentLabel: UILabel!
    @IBOutlet weak var curProgressTitleLabel: UILabel!
    @IBOutlet weak var curProgressContentLabel: UILabel!
    @IBOutlet weak var curProgressY: NSLayoutConstraint!
    @IBOutlet weak var remarkTitleLabel: UILabel!
    @IBOutlet weak var remarkContentLabel: UILabel!
    
    var bean: ProTimesBean! {
        didSet {
            /* 调整UI显示与隐藏 */
            //实际日期or已拖延
            if bean.timeActualDate == 0, (bean.systemCurDate <= bean.timeAppointDate || bean.timeDelay <= 0) {//未完成中的待完成
                actualDateOrDelayTitleLabel.isHidden = true
                curProgressY.constant = 55
            } else {
                actualDateOrDelayTitleLabel.isHidden = false
                curProgressY.constant = 95
            }
            actualDateOrDelayContentLabel.isHidden = actualDateOrDelayTitleLabel.isHidden
            
            //预计日期
            expectDateTitleLabel.isHidden = bean.timeExpectDate == 0
            expectDateLabel.isHidden = expectDateTitleLabel.isHidden
            
            //当前进度
            curProgressTitleLabel.isHidden = DQSUtils.isBlank(bean.timeCurProgress)
            curProgressContentLabel.isHidden = curProgressTitleLabel.isHidden
            
            //备注
            remarkTitleLabel.isHidden = DQSUtils.isBlank(bean.timeRemark)
            remarkContentLabel.isHidden = remarkTitleLabel.isHidden
        }
    }
    
    func reloadData(_ bean: ProTimesBean) {
        //调整UI显示与隐藏
        self.bean = bean
        
        /* 赋值内容 */
        //状态
        if bean.timeActualDate != 0 {//已完成
            statusView.image = UIImage(named: "project_plan_fin")
            statusLabel.text = "已完成"
        } else {//未完成
            if bean.systemCurDate <= bean.timeAppointDate {//待完成
                statusView.image = UIImage(named: "project_plan_unfin")
                statusLabel.text = "待完成"
            } else {//已延期
                statusView.image = UIImage(named: "project_plan_delayed")
                statusLabel.text = "已延期"
            }
        }
        
        //结点名称
        nodeNameLabel.text = bean.timeName
        
        //约定日期
        appointDateLabel.text = DQSUtils.showTime(interval: TimeInterval(bean.timeAppointDate/1000), timeFormate: "yyyy-MM-dd")
        
        //预计日期
        expectDateLabel.text = DQSUtils.showTime(interval: TimeInterval(bean.timeExpectDate/1000), timeFormate: "yyyy-MM-dd")
        
        if bean.timeActualDate != 0 {//已完成
            actualDateOrDelayTitleLabel.text = "实际日期"
            actualDateOrDelayContentLabel.text = DQSUtils.showTime(interval: TimeInterval(bean.timeActualDate/1000), timeFormate: "yyyy-MM-dd")
        } else {//未完成
            if bean.systemCurDate > bean.timeAppointDate, bean.timeDelay > 0 {//已延期
                actualDateOrDelayTitleLabel.text = "已拖延"
                actualDateOrDelayContentLabel.text = "\(bean.timeDelay)天"
            }
        }
        
        //当前进度
        curProgressContentLabel.text = bean.timeCurProgress
        
        //备注
        remarkContentLabel.text = bean.timeRemark
        
    }
}
