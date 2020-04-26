/**
 * 抵质押CELL
 */

import UIKit

class THJGProDZYCell: UITableViewCell {

    @IBOutlet weak var dysdBtn: THJGProDetailTapButton!
    @IBOutlet weak var dymqxzBtn: THJGProDetailTapButton!
    @IBOutlet weak var zysdBtn: THJGProDetailTapButton!
    @IBOutlet weak var zymqxzBtn: THJGProDetailTapButton!
    
    lazy var btns: [THJGProDetailTapButton] = {
       return [dysdBtn, dymqxzBtn, zysdBtn, zymqxzBtn]
    }()
    
    var beans: [THJGPldgeInfoBean]! {
        didSet {
            for (index, bean) in beans.enumerated() {
                btns[index].isSelected = DQSUtils.isBlank(bean.pledgeContent)
            }
        }
    }
    
    var handledBlock: THJGProDetailTabBlock!
    
    func reloadData(beans: [THJGPldgeInfoBean],
                    bloc: @escaping THJGProDetailTabBlock) {
        self.beans = beans
        handledBlock = bloc
    }
}

//MARK: - METHODS
extension THJGProDZYCell {
   
    @IBAction func btnDidClicked(_ sender: UIButton) {
        handledBlock("抵/质押情况", sender.tag - 1000)
    }
}
