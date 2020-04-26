/**
 * 开发成本及费用小类headerView
 */

import UIKit

class THJGProDevCostSmallTypeHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var smallTypeNameLabel: UILabel!
    @IBOutlet weak var smallTypePlanAmountLabel: UILabel!
    @IBOutlet weak var smallTypeActualAmountLabel: UILabel!
    
    @IBOutlet weak var arrowBtn: UIButton!
    
    
    var clickBlock: ProDevCostDetailShowBlock!
    
    func reloadData(_ bean: ProDevCostHandledBean,
                    clickBlock: @escaping ProDevCostDetailShowBlock) {
        //赋值内容
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
extension THJGProDevCostSmallTypeHeaderView {
    @IBAction func headerBtnDidClicked(_ sender: UIButton) {
        clickBlock()
    }
}

extension THJGProDevCostSmallTypeHeaderView: THJGProDevCostHeaderViewProtocol{}
