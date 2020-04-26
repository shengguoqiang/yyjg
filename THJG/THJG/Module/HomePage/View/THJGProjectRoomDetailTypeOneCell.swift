/**
 * 销售信息-销售明细-室销售详情（type one）
 */

import UIKit

class THJGProjectRoomDetailTypeOneCell: UITableViewCell {
    
    @IBOutlet weak var infoTitleLabel: UILabel!
    @IBOutlet weak var infoContentLabel: UILabel!
    
    var bean: ProjectRoomSellDetailCellBean! {
        didSet {
            infoTitleLabel.text = bean.infoTitle
            if bean.infoTitle == "按揭银行" {
                infoContentLabel.text = (bean.infoContent as! String)
            } else if bean.infoTitle == "销售状态" {
               let status = bean.infoContent as! Int
                switch status {
                case 10:
                    infoContentLabel.text = "待售"
                case 20:
                    infoContentLabel.text = "认购"
                case 30:
                    infoContentLabel.text = "网签"
                case 40:
                    infoContentLabel.text = "不可售"
                default:
                    infoContentLabel.text = ""
                    break
                }
            } else if bean.infoTitle == "抵押状态" {
                let status = bean.infoContent as! Int
                switch status {
                case 0:
                    infoContentLabel.text = "未抵押"
                case 1:
                    infoContentLabel.text = "抵押"
                default:
                    infoContentLabel.text = ""
                    break
                }
            } else if bean.infoTitle == "建筑面积" {
                infoContentLabel.text = "\(DQSUtils.showNumWithComma(num: DQSUtils.showDoubleNum(sourceDouble: (bean.infoContent as! Double), floatNum: 2, showStyle: .showStyleNoZero)))㎡"
            } else if bean.infoTitle == "单价" {
                infoContentLabel.text = "\(DQSUtils.showNumWithComma(num: DQSUtils.showDoubleNum(sourceDouble: (bean.infoContent as! Double), floatNum: 2, showStyle: .showStyleNoZero)))元/㎡"
            } else {
                infoContentLabel.text = "\(DQSUtils.showNumWithComma(num: DQSUtils.showDoubleNum(sourceDouble: (bean.infoContent as! Double), floatNum: 2, showStyle: .showStyleNoZero)))元"
            }
        }
    }
    
}
