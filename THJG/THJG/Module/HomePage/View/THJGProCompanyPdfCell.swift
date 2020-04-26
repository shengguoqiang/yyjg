/**
 * 企业PDF CELL
 */

import UIKit

class THJGProCompanyPdfCell: UICollectionViewCell {

    @IBOutlet weak var pdfNameLabel: UILabel!
    
    var bean: ProCompanyPdfBean! {
        didSet {
            pdfNameLabel.text = bean.resourceName
        }
    }
    
}
