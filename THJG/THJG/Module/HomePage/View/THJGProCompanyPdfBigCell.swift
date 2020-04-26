/**
 * pfd big cell
 */

import UIKit

class THJGProCompanyPdfBigCell: UICollectionViewCell {

    @IBOutlet weak var pdfNameLabel: UILabel!
    
    var bean: ProCompanyPdfBean! {
        didSet {
            pdfNameLabel.text = bean.resourceName
        }
    }
    
}
