/**
 * 销售市场CELL
 */

let PRO_SELLMARKET_INFO         = "销售信息"
let PRO_SELLMARKET_COMPETITION  = "竞品楼盘"
let PRO_SELLMARKET_MARKET       = "市场信息"

import UIKit

class THJGProSellMarketCell: UITableViewCell {
    
    @IBOutlet weak var xsxxBtn: THJGProDetailTapButton!
    @IBOutlet weak var jplpBtn: THJGProDetailTapButton!
    @IBOutlet weak var scxxBtn: THJGProDetailTapButton!
    
    lazy var btns: [THJGProDetailTapButton] = {
       return [xsxxBtn, jplpBtn, scxxBtn]
    }()
    
    var indicator: String! {
        didSet {
            for (index, value) in indicator.enumerated() {
                btns[index].isSelected = String(value) != "1"
            }
        }
    }
    
    var handleBlock: THJGProDetailTabBlock!
    
    func reloadData(indi: String, bloc: @escaping THJGProDetailTabBlock) {
        indicator = indi
        handleBlock = bloc
    }
    
}

//MARK: - METHODS
extension THJGProSellMarketCell {
    
    //事件响应
    @IBAction func btnDidClicked(_ sender: UIButton) {
        let title = sender.titleLabel?.text ?? ""
        handleBlock(title, nil)
    }
}
