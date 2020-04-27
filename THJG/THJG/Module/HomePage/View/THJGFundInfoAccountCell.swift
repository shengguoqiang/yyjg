/**
 * 资金信息-账户信息cell
 */

import UIKit

class THJGFundInfoAccountCell: UITableViewCell {
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var bankNameLabel: UILabel!
    @IBOutlet weak var accountNameLabel: UILabel!
    @IBOutlet weak var accountPropertyLabel: UILabel!
    @IBOutlet weak var bankNoLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var shieldNameLabel: UILabel!
    @IBOutlet weak var seperator: UIView!
    /**
     * 更新时间
     */
    @IBOutlet weak var updateTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //顶部视图渐变色
//        let layer = CAGradientLayer()
//        layer.colors = [DQSUtils.rgbColor(233, 71, 63).cgColor,
//                        DQSUtils.rgbColor(235, 82, 69).cgColor,
//                        DQSUtils.rgbColor(237, 95, 77).cgColor,
//                        DQSUtils.rgbColor(240, 107, 84).cgColor,
//                        DQSUtils.rgbColor(242, 123, 92).cgColor,
//                        DQSUtils.rgbColor(246, 142, 104).cgColor,
//                        DQSUtils.rgbColor(248, 156, 112).cgColor,
//                        DQSUtils.rgbColor(250, 163, 115).cgColor]
//        layer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
//        layer.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 45)
//        topView.layer.insertSublayer(layer, at: 0)
    }
    
    var bean: ProFundAccountBean! {
        didSet {
            //调整UI显示与隐藏
            shieldNameLabel.isHidden = DQSUtils.isBlank(bean.bankShieldName)
            seperator.isHidden = shieldNameLabel.isHidden
        }
    }
    
    func reloadData(_ bean: ProFundAccountBean) {
        
        //调整UI
        self.bean = bean
        
        //赋值内容
        iconView.kf.setImage(with: URL(string: bean.bankLogo), placeholder: UIImage(named: "project_fund_bank"), options: nil, progressBlock: nil, completionHandler: nil)
        bankNameLabel.text = bean.bankName
        switch bean.bankProperty {
        case "10":
            accountPropertyLabel.text = "基本户"
        case "20":
            accountPropertyLabel.text = "销售监管户"
        case "30":
            accountPropertyLabel.text = "一般户"
        case "40":
            accountPropertyLabel.text = "一般户(按揭)"
        case "50":
            accountPropertyLabel.text = "保证金账户"
        default:
            break
        }
        accountNameLabel.text = bean.accountName
        bankNoLabel.text = bean.bankNo
        balanceLabel.text = "\(DQSUtils.showNumWithComma(num: DQSUtils.showDoubleNum(sourceDouble: bean.bankBalance, floatNum: 2, showStyle: .showStyleNoZero)))万元"
        shieldNameLabel.text = bean.bankShieldName
        // 更新时间
        updateTimeLabel.text = "\(bean.dataUptTime) 更新"
    }
    
}
