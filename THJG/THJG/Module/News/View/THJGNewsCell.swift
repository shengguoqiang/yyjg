/**
 * 资讯cell
 */

import UIKit

class THJGNewsCell: UITableViewCell {

    @IBOutlet weak var newsTitleLabel: UILabel!
    @IBOutlet weak var newsTypeBtn: UIButton!
    @IBOutlet weak var newsDateLabel: UILabel!
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var newsAbstractLabel: UILabel!
    
    var bean: THJGNewsBean! {
        didSet {
            // 10 新闻资讯 20 企业资讯 30 行业动态 40 政策动向
            switch bean.newsType {
            case 10:
                newsTypeBtn.setTitle("新闻资讯", for: .normal)
            case 20:
                newsTypeBtn.setTitle("企业资讯", for: .normal)
            case 30:
                newsTypeBtn.setTitle("行业动态", for: .normal)
            case 40:
                newsTypeBtn.setTitle("政策动向", for: .normal)
            default:
                break
            }
            newsTitleLabel.attributedText = DQSUtils_OC.getAttributedString(withLineSpace: "                   \(bean.newsTitle)", lineSpace: 8, kern: 0)
            newsImageView.kf.setImage(with: URL(string: bean.newsImg), placeholder: UIImage(named: "common_bg_placeholder_nodata"), options: nil, progressBlock: nil, completionHandler: nil)
            newsDateLabel.text = DQSUtils.showTime(interval: TimeInterval(bean.newsDate/1000), timeFormate: "yyyy-MM-dd")
            newsAbstractLabel.text = bean.newsAbstract
        }
    }
    
}
