/**
 * 施工方CELL
 */

import UIKit

class THJGProOperatorCell: UITableViewCell {

    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var gsxxBtn: THJGProDetailTapButton!
    @IBOutlet weak var fxxxBtn: THJGProDetailTapButton!

    lazy var btns: [THJGProDetailTapButton] = {
        return [gsxxBtn, fxxxBtn]
    }()
    
    var bean: THJGCompanyInfoBean! {
        didSet {
            companyNameLabel.text = bean.companyName
            for (index, value) in bean.companyIndicators.enumerated() {
                btns[index].isSelected = String(value) != "1"
            }
        }
    }
    
    var handledBlock: THJGProDetailTabBlock!
    
    func reloadData(bean: THJGCompanyInfoBean,
                    bloc: @escaping THJGProDetailTabBlock) {
        self.bean = bean
        handledBlock = bloc
    }
    
}

//MARK: - METHODS
extension THJGProOperatorCell {
    
    //事件响应
    @IBAction func btnDidClicked(_ sender: UIButton) {
        let title = sender.titleLabel?.text ?? ""
        handledBlock(title, sender.tag - 2000)
    }
}
