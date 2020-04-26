/**
 * 开发成本及费用顶部视图
 */

import UIKit

class THJGProDevCostTopView: UIView {

    @IBOutlet weak var projectNameLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    
    func reloadData(_ bean: THJGProjectDevCostBean) {
        //项目名称
        projectNameLabel.text = bean.proName
        //进度条
        let progressView = THJGProgressView.showProgressView()
        addSubview(progressView)
        progressView.snp.makeConstraints { (make) in
            make.leading.equalTo(0)
            make.trailing.equalToSuperview().offset(-200)
            make.top.equalTo(50)
            make.bottom.equalToSuperview().offset(-70)
        }
        if bean.proPlanCost > 0 {
            progressView.progress = CGFloat(bean.proActualCost / bean.proPlanCost)
        }
        //占比
        rateLabel.text = "\(DQSUtils.showNumWithComma(num: DQSUtils.showDoubleNum(sourceDouble: bean.proActualCost, floatNum: 2, showStyle: .showStyleNoZero)))/\(DQSUtils.showNumWithComma(num: DQSUtils.showDoubleNum(sourceDouble: bean.proPlanCost, floatNum: 2, showStyle: .showStyleNoZero)))万元"
    }
    
}
