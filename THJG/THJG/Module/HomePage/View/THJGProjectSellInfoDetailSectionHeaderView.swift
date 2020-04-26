/**
 * 项目销售信息-销售明细-sectionHeader
 */

import UIKit

//点击事件回调
typealias SellInfoDetialClickBlock = () -> Void

class THJGProjectSellInfoDetailSectionHeaderView: UITableViewHeaderFooterView {
    
    
    @IBOutlet weak var blockNameLabel: UILabel!
    @IBOutlet weak var allLabel: UILabel!
    @IBOutlet weak var soldLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    
    @IBOutlet weak var arrowBtn: UIButton!
    
    var clickBlock: SellInfoDetialClickBlock!
    
    func reloadData(_ bean: ProjectSellDetailHandledBean,
                    clickBlock: @escaping SellInfoDetialClickBlock) {
        //赋值内容
        blockNameLabel.text = bean.headerBean.proBlock
        allLabel.text = bean.headerBean.proSellable != 0 ? "\(bean.headerBean.proSellable)" : "-"
        soldLabel.text = bean.headerBean.proSold != 0 ? "\(bean.headerBean.proSold)" : "-"
        if bean.headerBean.proRecBack == 0, bean.headerBean.proDealTotal == 0 {
            rateLabel.text = "-"
        } else {
            rateLabel.text = "\(DQSUtils.showNumWithComma(num: DQSUtils.showDoubleNum(sourceDouble: bean.headerBean.proRecBack/10000, floatNum: 2, showStyle: .showStyleNoZero)))/\(DQSUtils.showNumWithComma(num: DQSUtils.showDoubleNum(sourceDouble: bean.headerBean.proDealTotal/10000, floatNum: 2, showStyle: .showStyleNoZero)))"
        }
        
        //调整箭头
       arrowBtn.isSelected = bean.isSelected.0
        
        //赋值点击事件
        self.clickBlock = clickBlock
    }
}

//MARK: - METHODS
extension THJGProjectSellInfoDetailSectionHeaderView {
    
    @IBAction func headerDidClicked(_ sender: UIButton) {
        clickBlock()
    }
}
