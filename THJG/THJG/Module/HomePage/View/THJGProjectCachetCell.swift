/**
 * 项目用章登记信息cell
 */

import UIKit

class THJGProjectCachetCell: UITableViewCell {
    
    
    @IBOutlet weak var statusView: UIImageView!
    @IBOutlet weak var fileNameLabel: UILabel!
    @IBOutlet weak var fileNameLabelTrailing: NSLayoutConstraint!
    @IBOutlet weak var departmentTitleLabel: UILabel!
    @IBOutlet weak var departmentLabel: UILabel!
    @IBOutlet weak var inspectorTitleLabel: UILabel!
    @IBOutlet weak var inspectorContentLabel: UILabel!
    @IBOutlet weak var inspectorContentY: NSLayoutConstraint!
    @IBOutlet weak var remarkTitleLabel: UILabel!
    @IBOutlet weak var remarkContentLabel: UILabel!
    @IBOutlet weak var remarkContenY: NSLayoutConstraint!
    @IBOutlet weak var resContainerView: UIView!
    var imgShowView: THJGBriefImgShowView!
    @IBOutlet weak var seperator: UIView!
    
    
    var bean: ProjectCachetCellBean! {
        didSet {
            //调整UI
            //外借标志
            statusView.isHidden = bean.cachetOut == 0
            fileNameLabelTrailing.constant = bean.cachetOut == 0 ? 16 : 70
            
            //监管人员
            inspectorTitleLabel.isHidden = DQSUtils.isBlank(bean.cachetInspector)
            inspectorContentLabel.isHidden = inspectorTitleLabel.isHidden
            
            //备注
            remarkTitleLabel.isHidden = DQSUtils.isBlank(bean.cachetRemark)
            remarkContentLabel.isHidden = remarkTitleLabel.isHidden
            
            //凭证
            resContainerView.isHidden = bean.cachetResources.isEmpty
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgShowView = THJGBriefImgShowView.showBriefImgView()
        resContainerView.addSubview(imgShowView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imgShowView.frame = resContainerView.bounds
    }
    
    func reloadData(_ bean: ProjectCachetCellBean,
                    isLastBean: Bool,
                    selectBlock: @escaping ImgShowBlock) {
        //调整UI
        self.bean = bean
        seperator.isHidden = isLastBean
        
        //赋值内容
        //文件名称
        if DQSUtils.isNotBlank(bean.cachetType) {
            fileNameLabel.attributedText = DQSUtils.showString(sourceString: bean.cachetFileName + "（\(bean.cachetPortions)份/\(bean.cachetType)）", neededHandledString: "（\(bean.cachetPortions)份/\(bean.cachetType)）", neededHandledParam: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor: DQSUtils.rgbColor(150, 150, 150)])
        } else {
            fileNameLabel.attributedText = DQSUtils.showString(sourceString: bean.cachetFileName + "（\(bean.cachetPortions)份）", neededHandledString: "（\(bean.cachetPortions)份）", neededHandledParam: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor: DQSUtils.rgbColor(150, 150, 150)])
        }
        
        //用章人员
        var departmentAndUser = bean.cachetDepartment
        if DQSUtils.isNotBlank(bean.cachetUser) {
            if DQSUtils.isNotBlank(departmentAndUser) {
                departmentAndUser = "\(bean.cachetDepartment) - \(bean.cachetUser)"
            } else {
                departmentAndUser = bean.cachetUser
            }
        }
        departmentTitleLabel.isHidden = DQSUtils.isBlank(departmentAndUser)
        departmentLabel.text = departmentAndUser

        //监管人员
        inspectorContentLabel.text = bean.cachetInspector
        if DQSUtils.isNotBlank(departmentAndUser) {
            let textHeight = DQSUtils.heightForText(text: departmentAndUser, fixedWidth: SCREEN_WIDTH-116, fixedFont: UIFont.systemFont(ofSize: 14))
            inspectorContentY.constant = max(60, textHeight+30)
        } else {
            inspectorContentY.constant = 24
        }
        
        //备注
        remarkContentLabel.text = bean.cachetRemark
        let userHeight = DQSUtils.heightForText(text: departmentAndUser, fixedWidth: SCREEN_WIDTH-116, fixedFont: UIFont.systemFont(ofSize: 14)) + 10
        let inspectHeight = DQSUtils.heightForText(text: bean.cachetInspector, fixedWidth: SCREEN_WIDTH-116, fixedFont: UIFont.systemFont(ofSize: 14)) + 10
        remarkContenY.constant = 20 + (DQSUtils.isNotBlank(departmentAndUser) ? max(40, userHeight) : 0) + (DQSUtils.isNotBlank(bean.cachetInspector) ? max(40, inspectHeight) : 0)
        
        //资源
        if !bean.cachetResources.isEmpty {
            var showBeans = [THJGImgShowBean]()
            for res in bean.cachetResources {
                if res.cachetResUrl.isLocalVideo() {//本地视频
                    showBeans.append(THJGImgShowBean(imgUrl: "", imgName: res.cachetResName, isVideo: true, videoType: 20, videoStatus: nil, videoSerial: nil, videoUrl: res.cachetResUrl))
                } else {//图片或pdf
                    showBeans.append(THJGImgShowBean(imgUrl: res.cachetResUrl, imgName: res.cachetResName, isVideo: false, videoType: nil, videoStatus: nil, videoSerial: nil, videoUrl: nil))
                }
            }
            imgShowView.reloadData(showBeans) { (beans, curIndex) in
                selectBlock(beans, curIndex)
            }
        }
    }
    
    
}
