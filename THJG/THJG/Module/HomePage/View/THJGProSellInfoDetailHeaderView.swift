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
    
    fileprivate var chartView: YKLineChartView!
    
    /**
     * 七日销售信息
     */
    @IBOutlet weak var weekSellInfoLabel: UILabel!
    /**
     * 七日销售折线图
     */
    @IBOutlet weak var weekSellLineView: UIView!
    
    //MARK: 数据属性
    /**
     * 七日销售更多事件回调
     */
    var moreAction: (()->Void)?
    
    var bean: THJGProjectSellDetailBean! {
        didSet {
            //进度条
            let progressView = THJGProgressView.showProgressView()
            addSubview(progressView)
            progressView.snp.makeConstraints { (make) in
                make.leading.equalTo(0)
                make.trailing.equalToSuperview().offset(-170)
                make.top.equalTo(50)
                make.bottom.equalToSuperview().offset(-350-240)
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
    
    //MARK: 加载七日销售明细
    func reloadWeekSellData(_ bean: THJGProjectSellWeekDetailsBean) {
        // 七日销售信息
        weekSellInfoLabel.text = "\(DQSUtils.showNumWithComma(num: DQSUtils.showDoubleNum(sourceDouble: bean.projectDfinalAmount/10000, floatNum: 2, showStyle: .showStyleNoZero)))万元" + " / \(bean.projectIsold)套"
        // 七日折线图
        createChartView(bean)
    }
    
    //MARK: 创建折线图
    fileprivate func createChartView(_ bean: THJGProjectSellWeekDetailsBean) {
        guard chartView == nil else {
            return
        }
        // 创建
        chartView = YKLineChartView()
        chartView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH - 30, height: 150)
        weekSellLineView.addSubview(chartView)
        // 配置
        let config = YKUIConfig()
        // y轴
        config.yDescFront = UIFont.init(name: "PingFang-SC-Medium", size: 10.0)
        config.yDescColor = UIColor(red: 161.0/255.0, green: 161.0/255.0, blue: 161.0/255.0, alpha: 1.0)
        config.ylineColor = UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 0.3)
        // x轴
        config.xDescFront = UIFont.init(name: "PingFang-SC-Medium", size: 10.0)
        config.xDescColor = UIColor(red: 161.0/255.0, green: 161.0/255.0, blue: 161.0/255.0, alpha: 1.0)
        // 线
        config.lineWidth = 1
        config.lineColor = UIColor(red: 161.0/255.0, green: 46/255.0, blue: 54/255.0, alpha: 1.0)
        config.circleWidth = 2
        // 赋值
        let dataObj = YKLineDataObject()
        dataObj.ySuffix = ""
        var timeArr = [String]()
        var sellArr = [Int]()
        for item in bean.projectSellWeekDetails {
            timeArr.append(item.proSellDate)
            sellArr.append(item.proSold)
        }
        dataObj.xDescriptionDataSource = timeArr
        dataObj.showNumbers = sellArr
        chartView.setupDataSource(dataObj, withUIConfgi: config)
    }
    
    //MARK: 七日销售详情查看事件监听
    @IBAction fileprivate func moreBtnDidClicked() {
        moreAction?()
    }

}
