/**
 * 销售信息-销售明细顶部视图
 */

import UIKit

class THJGProSellInfoDetailHeaderView: UIView {

    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var unitPriceLabel: UILabel!
    @IBOutlet weak var recBackLabel: UILabel!
    @IBOutlet weak var dealLabel: UILabel!
    @IBOutlet weak var onWayLabel: UILabel!
    @IBOutlet weak var allSquareLabel: UILabel!
    @IBOutlet weak var selledSquareLabel: UILabel!
    
    var bean: THJGProjectSellDetailBean! {
        didSet {
            //进度条
            let progressView = THJGProgressView.showProgressView()
            addSubview(progressView)
            progressView.snp.makeConstraints { (make) in
                make.leading.equalTo(0)
                make.trailing.equalToSuperview().offset(-170)
                make.top.equalTo(50)
                make.bottom.equalToSuperview().offset(-350)
            }
            if bean.projectAll > 0 {
                progressView.progress = CGFloat(bean.projectSold) / CGFloat(bean.projectAll)
            }
            
            rateLabel.text = "\(bean.projectSold)/\(bean.projectAll)套"
            unitPriceLabel.text = "\(DQSUtils.showNumWithComma(num: DQSUtils.showDoubleNum(sourceDouble: bean.projectAvgPrice, floatNum: 2, showStyle: .showStyleNoZero)))元/㎡"
            recBackLabel.text = "\(DQSUtils.showNumWithComma(num: DQSUtils.showDoubleNum(sourceDouble: bean.projectRecBack/10000, floatNum: 2, showStyle: .showStyleNoZero)))万元"
            dealLabel.text = "\(DQSUtils.showNumWithComma(num: DQSUtils.showDoubleNum(sourceDouble: bean.projectDealAll/10000, floatNum: 2, showStyle: .showStyleNoZero)))万元"
            onWayLabel.text = "\(DQSUtils.showNumWithComma(num: DQSUtils.showDoubleNum(sourceDouble: bean.projectOnWay/10000, floatNum: 2, showStyle: .showStyleNoZero)))万元"
            allSquareLabel.text = "\(DQSUtils.showNumWithComma(num: DQSUtils.showDoubleNum(sourceDouble: bean.projectAllSquare, floatNum: 2, showStyle: .showStyleNoZero)))㎡"
            selledSquareLabel.text = "\(DQSUtils.showNumWithComma(num: DQSUtils.showDoubleNum(sourceDouble: bean.projectSelledSquare, floatNum: 2, showStyle: .showStyleNoZero)))㎡"
        }
    }

}
