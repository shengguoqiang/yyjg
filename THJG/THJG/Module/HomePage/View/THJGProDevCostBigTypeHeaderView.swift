/**
 * 开发成本及费用大类headerView
 */

import UIKit

//明细查看回调
typealias ProDevCostDetailShowBlock = ()->Void

protocol THJGProDevCostHeaderViewProtocol {
    func reloadData(_ bean: ProDevCostHandledBean,
                    clickBlock: @escaping ProDevCostDetailShowBlock)
}

class THJGProDevCostBigTypeHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var bigTypeView: UIView!
    @IBOutlet weak var bigTypeNameLabel: UILabel!
    
    @IBOutlet weak var rateBgView: UIView!
    @IBOutlet weak var rateView: UIView!
    @IBOutlet weak var rateViewWidth: NSLayoutConstraint!
    @IBOutlet weak var bigTypeRateLabel: UILabel!
    
    @IBOutlet weak var smallTypeNameLabel: UILabel!
    @IBOutlet weak var smallTypePlanAmountLabel: UILabel!
    @IBOutlet weak var smallTypeActualAmountLabel: UILabel!
    
    @IBOutlet weak var arrowBtn: UIButton!
    
    var bean: ProDevCostHandledBean!
    var clickBlock: ProDevCostDetailShowBlock!
    
    func reloadData(_ bean: ProDevCostHandledBean,
                    clickBlock: @escaping ProDevCostDetailShowBlock) {
        //赋值内容
        self.bean = bean
        bigTypeNameLabel.text = bean.isHeader.1
        let actual = bean.isHeader.3 ?? 0
        let plan = bean.isHeader.2 ?? 0
        if plan > 0 {
            rateViewWidth.constant = (SCREEN_WIDTH - 230) * min(CGFloat(actual / plan), 1.0)
            rateView.backgroundColor = (actual / plan >= 1) ? DQSUtils.rgbColor(255, 0, 0) : DQSUtils.rgbColor(255, 144, 0)
            bigTypeRateLabel.text = "\(DQSUtils.showDoubleNum(sourceDouble: actual/plan*100, floatNum: 2, showStyle: .showStyleNoZero))%"
        } else {
            if actual > 0 {
                rateViewWidth.constant = SCREEN_WIDTH - 230
                rateView.backgroundColor = DQSUtils.rgbColor(255, 0, 0)
                bigTypeRateLabel.text = "100%"
            } else {
                rateViewWidth.constant = 0
                bigTypeRateLabel.text = "0%"
            }
        }
        smallTypeNameLabel.text = bean.smallBean.smallTypeName
        smallTypePlanAmountLabel.text = DQSUtils.showNumWithComma(num: DQSUtils.showDoubleNum(sourceDouble: bean.smallBean.smallTypePlanCost, floatNum: 2, showStyle: .showStyleNoZero))
        smallTypeActualAmountLabel.text = DQSUtils.showNumWithComma(num: DQSUtils.showDoubleNum(sourceDouble: bean.smallBean.smallTypeActualCost, floatNum: 2, showStyle: .showStyleNoZero))
        if bean.smallBean.smallTypePlanCost < bean.smallBean.smallTypeActualCost {//实际支出超出预算
            smallTypeActualAmountLabel.textColor = DQSUtils.rgbColor(255, 0, 0)
        } else {
            smallTypeActualAmountLabel.textColor = DQSUtils.rgbColor(33, 33, 33)
        }
        
        //箭头状态
        arrowBtn.isHidden = bean.smallBean.smallTypeActualCost <= 0
        arrowBtn.isSelected = bean.isSelected.0
        
        //回调
        self.clickBlock = clickBlock
    }
    
}

//MARK: - METHODS
extension THJGProDevCostBigTypeHeaderView {
    
    @IBAction func headerBtnDidClicked(_ sender: UIButton) {
        clickBlock()
    }
}

extension THJGProDevCostBigTypeHeaderView: THJGProDevCostHeaderViewProtocol{}
