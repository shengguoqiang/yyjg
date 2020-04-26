/**
 * 销售信息-计划与进度cell
 */

import UIKit

class THJGProjectSellPlanCell: UITableViewCell {

    @IBOutlet weak var statusImgView: UIImageView!
    //right
    @IBOutlet weak var rightDateLabel: UILabel!
    @IBOutlet weak var rightExpectLabel: UILabel!
    @IBOutlet weak var rightActualLabel: UILabel!
    @IBOutlet weak var rightRemarkLabel: UILabel!
    
    //left
    @IBOutlet weak var leftDateLabel: UILabel!
    @IBOutlet weak var leftExpectLabel: UILabel!
    @IBOutlet weak var leftActualLabel: UILabel!
    @IBOutlet weak var leftRemarkLabel: UILabel!
    
    var position: ProjectSellPlanCellPostion = .right {
        didSet {
            switch position {
            case .right:
                //left
                leftDateLabel.isHidden = true
                leftExpectLabel.isHidden = true
                leftActualLabel.isHidden = true
                leftRemarkLabel.isHidden = true
                //right
                rightDateLabel.isHidden = false
                rightExpectLabel.isHidden = false
                rightActualLabel.isHidden = false
                rightRemarkLabel.isHidden = false
            case .left:
                //left
                leftDateLabel.isHidden = false
                leftExpectLabel.isHidden = false
                leftActualLabel.isHidden = false
                leftRemarkLabel.isHidden = false
                //right
                rightDateLabel.isHidden = true
                rightExpectLabel.isHidden = true
                rightActualLabel.isHidden = true
                rightRemarkLabel.isHidden = true
            }
        }
    }
    
    var bean: ProjectSellPlanHandledBean! {
        didSet {
            //调整进度UI
            if bean.cellStatus == .unFinished {
                if position == .right {
                    rightActualLabel.isHidden = true
                } else {
                    leftActualLabel.isHidden = true
                }
            }
            //调整备注UI
            if DQSUtils.isBlank(bean.cellBean.planRemark) {
                if position == .right {
                    rightRemarkLabel.isHidden = true
                } else {
                    leftRemarkLabel.isHidden = true
                }
            }
        }
    }
    
    func reloadData(_ bean: ProjectSellPlanHandledBean) {
        //调整UI
        position = bean.cellPosition
        self.bean = bean
        
        //赋值内容
        switch bean.cellStatus {
        case .ahead:
            statusImgView.image = UIImage(named: "project_plan_ahead")
        case .normal:
            statusImgView.image = UIImage(named: "project_plan_fin")
        case .delay:
            statusImgView.image = UIImage(named: "project_plan_delayed")
        case .unFinished:
            statusImgView.image = UIImage(named: "project_plan_unfin")
        }
        switch position {
        case .left:
            leftDateLabel.text = DQSUtils.showTime(interval: TimeInterval(bean.cellBean.planDate/1000), timeFormate: "yyyy-MM-dd")
            leftExpectLabel.text = "预计 \(DQSUtils.showDoubleNum(sourceDouble: Double(bean.cellBean.planExpect) ?? 0, floatNum: 2, showStyle: .showStyleNoZero))%"
            leftActualLabel.text = "实际 \(DQSUtils.showDoubleNum(sourceDouble: Double(bean.cellBean.planActual) ?? 0, floatNum: 2, showStyle: .showStyleNoZero))%"
            leftRemarkLabel.text = bean.cellBean.planRemark
        case .right:
            rightDateLabel.text = DQSUtils.showTime(interval: TimeInterval(bean.cellBean.planDate/1000), timeFormate: "yyyy-MM-dd")
            rightExpectLabel.text = "预计 \(DQSUtils.showDoubleNum(sourceDouble: Double(bean.cellBean.planExpect) ?? 0, floatNum: 2, showStyle: .showStyleNoZero))%"
            rightActualLabel.text = "实际 \(DQSUtils.showDoubleNum(sourceDouble: Double(bean.cellBean.planActual) ?? 0, floatNum: 2, showStyle: .showStyleNoZero))%"
            rightRemarkLabel.text = bean.cellBean.planRemark
        }
    }
    
    
}
