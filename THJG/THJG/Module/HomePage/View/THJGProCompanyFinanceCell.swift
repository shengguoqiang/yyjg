/**
 * 企业信息-财务信息cell
 */

import UIKit

class THJGProCompanyFinanceCell: UITableViewCell {

    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var pdfNameLabel: UILabel!
    
    func reloadData(bean: ProCompanyPdfBean, index: Int) {
        pdfNameLabel.text = bean.resourceName
        bgImageView.image = UIImage(named: "pro_company_finance_\(index%4)")
    }
    
}
