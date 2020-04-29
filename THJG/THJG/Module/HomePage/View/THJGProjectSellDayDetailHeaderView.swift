/**
 * 日销售详情headerView
 */

import UIKit

class THJGProjectSellDayDetailHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var statusBtn: UIButton!
    
    var clickAction: (()->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // 容器视图添加手势
        containerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(headerViewDidClicked)))
    }
    
    func reloadData(_ bean: THJGProjectSellDayDetailMonthBean) {
        // 时间
        timeLabel.text = bean.proSellDateMonth
        // 销售量
        amountLabel.text = "\(bean.proSoldTotal)"
        // 销售额
        moneyLabel.text = "\(DQSUtils.showNumWithComma(num: DQSUtils.showDoubleNum(sourceDouble: bean.proDfinalAmountTotal/10000, floatNum: 2, showStyle: .showStyleNoZero)))"
        // 是否选中
        statusBtn.isSelected = bean.isSelected
    }
    
}

//MARK: - 类中方法
extension THJGProjectSellDayDetailHeaderView {
        
    //MARK: 点击事件监听
    @objc fileprivate func headerViewDidClicked() {
        clickAction?()
    }
}
