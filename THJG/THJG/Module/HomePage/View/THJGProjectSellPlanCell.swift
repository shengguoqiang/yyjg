/**
 * 销售进度cell
 */

import UIKit

class THJGProjectSellPlanCell: UITableViewCell {

    //MARK: UI元素
    @IBOutlet weak var statusImgView: UIImageView!
    @IBOutlet weak var planProcessLabel: UILabel!
    @IBOutlet weak var planDateLabel: UILabel!
    @IBOutlet weak var actualDateLabel: UILabel!
    @IBOutlet weak var remarkLabel: UILabel!
    @IBOutlet weak var seperator: UIView!
    
    func reloadData(_ vm: THJGProjectSellPlanBlockCellViewModel,
                    _ hideSeperator: Bool = false) {
        // 状态（1：延迟2：正常，3：超前，4：待完成）
        switch vm.bean.planStatus {
        case 1: // 延迟
            statusImgView.image = UIImage(named: "project_plan_delayed")
        case 2: // 正常
            statusImgView.image = UIImage(named: "project_plan_fin")
        case 3: // 超前
            statusImgView.image = UIImage(named: "project_plan_ahead")
        case 4: // 待完成
            statusImgView.image = UIImage(named: "project_plan_unfin")
        default:
            break
        }
        // 预计进度
        planProcessLabel.text = "\(DQSUtils.showDoubleNum(sourceDouble: Double(vm.bean.planExpect) ?? 0, floatNum: 2, showStyle: .showStyleNoZero))%"
        // 计划日期
        planDateLabel.text = "计划日期：\(DQSUtils.showTime(interval: TimeInterval(vm.bean.planDate/1000), timeFormate: "yyyy-MM-dd"))"
        // 实际日期
        actualDateLabel.isHidden = vm.bean.planStatus == 4 || vm.bean.planStatus == 0
        actualDateLabel.text = "实际日期：\(DQSUtils.showTime(interval: TimeInterval(vm.bean.planActFinishDate/1000), timeFormate: "yyyy-MM-dd"))"
        // 备注
        remarkLabel.isHidden = DQSUtils.isBlank(vm.bean.planRemark)
        remarkLabel.text = vm.bean.planRemark
        // 分割线
        seperator.isHidden = hideSeperator
    }
    
}
