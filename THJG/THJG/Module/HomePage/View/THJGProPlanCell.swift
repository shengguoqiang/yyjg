/**
 * 工程计划及进度cell
 */

import UIKit

class THJGProPlanCell: UITableViewCell {

    @IBOutlet weak var statusView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var nodeNameLabel: UILabel!
    @IBOutlet weak var expectDateLabel: UILabel!
    
    @IBOutlet weak var actualDateTitleLabel: UILabel!
    @IBOutlet weak var actualDateLabel: UILabel!
    @IBOutlet weak var remarkTitleLabel: UILabel!
    @IBOutlet weak var remarkContentLabel: UILabel!
    @IBOutlet weak var remarkY: NSLayoutConstraint!
    @IBOutlet weak var proofContainerView: UIView!
    var imgShowView: THJGBriefImgShowView!
    
    var bean: ProPlanBean! {
        didSet {
            /* 调整元素显示与隐藏 */
            //实际日期
            actualDateLabel.isHidden = bean.planActualDate == 0
            actualDateTitleLabel.isHidden = actualDateLabel.isHidden
            //备注
            remarkY.constant = bean.planActualDate == 0 ? 24 : 60
            remarkTitleLabel.isHidden = DQSUtils.isBlank(bean.planRemark)
            remarkContentLabel.isHidden = remarkTitleLabel.isHidden
            //凭证
            proofContainerView.isHidden = bean.planProofs.isEmpty
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgShowView = THJGBriefImgShowView.showBriefImgView()
        proofContainerView.addSubview(imgShowView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imgShowView.frame = proofContainerView.bounds
    }
    
    func reloadData(_ bean: ProPlanBean,
                    selectBlock: @escaping ImgShowBlock) {
        //赋值以调整UI
        self.bean = bean
        
        //赋值内容
        switch bean.planStatus {
        case 10:
            statusView.image = UIImage(named: "project_plan_unfin")
            statusLabel.text = "待完成"
        case 20:
            statusView.image = UIImage(named: "project_plan_delayed")
            statusLabel.text = "已延期"
        case 30:
            statusView.image = UIImage(named: "project_plan_fin")
            statusLabel.text = "如期完成"
        case 40:
            statusView.image = UIImage(named: "project_plan_ahead")
            statusLabel.text = "提前完成"
        case 50:
            statusView.image = UIImage(named: "project_plan_delay")
            statusLabel.text = "延期完成"
        default:
            break
        }
        nodeNameLabel.text = bean.planName
        expectDateLabel.text = DQSUtils.showTime(interval: TimeInterval(bean.planExpectDate/1000), timeFormate: "yyyy-MM-dd")
        actualDateLabel.text = DQSUtils.showTime(interval: TimeInterval(bean.planActualDate/1000), timeFormate: "yyyy-MM-dd")
        remarkContentLabel.text = bean.planRemark
        if !bean.planProofs.isEmpty {
            var showBeans = [THJGImgShowBean]()
            for proof in bean.planProofs {
                showBeans.append(THJGImgShowBean(imgUrl: proof.proofUrl, imgName: proof.proofName, isVideo: false, videoType: nil, videoStatus: nil, videoSerial: nil, videoUrl: nil))
            }
            imgShowView.reloadData(showBeans) { (beans, curIndex) in
                selectBlock(beans, curIndex)
            }
        }
    }
}
