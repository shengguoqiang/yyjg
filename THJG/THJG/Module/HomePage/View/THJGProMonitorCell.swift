/**
 * 项目监控
 */

/* 项目详情-监控指标-标题常量 */
let PRO_INDICATOR_PLAN = "工程进度"
let PRO_INDICATOR_TIME = "节点考核"
let PRO_INDICATOR_CB   = "成本费用"
let PRO_INDICATOR_FUND = "监管资金"
let PRO_INDICATOR_LOG  = "用章登记"

typealias THJGProDetailTabBlock = (String, Int?) -> Void

import UIKit

class THJGProMonitorCell: UITableViewCell {
    
    @IBOutlet weak var gcjdBtn: THJGProDetailTapButton!
    @IBOutlet weak var jdkhBtn: THJGProDetailTapButton!
    @IBOutlet weak var cbfyBtn: THJGProDetailTapButton!
    @IBOutlet weak var jgzjBtn: THJGProDetailTapButton!
    @IBOutlet weak var yzdjBtn: THJGProDetailTapButton!
    
    lazy var btns: [THJGProDetailTapButton] = {
       return [gcjdBtn, jdkhBtn, cbfyBtn, jgzjBtn, yzdjBtn]
    }()
    
    var indicators: [String]! {
        didSet {
            for (index, value) in indicators.enumerated() {
                btns[index].isSelected = String(value) != "1"
            }
        }
    }
    
    var handleBlock: THJGProDetailTabBlock!
    
    func reloadData(indi: [String], blo: @escaping THJGProDetailTabBlock) {
        indicators = indi
        handleBlock = blo
    }
    
}

//MARK: - METHODS
extension THJGProMonitorCell {
    //点击事件响应
    @IBAction func btnDidClicked(_ sender: UIButton) {
        let title = sender.titleLabel?.text ?? ""
        handleBlock(title, nil)
    }
}
